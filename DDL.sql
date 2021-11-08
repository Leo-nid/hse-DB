CREATE TABLE traffic.stop
(
    stop_id     uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        TEXT NOT NULL,
    description TEXT NOT NULL,
    latitude    float8,
    longitude   float8
);

CREATE TABLE traffic.transport_type
(
    transport_type_id uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name              TEXT NOT NULL
);

CREATE TABLE traffic.transport_model
(
    transport_model_id uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    transport_type_id  uuid,
    CONSTRAINT transport_type
        FOREIGN KEY (transport_type_id)
            REFERENCES traffic.transport_type (transport_type_id)
);

CREATE TABLE traffic.relation
(
    relation_id uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        TEXT NOT NULL
);

CREATE TABLE traffic.route
(
    route_id    uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    relation_id uuid,
    CONSTRAINT related_path
        FOREIGN KEY (relation_id)
            REFERENCES traffic.relation (relation_id)
);

CREATE TABLE traffic.route_transport_m2m
(
    transport_model_id uuid PRIMARY KEY,
    route_id           uuid PRIMARY KEY,
    amount             int8 NOT NULL DEFAULT 1,
    CONSTRAINT related_transport_model
        FOREIGN KEY (transport_model_id)
            REFERENCES traffic.transport_model (transport_model_id),
    CONSTRAINT related_route
        FOREIGN KEY (route_id)
            REFERENCES traffic.route (route_id)
);

CREATE TABLE traffic.stop_transport_type
(
    transport_type_id  uuid PRIMARY KEY,
    stop_id     uuid PRIMARY KEY,
    CONSTRAINT related_transport_type
        FOREIGN KEY (transport_type_id)
            REFERENCES traffic.transport_type (transport_type_id),
    CONSTRAINT related_stop
        FOREIGN KEY (stop_id)
            REFERENCES traffic.stop (stop_id)
);

CREATE TABLE traffic.relation_tag
(
    relation_id uuid PRIMARY KEY,
    key TEXT PRIMARY KEY,
    value TEXT,
    CONSTRAINT related_relation
        FOREIGN KEY (relation_id)
            REFERENCES traffic.relation (relation_id)
);

CREATE TABLE traffic.relation_member
(
    relation_id uuid PRIMARY KEY,
    member_type anyenum PRIMARY KEY,
    member_id uuid PRIMARY KEY,
    member_role TEXT PRIMARY KEY,
    sequence_id int8 PRIMARY KEY
);

CREATE TABLE traffic.node
(
    node_id uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        TEXT NOT NULL,
    latitude float8,
    longitude float8
);


CREATE TABLE traffic.node_tag
(
    node_id uuid PRIMARY KEY,
    key TEXT PRIMARY KEY,
    value TEXT,
    CONSTRAINT related_node
        FOREIGN KEY (node_id)
            REFERENCES traffic.node (node_id)
);

CREATE TABLE traffic.way
(
    way_id uuid PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        TEXT NOT NULL
);

CREATE TABLE traffic.way_tag
(
    way_id uuid PRIMARY KEY,
    key TEXT PRIMARY KEY,
    value TEXT,
    CONSTRAINT related_way
        FOREIGN KEY (way_id)
            REFERENCES traffic.way (way_id)
);

CREATE TABLE traffic.way_node
(
    node_id  uuid PRIMARY KEY,
    way_id     uuid PRIMARY KEY,
    CONSTRAINT related_way
        FOREIGN KEY (way_id)
            REFERENCES traffic.way (way),
    CONSTRAINT related_node
        FOREIGN KEY (node_id)
            REFERENCES traffic.node (node_id)
);