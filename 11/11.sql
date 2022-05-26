create view S_VIEW as select odId, comment from Comments;

DROP TRIGGER "main"."S_trigger";
CREATE TRIGGER S_trigger after insert on OrderDetails
    begin
       INSERT into Comments(comment, odId) VALUES ('comment', new.id);
    end

create table OrderDetails
(
    Id integer primary key AUTOINCREMENT
);

insert into OrderDetails default values;


create table Comments
(
    Id integer primary key AUTOINCREMENT,
    comment text,
	odId integer,
    FOREIGN KEY (odId) REFERENCES OrderDetails(Id)
);

insert into OrderDetails default values;

insert into Comments(comment, odId) values ('regegr', 1);