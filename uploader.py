import sqlalchemy
import json
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import sessionmaker
import xml.etree.ElementTree as ET

Base = automap_base()

class TrafficDatabaseLoader:
    def __init__(self, config_path):
        with open(config_path) as config_file:
            config = json.load(config_file)
            
        engine_str = f'postgresql://{config["username"]}:{config["password"]}@{config["host"]}:{config["port"]}/{config["database"]}'
        self.engine = sqlalchemy.create_engine(engine_str)

        self.session_maker = sessionmaker(bind=self.engine)
        
        Base.prepare(self.engine, reflect=True)
        
    
    def import_from_osm(self, osm_path):
        with open(osm_path) as file:
            root = ET.fromstring(file.read())
            
        def add_instance(container, Base, class_name, data):
            cls = Base.classes[class_name]
            processed_data = {}
            for key, value in data.items():
                if key in cls.__dict__:
                    processed_data[key] = value
            if class_name not in container:
                container[class_name] = []
            container[class_name].append(processed_data)
            return container
            
        container = {}

        for element in root:
            if element.tag == 'node':
                dct = {'id': element.attrib['id'], 'latitude': element.attrib['lat'], 'longitude': element.attrib['lon']}
                add_instance(container, Base, 'node', dct)
                for tag in element:
                    tag.attrib['node_id'] = element.attrib['id']
                    add_instance(container, Base, 'node_tag', tag.attrib)
            if element.tag == 'way':
                add_instance(container, Base, 'way', element.attrib)
                seq_id = 0
                for way_elem in element:
                    if way_elem.tag == 'tag':
                        way_elem.attrib['way_id'] = element.attrib['id']
                        add_instance(container, Base, 'way_tag', way_elem.attrib)
                    elif way_elem.tag == 'nd':
                        dct = {'way_id':element.attrib['id'], 'sequence_id':seq_id, 'node_id': way_elem.attrib['ref']}
                        add_instance(container, Base, 'way_node_m2m', dct)
                        seq_id += 1
            if element.tag == 'relation':
                add_instance(container, Base, 'relation', element.attrib)
                seq_id = 0
                for relation_elem in element:
                    if relation_elem.tag == 'tag':
                        relation_elem.attrib['relation_id'] = element.attrib['id']
                        add_instance(container, Base, 'relation_tag', relation_elem.attrib)
                    elif relation_elem.tag == 'member':
                        dct = {'relation_id':element.attrib['id'], 
                               'sequence_id':seq_id, 
                               'member_id': relation_elem.attrib['ref'],
                               'member_role':relation_elem.attrib['role'],
                               'member_type':relation_elem.attrib['type']}
                        add_instance(container, Base, 'relation_member', dct)
                        seq_id += 1
                        
        for class_name, values_to_insert in container.items():
            session = self.session_maker()
            try:
                stmt = sqlalchemy.dialects.postgresql.insert(Base.classes[class_name]).values(values_to_insert)
                stmt = stmt.on_conflict_do_nothing()
                session.execute(stmt)     
                session.commit()
            except:
                session.rollback()
                raise
            finally:
                session.close()