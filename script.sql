------------------------------------------------RESET TABLES-------------------------------------------------------------------
drop table if exists administrator;
drop table if exists mentors;
drop table if exists students_classes;
drop table if exists students;
drop table if exists volunteers;
drop table if exists classes;
drop table if exists topics;
drop table if exists images;

------------------------------------------------CREATE TABLES-------------------------------------------------------------------
CREATE TABLE topics (
  id            SERIAL PRIMARY KEY,
  topic_name    VARCHAR(50) NOT NULL
);

CREATE TABLE classes (
    id             SERIAL PRIMARY KEY,
    class_name     VARCHAR(50) NOT NULL,
    topic_id       INTEGER NOT NULL REFERENCES topics(id),
    start_time     TIMESTAMP NOT null,
    end_time       TIMESTAMP NOT null
);


CREATE TABLE volunteers(
    id                  SERIAL PRIMARY KEY,
    volunteers_name     VARCHAR(50) NOT NULL,
    speciality          VARCHAR(120),
    active              BOOLEAN
);


CREATE TABLE students (
    id                 SERIAL PRIMARY KEY,
    students_name      VARCHAR(50) NOT NULL,
    volunteer_id       INTEGER REFERENCES volunteers(id),
    avatar_id          INTEGER references images(id)
);


CREATE TABLE students_classes (
   student_id INTEGER REFERENCES students(id),
   class_id   INTEGER REFERENCES classes(id)
);


CREATE TABLE mentors (
    id                SERIAL PRIMARY KEY,
    mentors_name      VARCHAR(50) NOT NULL,
    speciality        VARCHAR(120),
    mentor_id         INTEGER NOT NULL REFERENCES topics(id),
    class_id          INTEGER NOT NULL REFERENCES classes(id),
    student_id        INTEGER NOT NULL REFERENCES students(id)
);


CREATE TABLE administrator (
    id                  SERIAL PRIMARY KEY,
    administrator_name  VARCHAR(50) NOT NULL,
    volunteer_id        INTEGER REFERENCES volunteers(id),
    mentos_id           INTEGER REFERENCES mentors(id),
    student_id          INTEGER REFERENCES students(id)
);
-------------------------------------INSERT DATA INTO-------------------------------------------------------------------
------------------------------------------TOPICS-------------------------------------------------------------------
insert into  topics (topic_name) values ('JavaScript');
insert into  topics (topic_name) values ('React');
insert into  topics (topic_name) values ('Node');
--all topics
SELECT * FROM topics  ORDER BY topic_name 


-----------------------------------------CLASSES-------------------------------------------------------------------
INSERT INTO classes (class_name, topic_id , start_time, end_time ) 
VALUES ('JavaScript Week 1','1','2021-01-01 18:00:00','2021-01-01 22:00:00');

INSERT INTO classes (class_name, topic_id ,start_time, end_time ) 
VALUES ('React Week 1','2','2021-01-02 18:00:00','2021-01-01 22:00:00');

INSERT INTO classes (class_name, topic_id , start_time, end_time ) 
VALUES ('Node Week 3','1','2021-01-03 18:00:00','2021-01-01 22:00:00');

--all classes
SELECT * FROM classes ORDER BY class_name; 


---------------------------------------VOLUNTEERS------------------------------------------------------------------------------------------
insert into volunteers (volunteers_name, speciality, active)
values ('Tom', 'React', true);
insert into volunteers (volunteers_name, speciality, active)
values ('Lino', 'JavaScript', true);
insert into volunteers (volunteers_name, speciality, active)
values ('Mary', 'LinkedIn', true);
insert into volunteers (volunteers_name, speciality, active)
values ('Miriam', 'HTML', false);


-----------------------------------------STUDENTS--------------------------------------------------------------------------
insert into students (students_name, volunteer_id, avatar_id)
values ('Mary', '2', 1);
insert into students (students_name, volunteer_id, avatar_id)
values ('Ali', '1', 2);
insert into students (students_name, volunteer_id, avatar_id)
values ('Marcus', '3', 3);
insert into students (students_name, volunteer_id, avatar_id)
values ('James', '2', 1);

--GET all students
SELECT * FROM students  ORDER BY students_name; 

--GET img
select i.image_url from students s
join images i on i.id = s.avatar_id 
where s.id = 1;

select i.image_url as "image" from students s
join images i on i.id = s.avatar_id 
where s.id = 1;

-- the classes that Mary is attending
select c.class_name from students s 
join students_classes sc on s.id = sc.student_id
join classes c on sc.class_id = c.id 
where s.students_name = 'Mary';



--all students that are attending the JS Week1 class
select * from students s 
join students_classes sc on sc.student_id = s.id 
join classes c on c.id = sc.class_id 
where c.class_name like '%JavaScript%';




--POST create a student
/*INSERT INTO students (students_name, volunteer_id, avatar_id) 
VALUES ('Jameson', '2', 4);*/

UPDATE students
SET students_name = 'Student 09.01',
    volunteer_id = '2',
    avatar_id = '3';




----------------------------------STUDENT_CLASSES--------------------------------------------------------------------------------
insert into students_classes (student_id, class_id)
values('1', '1');
insert into students_classes (student_id, class_id)
values('2', '3');
insert into students_classes (student_id, class_id)
values('3', '2');

--- get students by class id
SELECT * FROM students_classes where class_id = 1; 




--create a student
INSERT INTO students (students_name, volunteer_id, avatar_id)  VALUES ($1, $2, $3)
-- crear una clase
INSERT INTO classes (class_name, topic_id, start_time, end_time) VALUES ($1, $2, $3, $4)
-- crear un topic
INSERT INTO topics (topic_name)  VALUES ($1)
-- asignar un student a una class
INSERT INTO students_classes (student_id, class_id)  VALUES ($1, $2)




----------------------------------IMAGES-----------------------------------------------------------------------
-- PostgreSQL database dump
--

-- Dumped from database version 12.1
-- Dumped by pg_dump version 12.1

-- Started on 2020-05-26 11:02:31
/*
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 203 (class 1259 OID 49321)
-- Name: images; Type: TABLE; Schema: public; Owner: tutorial
--*/

CREATE TABLE IF NOT EXISTS images (
  id SERIAL PRIMARY KEY,
  title VARCHAR(128) NOT NULL,
  cloudinary_id VARCHAR(128) NOT NULL,
  image_url VARCHAR(128) NOT NULL
);

insert into images (title, cloudinary_id,image_url) values ('Avatar 1', 'pweihantdtl5g7qmmvzu', 
'https://res.cloudinary.com/cloudydays/image/upload/v1609955755/pweihantdtl5g7qmmvzu.png');

DELETE FROM images WHERE cloudinary_id = 'pweihantdtl5g7qmmvzu';
DELETE FROM images WHERE title = 'Avatar 1';

insert into images (title, cloudinary_id,image_url) values ('Avatar 1', 'laatqwytokrj0ccxtfyw', 
'https://res.cloudinary.com/cloudydays/image/upload/v1610009751/laatqwytokrj0ccxtfyw.png');
insert into images (title, cloudinary_id,image_url) values ('Avatar 2', 'jvvj94dpiupkc4u6n9yw', 
'https://res.cloudinary.com/cloudydays/image/upload/v1610009756/jvvj94dpiupkc4u6n9yw.png');
insert into images (title, cloudinary_id,image_url) values ('Avatar 3', 'akkjpekhi2moenizdyou', 
'https://res.cloudinary.com/cloudydays/image/upload/v1610009153/akkjpekhi2moenizdyou.png');
/*To comment out a block of text, select the text, then press Ctrl+Shift+/ 
or right-click it and click Format -> Toggle Block Comment on the context menu.*/

/*CREATE TABLE public.images (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    cloudinary_id character varying(128) NOT NULL,
    image_url character varying(128) NOT NULL
);*/

/*
ALTER TABLE public.images OWNER TO tutorial;

--
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.images_id_seq OWNER TO tutorial;

--
-- TOC entry 2823 (class 0 OID 0)
-- Dependencies: 202
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tutorial
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- TOC entry 2687 (class 2604 OID 49324)
-- Name: images id; Type: DEFAULT; Schema: public; Owner: tutorial
--

--ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- TOC entry 2817 (class 0 OID 49321)
-- Dependencies: 203
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: tutorial
--

COPY public.images (id, title, cloudinary_id, image_url) FROM stdin;
8	Heroku Image	ywdrgacv79cg18ap0w7l	https://res.cloudinary.com/dunksyqjj/image/upload/v1590431624/ywdrgacv79cg18ap0w7l.jpg
\.


--
-- TOC entry 2824 (class 0 OID 0)
-- Dependencies: 202
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tutorial
--

SELECT pg_catalog.setval('public.images_id_seq', 8, true);


--
-- TOC entry 2689 (class 2606 OID 49326)
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: tutorial
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


-- Completed on 2020-05-26 11:02:33

--
-- PostgreSQL database dump complete
--*/











