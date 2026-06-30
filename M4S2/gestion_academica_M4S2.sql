create database gestion_academica_universidad;

create table estudiante(
	id_estudiante serial primary key ,
	nombre_completo varchar(250) not null,
	correo_electronico varchar(250) not null unique,
	genero varchar(20) not null check (genero in ('Masculino','Femenino','Otro')),
	identificacion varchar(20) not null unique,
	carrera varchar(250) not null,
	fecha_nacimiento date not null,
	fecha_ingreso date not null
);

create table docente(
	id_docente serial primary key,
	nombre_completo varchar(250) not null,
	correo_institucional varchar(250) not null unique,
	departamento_academico varchar(250) not null,
	anios_experiencia int not null check(anios_experiencia >= 0)
);

create table curso(
	id_curso serial primary key,
	nombre varchar(250) not null,
	codigo varchar not null unique,
	creditos int not null check(creditos >= 1),
	semestres int not null check(semestres >= 1),
	id_docente int,
	
	constraint fk_docente
	foreign key (id_docente)
	references docente(id_docente)
	on delete restrict
);

create table inscripcion(
	id_inscripciones serial primary key,
	id_estudiante int not null,
	id_curso int not null,
	fecha_incripcion date not null,
	calificacion_final decimal(4,2) check(calificacion_final between 0 and 5),
	
	constraint fk_estudiante
	foreign key (id_estudiante)
	references estudiante(id_estudiante)
	on delete restrict,
	
	constraint fk_curso
	foreign key (id_curso)
	references curso(id_curso)
	on delete restrict
);

insert into estudiante (nombre_completo, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso)
values ('Yaila Ustate','yaila@correo.com','Femenino','100000001','Ingeniería de Sistemas','2008-05-19','2025-01-20'),
('Sherick De La Cruz','sherick@correo.com','Masculino','100000002','Licenciatura en Idiomas','2009-10-17','2025-01-20'),
('Melany Argaez','melany@correo.com','Femenino','100000003','Negocios y Comercio Internacionales','2008-12-27','2025-01-20'),
('Andrea Olave','andrea@correo.com','Femenino','100000004','Diseño Gráfico','2008-10-25','2025-01-20'),
('Danna Mares','danna@correo.com','Femenino','100000005','Química y Farmacia','2008-12-15','2025-01-20'),
('Adriana Viana','adriana@correo.com','Femenino','100000006','Derecho','2008-12-01','2025-01-20'),
('Mia Yalok','mia@correo.com','Femenino','100000007','Licenciatura en Lengua Castellana','2008-10-24','2025-01-20');


insert into docente (nombre_completo, correo_institucional, departamento_academico, anios_experiencia)
values ('Olga Arango','olga@universidad.edu','Ingeniería',10),
('Jose Diaz','jose@universidad.edu','Humanidades',7),
('Juan Perez','juan@universidad.edu','Ciencias Económicas',4),
('Monica Antequera','monica@universidad.edu','Ciencias de la Salud',12);


insert into curso (nombre, codigo, creditos, semestres, id_docente)
values('Programación I','SIS101',4,1,1),
('Didáctica de la Lengua','IDI201',3,2,2),
('Comercio Internacional','COM301',4,3,3),
('Farmacología General','FAR401',5,4,4);


insert into inscripcion (id_estudiante, id_curso, fecha_incripcion, calificacion_final)
values (1,1,'2025-02-01',4.8),
(1,3,'2025-02-02',4.5),   
(2,2,'2025-02-03',4.2),   
(3,3,'2025-02-04',4.7),   
(4,2,'2025-02-05',4.4),   
(5,4,'2025-02-06',4.9),   
(6,3,'2025-02-07',3.9),   
(7,2,'2025-02-08',4.6); 



select 
e.nombre_completo as estudiante,
c.nombre as curso,
d.nombre_completo as docente,
i.fecha_incripcion,
i.calificacion_final
from estudiante e
inner join inscripcion i
	on e.id_estudiante = i.id_estudiante 
inner join curso c
	on i.id_curso = c.id_curso
inner join docente d
	on c.id_docente  = d.id_docente
order by e.nombre_completo;


select
c.nombre as curso,
d.nombre_completo as docente, 
d.anios_experiencia
from curso c
inner join docente d 
	on c.id_docente = d.id_docente 
	where d.anios_experiencia > 5;


select 
c.nombre as curso,
round(avg(i.calificacion_final),2) as promedio
from curso c
inner join inscripcion i 
	on c.id_curso = i.id_curso
group by c.nombre;


select
e.nombre_completo as estudiante,
count(i.id_curso) as cantidad_cursos
from estudiante e 
inner join inscripcion i 
	on e.id_estudiante = i.id_estudiante 
group by e.nombre_completo 
having count (i.id_curso) > 1;


alter table estudiante 
add column estado_academico varchar(30);

update estudiante e 
set estado_academico = 'Activo'


delete from docente 
where id_docente=3;



select
c.nombre,
count(i.id_estudiante) as estudiante
from curso c  
inner join inscripcion i 
	on i.id_curso = c.id_curso 
group by c.nombre 
having count (i.id_estudiante ) > 2;	

select 
    e.nombre_completo as estudiante,
    round(avg(i.calificacion_final),2) as promedio_estudiante
from estudiante e
inner join inscripcion i
    on e.id_estudiante = i.id_estudiante
group by e.nombre_completo
having AVG(i.calificacion_final) >
(
    select AVG(i2.calificacion_final)
    from inscripcion i2
);


select distinct 
e.carrera
from estudiante e 
where e.id_estudiante in
(
	select i.id_estudiante
	from inscripcion i
	inner join curso c
	on i.id_curso = c.id_curso
	where c.semestres > 2
);


select 
e.nombre_completo,
e.carrera
from estudiante e 
where exists
(
	select 1
	from inscripcion i 
	inner join curso c 
		on	i.id_curso = c.id_curso 
	where i.id_estudiante = e.id_estudiante 
	and c.semestres >= 2
);


select 
count(i2.id_inscripciones ) as total_incripciones,
round(avg(i2.calificacion_final),2) as promedio_general,
max(i2.calificacion_final) as nota_maxima,
min(i2.calificacion_final) as nota_minima,
sum(i2.calificacion_final) as suma_calificaciones
from inscripcion i2; 



select 
c.nombre as curso,
count(i2.id_inscripciones) as inscritos,
round(avg(i2.calificacion_final),2) as promedio,
max(i2.calificacion_final) as mejor_nota,
min(i2.calificacion_final) as peor_nota

from curso c
inner join inscripcion i2
	on c.id_curso = i2.id_curso
group by c.nombre;



create view vista_historial_academico as
select
e.nombre_completo as estudiante,
c.nombre as curso,
d.nombre_completo as docente,
c.semestres,
i.calificacion_final
from estudiante e 
inner join inscripcion i 
	on e.id_estudiante = i.id_estudiante
inner join curso c
	on	i.id_curso = c.id_curso
inner join docente d 
	on c.id_docente = d.id_docente;


select * from vista_historial_academico vha 


create role revisor_academico;


grant select 
on vista_historial_academico
to revisor_academico



SELECT *
FROM vista_historial_academico;


revoke insert, update, delete 
on inscripcion
from revisor_academico;


SELECT usename 
FROM pg_user;

grant revisor_academico to yailauc;


select * from inscripcion;

BEGIN;

ROLLBACK;

BEGIN;

UPDATE inscripcion
SET calificacion_final = 5.0
WHERE id_inscripciones = 1;


SELECT *
FROM inscripcion
WHERE id_inscripciones = 1;

SAVEPOINT cambio_nota;

UPDATE inscripcion
SET calificacion_final = 1.0
WHERE id_inscripciones = 1;

ROLLBACK TO cambio_nota;


SELECT *
FROM inscripcion
WHERE id_inscripciones = 1;


COMMIT;
























