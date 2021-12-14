CREATE SCHEMA public;

CREATE TABLE public.stop
(
    stop_id     uuid PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT NOT NULL,
    latitude    float,
    longitude   float
);

CREATE TABLE public.transport_type
(
    transport_type_id uuid PRIMARY KEY,
    name              TEXT NOT NULL
);

CREATE TABLE public.transport_model
(
    transport_model_id uuid PRIMARY KEY,
    transport_type_id  uuid,
    CONSTRAINT transport_type
        FOREIGN KEY (transport_type_id)
            REFERENCES public.transport_type (transport_type_id)
);

CREATE TABLE public.relation
(
    relation_id uuid PRIMARY KEY,
    name        TEXT NOT NULL
);

CREATE TABLE public.route
(
    route_id    uuid PRIMARY KEY,
    relation_id uuid,
    CONSTRAINT related_path
        FOREIGN KEY (relation_id)
            REFERENCES public.relation (relation_id)
);

CREATE TABLE public.route_transport_m2m
(
    transport_model_id uuid,
    route_id           uuid,
    amount             integer NOT NULL DEFAULT 1,
    CONSTRAINT related_transport_model
        FOREIGN KEY (transport_model_id)
            REFERENCES public.transport_model (transport_model_id),
    CONSTRAINT related_route
        FOREIGN KEY (route_id)
            REFERENCES public.route (route_id),
    CONSTRAINT "transport_route_pkey" PRIMARY KEY (transport_model_id, route_id)
);

CREATE TABLE public.stop_transport_type_m2m
(
    transport_type_id uuid,
    stop_id           uuid,
    CONSTRAINT related_transport_type
        FOREIGN KEY (transport_type_id)
            REFERENCES public.transport_type (transport_type_id),
    CONSTRAINT related_stop
        FOREIGN KEY (stop_id)
            REFERENCES public.stop (stop_id),
    CONSTRAINT "stop_transport_pkey" PRIMARY KEY (transport_type_id, stop_id)
);

CREATE TABLE public.relation_tag
(
    relation_id uuid,
    key         TEXT,
    value       TEXT,
    CONSTRAINT related_relation
        FOREIGN KEY (relation_id)
            REFERENCES public.relation (relation_id),
    CONSTRAINT "relation_tag_pkey" PRIMARY KEY (relation_id, key)
);

CREATE TABLE public.relation_member
(
    relation_id uuid,
    member_type TEXT, --way, node, stop or relation
    member_id   uuid,
    member_role TEXT,
    sequence_id integer,
    CONSTRAINT "relation_member_pkey" PRIMARY KEY (relation_id, member_type, member_id, member_role, sequence_id)
);

CREATE TABLE public.node
(
    node_id   uuid PRIMARY KEY,
    name      TEXT NOT NULL,
    latitude  float,
    longitude float
);


CREATE TABLE public.node_tag
(
    node_id uuid,
    key     TEXT,
    value   TEXT,
    CONSTRAINT related_node
        FOREIGN KEY (node_id)
            REFERENCES public.node (node_id),
    CONSTRAINT "node_tag_pkey" PRIMARY KEY (node_id, key)
);

CREATE TABLE public.way
(
    way_id uuid PRIMARY KEY,
    name   TEXT NOT NULL
);

CREATE TABLE public.way_tag
(
    way_id uuid,
    key    TEXT,
    value  TEXT,
    CONSTRAINT related_way
        FOREIGN KEY (way_id)
            REFERENCES public.way (way_id),
    CONSTRAINT "way_tag_pkey" PRIMARY KEY (way_id, key)
);

CREATE TABLE public.way_node_m2m
(
    node_id     uuid,
    way_id      uuid,
    sequence_id integer,
    CONSTRAINT related_way
        FOREIGN KEY (way_id)
            REFERENCES public.way (way_id),
    CONSTRAINT related_node
        FOREIGN KEY (node_id)
            REFERENCES public.node (node_id),
    CONSTRAINT "way_node_pkey" PRIMARY KEY (node_id, way_id, sequence_id)
);