using  Sample

------����ת��------
if object_id('tb') is not null drop table tb
go

create table tb
(���� varchar(10),
 �γ� varchar(10),
 ���� int)

insert into tb values('����','����',74)
insert into tb values('����','��ѧ',83)
insert into tb values('����','����',93)
insert into tb values('����','����',74)
insert into tb values('����','��ѧ',84)
insert into tb values('����','����',94)
go

select * from tb
-------1. ʹ��SQL Server 2000��̬SQL-----
select ����,
 max(case �γ� when'����'then ���� else 0 end)����,
 max(case �γ� when'��ѧ'then ���� else 0 end)��ѧ,
 max(case �γ� when '����' then ���� else 0 end)����
from tb
group by ����

-------2. ʹ��SQL Server 2000��̬SQL-----
declare @sql varchar(500)
set @sql='select ����'
select @sql=@sql+',max(case �γ� when '''+�γ�+''' then ���� else 0 end)['+�γ�+']'
from(select distinct �γ� from tb ) a--ͬfrom tb group by�γ̣�Ĭ�ϰ��γ�������
set @sql=@sql+' from tb group by ����'
print(@sql)
exec(@sql)


-------���кϲ�-------
if object_id('tb2') is not null drop table tb2
go
create table tb2(id int, value varchar(10))
insert into tb2 values(1, 'aa')
insert into tb2 values(1, 'bb')
insert into tb2 values(2, 'aaa')
insert into tb2 values(2, 'bbb')
insert into tb2 values(2, 'ccc')
go
select * from tb2

-------1. ʹ��SQL Server 2005��-----
select id, [values]=stuff((select ','+[value] from tb2 t where id=tb2.id for xml path('')), 1, 1, '')
from tb2
group by id
-------2. ʹ��SQL Server 2005����OUTER APPLY-----
SELECT * FROM(SELECT DISTINCT id FROM tb2)A OUTER APPLY(
  SELECT [values]= STUFF(REPLACE(REPLACE(
  (
  SELECT value FROM tb2 N
  WHERE id = A.id
  FOR XML AUTO
  ), '<N value="', ','), '"/>', ''), 1, 1, '')
)N

-------3. ʹ�úϲ�����-----
create function f_hb(@id int)
returns varchar(8000)
as
begin
  declare @str varchar(8000)
  set @str = ''
  select @str = @str + ',' + cast(value as varchar) from tb2 where id = @id
  set @str = right(@str , len(@str) - 1)
  return(@str)
End
go

select distinct id ,dbo.f_hb(id) as value from tb2