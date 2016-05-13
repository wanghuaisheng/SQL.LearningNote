--1��˵�������Ʊ�(ֻ���ƽṹ,Դ������a �±�����b)

CREATE TABLE [dbo].[Copy1]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [s_Name] NVARCHAR(50) NULL, 
    [s_Age] INT NULL
)
CREATE TABLE [dbo].[Copy2]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [s_Name] NVARCHAR(50) NULL, 
    [s_Age] INT NULL
)
go
insert Copy1 values(1,'aa',18)
insert Copy1 values(2,'bb',19)
insert Copy1 values(3,'cc',20)
go
select * from Copy1
select * from Copy2

--1.1 �õ���ṹ
select * from Copy1 where 1<>1
select top 0 * from Copy1
--1.2 ʹ��into�ؼ���
select * into Copy3 from Copy1 where 1<>1
select top 0 * into Copy4 from Copy1
--1.3 ��������
/*
SQL SELECT INTO �������ڴ�����ı��ݸ�����
SELECT INTO ����һ������ѡȡ���ݣ�Ȼ������ݲ�����һ�����С�
SELECT INTO ��䳣���ڴ�����ı��ݸ����������ڶԼ�¼���д浵��
*/

--2��˵����������(��������,Դ������a Ŀ�������b)
select * into Copy5 from Copy1

--3��˵����between���÷�,between���Ʋ�ѯ���ݷ�Χʱ�����˱߽�ֵ,not between������
select * from Copy1 where s_Age between 18 and 19

--4��˵�������ȡ��2������
select top 2 *,NEWID() from Copy1 order by NEWID()

--5��˵�������ѡ���¼
select NEWID()
--5.1 ��������
/*
��Ϊnewid()���ص���uniqueidentifier���͵�Ψһֵ��newid()ÿ�β�����ֵ����һ������ô����������ֵ��������ÿ�εĽ��Ҳ�ǲ�һ���ġ�
NEWID ��ÿ̨��������ص�ֵ������ͬ��
uniqueidentifier���ĺ��塰Ψһ�ı�ʶ������
uniqueidentifier����������16���ֽڵĶ�����ֵ��Ӧ����Ψһ�ԣ�������NEWID�����������ʹ�á�
uniqueidentifier����������identity������ͬ������Ϊ����������Զ������µ�ID����ֵ��NEWID��������ָ����
NEWID��������ֵ������ȫ��Ψһ�ı�ʶ����ʶ�������ź�CPUʱ����ɣ��磺6F9619FF-8B86-D011-B42D-00C04FC964FF��

uniqueidentifier �������;�������ȱ�㣺 
1.ֵ�����Ѷ�����ʹ�û�������ȷ�������ǣ����Ҹ��Ѽ�ס�� 
2.��Щֵ������ģ��������ǲ�֧���κ�ʹ����û����������ģʽ�� 
3.Ҳû���κη�ʽ���Ծ������� uniqueidentifier ֵ��˳�����ǲ���������Щ���������ļ�ֵ������Ӧ�ó��� 
4.��uniqueidentifier Ϊ 16 �ֽ�ʱ�����������ͱ������������ͣ����� 4 �ֽڵ�������������ζ��ʹ�� uniqueidentifier �������������ٶ��������ʹ�� int �������������ٶȡ� 
5.ֻ��û���������õ��������͵ķ�Χ�ǳ�խ�ķ���ʹ�� GUID�� 
*/


--6��˵����ɾ���ظ���¼
CREATE TABLE [dbo].[Repeat]
( 
    [r_Id] INT NOT NULL PRIMARY KEY, 
    [r_Name] NVARCHAR(50) NULL, 
    [r_Age] INT NULL
)
go
insert [Repeat] values(1,N'��������',22)
insert [Repeat] values(2,N'��������',22)
insert [Repeat] values(3,N'��������',22)
insert [Repeat] values(4,N'��������',21)
insert [Repeat] values(5,N'��������',23)
go
select * from [Repeat]

--6.1 ��ѯΨһ���ظ�����
select MAX(r_Id),r_Name from [Repeat]
group by r_Name,r_Age
--6.2 ɾ��
delete from [Repeat] where r_Id not in
(select MAX(r_Id) from [Repeat]
group by r_Name,r_Age)

--7��˵�����г����ݿ������еı���
select name from sysobjects where type='U'

--8��˵�����г���������е���
select name from syscolumns where id=object_id('Copy1')

--9����ѯ���ݵ�����������⣨ֻ����һ�����д��
CREATE TABLE hard 
(
qu char (11) ,
co char (11) ,
je numeric(3, 0)
)
go
insert into hard values ('A','1',3)
insert into hard values ('A','2',4)
insert into hard values ('A','4',2)
insert into hard values ('A','6',9)
insert into hard values ('B','1',4)
insert into hard values ('B','2',5)
insert into hard values ('B','3',6)
insert into hard values ('C','3',4)
insert into hard values ('C','6',7)
insert into hard values ('C','2',3)
go

--9.1.1 ��ִ������ѯ
select * from hard a
ORDER BY qu,je DESC 
--9.1.2 ������ѯ������������Ӳ�ѯ
select count(*) from hard b 
where b.qu='A' and b.je>=6
--9.1.3 �ۺ�
select * from hard a where (select count(*) from hard b 
where a.qu=b.qu and b.je>=a.je)<=2 
ORDER BY qu,je DESC 
--9.1.4 �ο�����
/*
����Ӳ�ѯʵ���ϻ�ִ��N�Σ�Nȡ�����ⲿ��ѯ�����������ⲿ��ѯÿִ��һ�У����Ὣ��Ӧ�����õĲ��������Ӳ�ѯ��.
���Ӳ�ѯ��Ϊ������ʹ��ʱ��������ⲿ��ѯ��ÿһ�У�����Ψһ��ֵ��

��1��������ѯ��ȡ��һ��Ԫ�飬��Ԫ������е�ֵ�����ڲ��ѯ��
��2��ִ���ڲ��ѯ���õ��Ӳ�ѯ������ֵ��
��3�����ѯ�����Ӳ�ѯ���صĽ���������õ������������С�
��4��Ȼ������ѯȡ����һ��Ԫ���ظ�������1-3��ֱ������Ԫ��ȫ��������ϡ� 
*/ 
--9.2 ����ʵ��
select qu,co,je 
 from (select ROW_NUMBER()over(PARTITION by qu  order by je desc)as row,*
           from hard)as t
 where row<=2;

