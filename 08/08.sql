--1. �������� ��������� ��������� ������������ ��� �������� LOB
create tablespace tabslespace_08
datafile 'C:\8\lob.dbf'
size 50m autoextend on next 1m;

--2.�������� ��������� ����� ��� �������� ������� WORD (��� PDF) ����������. 
create directory LOBS8 as 'C:\8\folder';


--3.�������� ������������ lob_user � ������������ ������������ ��� �������, ���������� � �������� ������� ��������.
create user C##zei_lob identified by liza123456;
grant all privileges to  C##zei_lob;

grant read, write on directory LOBS8 to C##zei_lob;

alter user C##zei_lob container=all;
select * from v$tablespace

--4.�������� ����� �� ������ ��������� ������������ ������������ lob_user.
alter user C##zei_lob default tablespace tabslespace_08
quota unlimited on tabslespace_08
account unlock container=current;

--5.�������� � �����-���� ������� ��������� �������:
--� FOTO BLOB: ��� �������� ����������;
--� DOC (��� PDF) BFILE: ��� �������� ������� WORD (��� PDF) ����������.
create table BigFiles (
    id number(5) primary key,
    FOTO BLOB,
    DOC_FILE BFILE
);

--6.�������� (INSERT) ���������� � ��������� � �������.
insert into BigFiles values(1, BFILENAME('LOBS8', 'goodboy.jpg'), null);
insert into BigFiles values(2, BFILENAME('LOBS8', 'svoy.png'), null);
insert into BigFiles values(3, null, BFILENAME('LOBS8', 'doc.doc'));
select * from BigFiles;

DECLARE
l_bfile BFILE;
l_blob BLOB;
l_dest_offset INTEGER := 1;
l_src_offset INTEGER := 1;
BEGIN
INSERT INTO BigFiles(id, FOTO, DOC_FILE) values (7, empty_blob(), null)
RETURN FOTO INTO l_blob;
l_bfile := BFILENAME('LOBS8', 'svoy.png');
DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
DBMS_LOB.loadblobfromfile (dest_lob => l_blob, src_bfile => l_bfile, amount => DBMS_LOB.lobmaxsize, dest_offset => l_dest_offset, src_offset => l_src_offset);
DBMS_LOB.fileclose(l_bfile);
COMMIT;
END;


select * from BigFiles

delete from BigFiles