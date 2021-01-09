drop table if exists administrator;
drop table if exists mentors;
drop table if exists students_classes;
drop table if exists students;
drop table if exists volunteers;
drop table if exists classes;
drop table if exists topics;


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
    homework_done      BOOLEAN
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


--TOPICS
insert into  topics (topic_name) values ('JavaScript');
insert into  topics (topic_name) values ('React');
insert into  topics (topic_name) values ('Node');
--all topics
SELECT * FROM topics  ORDER BY topic_name 

--CLASSES
INSERT INTO classes (class_name, topic_id , start_time, end_time ) 
VALUES ('JavaScript Week 1','1','2021-01-01 18:00:00','2021-01-01 22:00:00');

INSERT INTO classes (class_name, topic_id ,start_time, end_time ) 
VALUES ('React Week 1','2','2021-01-02 18:00:00','2021-01-01 22:00:00');

INSERT INTO classes (class_name, topic_id , start_time, end_time ) 
VALUES ('Node Week 3','1','2021-01-03 18:00:00','2021-01-01 22:00:00');

--all classes
SELECT * FROM classes ORDER BY class_name 


--VOLUNTEERS
insert into volunteers (volunteers_name, speciality, active)
values ('Tom', 'React', true);
insert into volunteers (volunteers_name, speciality, active)
values ('Lino', 'JavaScript', true);
insert into volunteers (volunteers_name, speciality, active)
values ('Mary', 'LinkedIn', true);
insert into volunteers (volunteers_name, speciality, active)
values ('Miriam', 'HTML', false);


--STUDENTS
insert into students (students_name, volunteer_id, homework_done)
values ('Mary', '2', true);
insert into students (students_name, volunteer_id, homework_done)
values ('Ali', '1', false);
insert into students (students_name, volunteer_id, homework_done)
values ('Marcus', '3', false);

--all students
SELECT * FROM students  ORDER BY students_name 

--STUDENTS_CLASSES
insert into students_classes (student_id, class_id)
values('1', '1');
insert into students_classes (student_id, class_id)
values('2', '3');
insert into students_classes (student_id, class_id)
values('3', '2');

--- get students by class id
SELECT * FROM students_classes ORDER BY class_id 


-- crear un student
INSERT INTO students (students_name, volunteer_id, homework_done) 
VALUES ('Jameson', '2', true);


-- crear una clase
-- crear un topic



-- asignar un student a una class












