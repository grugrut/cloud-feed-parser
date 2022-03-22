CREATE SCHEMA cloudupdate;

-- blog feeds --

CREATE TABLE cloudupdate.aws_blog_feed (
    id character varying(40) NOT NULL,
    source character varying(16) NOT NULL,
    title character varying(256) NOT NULL,
    link character varying(256) NOT NULL,
    summary character varying(1024),
    published timestamp with time zone NOT NULL
);

CREATE SEQUENCE cloudupdate.aws_blog_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE cloudupdate.aws_blog_tag (
    id integer DEFAULT nextval('cloudupdate.aws_blog_tag_id_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL
);

CREATE TABLE cloudupdate.aws_blog_tagging (
    feed_id character varying(40) NOT NULL,
    tag_id integer NOT NULL
);

ALTER TABLE ONLY cloudupdate.aws_blog_feed
    ADD CONSTRAINT aws_blog_feed_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cloudupdate.aws_blog_tag
    ADD CONSTRAINT aws_blog_tag_name_key UNIQUE (name);

ALTER TABLE ONLY cloudupdate.aws_blog_tag
    ADD CONSTRAINT aws_blog_tag_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cloudupdate.aws_blog_tagging
    ADD CONSTRAINT aws_blog_tagging_pkey PRIMARY KEY (feed_id, tag_id);

ALTER TABLE ONLY cloudupdate.aws_blog_tagging
    ADD CONSTRAINT aws_blog_tagging_feed_id_fkey FOREIGN KEY (feed_id) REFERENCES cloudupdate.aws_blog_feed(id) NOT VALID;

ALTER TABLE ONLY cloudupdate.aws_blog_tagging
    ADD CONSTRAINT aws_blog_tagging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES cloudupdate.aws_blog_tag(id) NOT VALID;

-- What's new feed --

CREATE TABLE cloudupdate.aws_whatsnew_feed (
    id character varying(40) NOT NULL,
    title character varying(256) NOT NULL,
    link character varying(256) NOT NULL,
    summary character varying(1024),
    published timestamp with time zone NOT NULL
);

CREATE SEQUENCE cloudupdate.aws_whatsnew_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE TABLE cloudupdate.aws_whatsnew_tag (
    id integer DEFAULT nextval('cloudupdate.aws_whatsnew_tag_id_seq'::regclass) NOT NULL,
    name character varying(128) NOT NULL
);

CREATE TABLE cloudupdate.aws_whatsnew_tagging (
    feed_id character varying(40) NOT NULL,
    tag_id integer NOT NULL
);

ALTER TABLE ONLY cloudupdate.aws_whatsnew_feed
    ADD CONSTRAINT aws_whatsnew_feed_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cloudupdate.aws_whatsnew_tag
    ADD CONSTRAINT aws_whatsnew_tag_name_key UNIQUE (name);

ALTER TABLE ONLY cloudupdate.aws_whatsnew_tag
    ADD CONSTRAINT aws_whatsnew_tag_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cloudupdate.aws_whatsnew_tagging
    ADD CONSTRAINT aws_whatsnew_tagging_pkey PRIMARY KEY (feed_id, tag_id);

ALTER TABLE ONLY cloudupdate.aws_whatsnew_tagging
    ADD CONSTRAINT aws_whatsnew_tagging_feed_id_fkey FOREIGN KEY (feed_id) REFERENCES cloudupdate.aws_whatsnew_feed(id) NOT VALID;

ALTER TABLE ONLY cloudupdate.aws_whatsnew_tagging
    ADD CONSTRAINT aws_whatsnew_tagging_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES cloudupdate.aws_whatsnew_tag(id) NOT VALID;

