CREATE TABLE public.transport_type
(
    transport_type_id int8 PRIMARY KEY,
    name              TEXT NOT NULL
);

CREATE TABLE public.transport_model
(
    transport_model_id int8 PRIMARY KEY,
    transport_type_id  int8,
    name               TEXT,
    CONSTRAINT transport_type
        FOREIGN KEY (transport_type_id)
            REFERENCES public.transport_type (transport_type_id)
);

CREATE TABLE public.node
(
    id        int8 PRIMARY KEY,
    latitude  float,
    longitude float
);

CREATE TABLE public.way
(
    id int8 PRIMARY KEY
);

CREATE TABLE public.relation
(
    id int8 PRIMARY KEY
);

CREATE TABLE public.route
(
    id          int8 PRIMARY KEY,
    relation_id int8,
    name        TEXT,
    CONSTRAINT related_path
        FOREIGN KEY (relation_id)
            REFERENCES public.relation (id)
);

CREATE TABLE public.route_transport_m2m
(
    transport_model_id int8,
    route_id           int8,
    amount             int8 NOT NULL DEFAULT 1,
    CONSTRAINT related_transport_model
        FOREIGN KEY (transport_model_id)
            REFERENCES public.transport_model (transport_model_id),
    CONSTRAINT related_route
        FOREIGN KEY (route_id)
            REFERENCES public.route (id),
    CONSTRAINT "transport_route_pkey" PRIMARY KEY (transport_model_id, route_id)
);

CREATE TABLE public.stop_transport_type_m2m
(
    transport_type_id int8,
    node_id           int8,
    CONSTRAINT related_transport_type
        FOREIGN KEY (transport_type_id)
            REFERENCES public.transport_type (transport_type_id),
    CONSTRAINT related_stop
        FOREIGN KEY (node_id)
            REFERENCES public.node (id),
    CONSTRAINT "stop_transport_pkey" PRIMARY KEY (transport_type_id, node_id)
);

CREATE TABLE public.relation_tag
(
    relation_id int8,
    k           TEXT,
    v           TEXT,
    CONSTRAINT related_relation
        FOREIGN KEY (relation_id)
            REFERENCES public.relation (id),
    CONSTRAINT "relation_tag_pkey" PRIMARY KEY (relation_id, k)
);


CREATE TABLE public.relation_member
(
    relation_id int8,
    member_type TEXT, --way, node or relation
    member_id   int8,
    member_role TEXT,
    sequence_id int8,
    CONSTRAINT "relation_member_pkey" PRIMARY KEY (relation_id, sequence_id, member_type, member_id, member_role)
);

CREATE TABLE public.node_tag
(
    node_id int8,
    k       TEXT,
    v       TEXT,
    CONSTRAINT related_node
        FOREIGN KEY (node_id)
            REFERENCES public.node (id),
    CONSTRAINT "node_tag_pkey" PRIMARY KEY (node_id, k)
);

CREATE TABLE public.way_tag
(
    way_id int8,
    k      TEXT,
    v      TEXT,
    CONSTRAINT related_way
        FOREIGN KEY (way_id)
            REFERENCES public.way (id),
    CONSTRAINT "way_tag_pkey" PRIMARY KEY (way_id, k)
);

CREATE TABLE public.way_node_m2m
(
    node_id     int8,
    way_id      int8,
    sequence_id int8,
    CONSTRAINT related_way
        FOREIGN KEY (way_id)
            REFERENCES public.way (id),
    CONSTRAINT related_node
        FOREIGN KEY (node_id)
            REFERENCES public.node (id),
    CONSTRAINT "way_node_pkey" PRIMARY KEY (way_id, sequence_id)
);