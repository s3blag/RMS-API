USE [master]
GO
/****** Object:  Database [RMS-app]    Script Date: 18.05.2018 20:38:53 ******/
CREATE DATABASE [RMS-app]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'RMS-app', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\RMS-app.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'RMS-app_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\RMS-app.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [RMS-app] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [RMS-app].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [RMS-app] SET ANSI_NULL_DEFAULT ON 
GO
ALTER DATABASE [RMS-app] SET ANSI_NULLS ON 
GO
ALTER DATABASE [RMS-app] SET ANSI_PADDING ON 
GO
ALTER DATABASE [RMS-app] SET ANSI_WARNINGS ON 
GO
ALTER DATABASE [RMS-app] SET ARITHABORT ON 
GO
ALTER DATABASE [RMS-app] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [RMS-app] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [RMS-app] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [RMS-app] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [RMS-app] SET CURSOR_DEFAULT  LOCAL 
GO
ALTER DATABASE [RMS-app] SET CONCAT_NULL_YIELDS_NULL ON 
GO
ALTER DATABASE [RMS-app] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [RMS-app] SET QUOTED_IDENTIFIER ON 
GO
ALTER DATABASE [RMS-app] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [RMS-app] SET  DISABLE_BROKER 
GO
ALTER DATABASE [RMS-app] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [RMS-app] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [RMS-app] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [RMS-app] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [RMS-app] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [RMS-app] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [RMS-app] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [RMS-app] SET RECOVERY FULL 
GO
ALTER DATABASE [RMS-app] SET  MULTI_USER 
GO
ALTER DATABASE [RMS-app] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [RMS-app] SET DB_CHAINING OFF 
GO
ALTER DATABASE [RMS-app] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [RMS-app] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [RMS-app] SET DELAYED_DURABILITY = DISABLED 
GO
USE [RMS-app]
GO
/****** Object:  UserDefinedFunction [dbo].[SHOW_COURSES_WITH_AB]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SHOW_COURSES_WITH_AB](@station_a VARCHAR(50), @station_b VARCHAR(50))
RETURNS @courses TABLE
(
course_id int primary key NOT NULL
)
AS
BEGIN
-- Pobranie kurs�w kt�re zawieraj� stacj� a
declare @courses_a as TABLE(course_id int, visit_order int)

INSERT INTO @courses_a (course_id, visit_order) (
SELECT course_id, visit_order
FROM visits
INNER JOIN stations ON visits.station_id = stations.id
WHERE stations.name = @station_a)

-- Pobieranie kurs�w kt�re zawieraj� stacj� a i stacj� b
declare @courses_b as TABLE(course_id int, visit_order int)

INSERT INTO @courses_b (course_id, visit_order) (
SELECT course_id, visit_order
FROM visits
INNER JOIN stations ON visits.station_id = stations.id
WHERE course_id = ANY(SELECT course_id FROM @courses_a) AND stations.name = @station_b)

--Sprawdzenie czy kolejno�� jest odpowiednia
INSERT INTO @courses (course_id) (
SELECT [@courses_b].course_id
FROM @courses_b
INNER JOIN @courses_a ON [@courses_b].course_id = [@courses_a].course_id
WHERE [@courses_b].visit_order > [@courses_a].visit_order
)

return
END

GO
/****** Object:  Table [dbo].[courses]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[courses](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[train_id] [int] NOT NULL,
 CONSTRAINT [PK_courses] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[customers]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[customers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[surname] [varchar](50) NOT NULL,
	[address] [varchar](70) NOT NULL,
	[city] [varchar](50) NOT NULL,
	[zip_code] [varchar](6) NOT NULL,
	[phone_number] [varchar](11) NOT NULL,
	[email] [varchar](50) NOT NULL,
 CONSTRAINT [PK_customers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[logins]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[logins](
	[login] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_logins] PRIMARY KEY CLUSTERED 
(
	[login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[reservations]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reservations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[price] [smallmoney] NOT NULL,
	[reservation_date] [datetime] NOT NULL,
 CONSTRAINT [PK_reservations] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[seats]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seats](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[seat_number] [int] NOT NULL,
	[course_id] [int] NOT NULL,
	[visit_id] [int] NULL,
	[reservation_id] [int] NULL,
 CONSTRAINT [PK_seats] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[stations]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_stations] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[trains]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[trains](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[MODEL] [varchar](50) NOT NULL,
 CONSTRAINT [PK_trains] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[visits]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[visits](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[station_id] [int] NOT NULL,
	[course_id] [int] NOT NULL,
	[visit_order] [int] NOT NULL,
	[available_seats] [int] NOT NULL DEFAULT ((50)),
	[visit_date] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_visits] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[SHOW_COURSES]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SHOW_COURSES]
AS
SELECT  courses.id, trains.name AS train, (
SELECT	TOP 1 stations.name 
FROM visits
INNER JOIN stations ON 
visits.station_id = stations.id
WHERE visits.course_id = courses.id
ORDER BY visits.visit_order ASC) AS first_station, (
SELECT	TOP 1 stations.name 
FROM visits
INNER JOIN stations ON 
visits.station_id = stations.id
WHERE visits.course_id = courses.id
ORDER BY visits.visit_order DESC) AS last_station
FROM dbo.courses
INNER JOIN trains
ON courses.train_id = trains.id;

GO
/****** Object:  View [dbo].[SHOW_CUSTOMERS]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SHOW_CUSTOMERS]
AS
SELECT        id, name, surname, address, city, zip_code, phone_number, email
FROM            dbo.customers

GO
/****** Object:  View [dbo].[SHOW_TRAINS]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SHOW_TRAINS] as
    SELECT
       id AS 'train_id',
	   name AS 'train_name',
	   model AS 'train_model'
	FROM
    trains

GO
SET IDENTITY_INSERT [dbo].[courses] ON 

INSERT [dbo].[courses] ([id], [train_id]) VALUES (7, 3)
INSERT [dbo].[courses] ([id], [train_id]) VALUES (9, 4)
INSERT [dbo].[courses] ([id], [train_id]) VALUES (10, 5)
INSERT [dbo].[courses] ([id], [train_id]) VALUES (11, 5)
INSERT [dbo].[courses] ([id], [train_id]) VALUES (12, 4)
SET IDENTITY_INSERT [dbo].[courses] OFF
SET IDENTITY_INSERT [dbo].[customers] ON 

INSERT [dbo].[customers] ([id], [name], [surname], [address], [city], [zip_code], [phone_number], [email]) VALUES (2, N'Lukasz', N'Zatorski', N'Zachodnia 61', N'Piotrk?w', N'97-300', N'48500716575', N'lukasz1111@gmail.com')
INSERT [dbo].[customers] ([id], [name], [surname], [address], [city], [zip_code], [phone_number], [email]) VALUES (3, N'Sebastian', N'Lagiewski', N'Gl?wna 10', N'Przygl?w', N'97-310', N'48123456789', N'seba@gmail.com')
SET IDENTITY_INSERT [dbo].[customers] OFF
INSERT [dbo].[logins] ([login], [password]) VALUES (N'Admin', N'pIbvhgmpVHahDBTYUgQvew==')
INSERT [dbo].[logins] ([login], [password]) VALUES (N'Cashier', N'a77rnoLt4SfyMwKB5+h57w==')
SET IDENTITY_INSERT [dbo].[reservations] ON 

INSERT [dbo].[reservations] ([id], [customer_id], [price], [reservation_date]) VALUES (11, 3, 30.0000, CAST(N'2018-01-25 00:00:00.000' AS DateTime))
INSERT [dbo].[reservations] ([id], [customer_id], [price], [reservation_date]) VALUES (22, 2, 30.0000, CAST(N'2018-01-25 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[reservations] OFF
SET IDENTITY_INSERT [dbo].[seats] ON 

INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (601, 1, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (602, 2, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (603, 3, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (604, 4, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (605, 5, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (606, 6, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (607, 7, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (608, 8, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (609, 9, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (610, 10, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (611, 11, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (612, 12, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (613, 13, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (614, 14, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (615, 15, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (616, 16, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (617, 17, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (618, 18, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (619, 19, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (620, 20, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (621, 21, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (622, 22, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (623, 23, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (624, 24, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (625, 25, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (626, 26, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (627, 27, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (628, 28, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (629, 29, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (630, 30, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (631, 31, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (632, 32, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (633, 33, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (634, 34, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (635, 35, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (636, 36, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (637, 37, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (638, 38, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (639, 39, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (640, 40, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (641, 41, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (642, 42, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (643, 43, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (644, 44, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (645, 45, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (646, 46, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (647, 47, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (648, 48, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (649, 49, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (650, 50, 7, 31, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (651, 1, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (652, 2, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (653, 3, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (654, 4, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (655, 5, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (656, 6, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (657, 7, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (658, 8, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (659, 9, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (660, 10, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (661, 11, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (662, 12, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (663, 13, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (664, 14, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (665, 15, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (666, 16, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (667, 17, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (668, 18, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (669, 19, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (670, 20, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (671, 21, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (672, 22, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (673, 23, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (674, 24, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (675, 25, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (676, 26, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (677, 27, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (678, 28, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (679, 29, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (680, 30, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (681, 31, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (682, 32, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (683, 33, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (684, 34, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (685, 35, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (686, 36, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (687, 37, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (688, 38, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (689, 39, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (690, 40, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (691, 41, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (692, 42, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (693, 43, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (694, 44, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (695, 45, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (696, 46, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (697, 47, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (698, 48, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (699, 49, 7, 32, NULL)
GO
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (700, 50, 7, 32, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (701, 1, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (702, 2, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (703, 3, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (704, 4, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (705, 5, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (706, 6, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (707, 7, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (708, 8, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (709, 9, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (710, 10, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (711, 11, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (712, 12, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (713, 13, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (714, 14, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (715, 15, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (716, 16, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (717, 17, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (718, 18, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (719, 19, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (720, 20, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (721, 21, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (722, 22, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (723, 23, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (724, 24, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (725, 25, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (726, 26, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (727, 27, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (728, 28, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (729, 29, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (730, 30, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (731, 31, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (732, 32, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (733, 33, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (734, 34, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (735, 35, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (736, 36, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (737, 37, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (738, 38, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (739, 39, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (740, 40, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (741, 41, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (742, 42, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (743, 43, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (744, 44, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (745, 45, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (746, 46, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (747, 47, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (748, 48, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (749, 49, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (750, 50, 7, 33, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (901, 1, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (902, 2, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (903, 3, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (904, 4, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (905, 5, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (906, 6, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (907, 7, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (908, 8, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (909, 9, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (910, 10, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (911, 11, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (912, 12, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (913, 13, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (914, 14, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (915, 15, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (916, 16, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (917, 17, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (918, 18, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (919, 19, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (920, 20, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (921, 21, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (922, 22, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (923, 23, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (924, 24, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (925, 25, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (926, 26, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (927, 27, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (928, 28, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (929, 29, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (930, 30, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (931, 31, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (932, 32, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (933, 33, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (934, 34, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (935, 35, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (936, 36, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (937, 37, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (938, 38, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (939, 39, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (940, 40, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (941, 41, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (942, 42, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (943, 43, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (944, 44, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (945, 45, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (946, 46, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (947, 47, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (948, 48, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (949, 49, 9, 37, NULL)
GO
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (950, 50, 9, 37, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (951, 1, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (952, 2, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (953, 3, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (954, 4, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (955, 5, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (956, 6, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (957, 7, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (958, 8, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (959, 9, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (960, 10, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (961, 11, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (962, 12, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (963, 13, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (964, 14, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (965, 15, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (966, 16, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (967, 17, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (968, 18, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (969, 19, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (970, 20, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (971, 21, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (972, 22, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (973, 23, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (974, 24, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (975, 25, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (976, 26, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (977, 27, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (978, 28, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (979, 29, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (980, 30, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (981, 31, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (982, 32, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (983, 33, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (984, 34, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (985, 35, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (986, 36, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (987, 37, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (988, 38, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (989, 39, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (990, 40, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (991, 41, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (992, 42, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (993, 43, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (994, 44, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (995, 45, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (996, 46, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (997, 47, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (998, 48, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (999, 49, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1000, 50, 9, 38, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1001, 1, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1002, 2, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1003, 3, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1004, 4, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1005, 5, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1006, 6, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1007, 7, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1008, 8, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1009, 9, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1010, 10, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1011, 11, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1012, 12, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1013, 13, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1014, 14, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1015, 15, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1016, 16, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1017, 17, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1018, 18, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1019, 19, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1020, 20, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1021, 21, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1022, 22, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1023, 23, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1024, 24, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1025, 25, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1026, 26, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1027, 27, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1028, 28, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1029, 29, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1030, 30, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1031, 31, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1032, 32, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1033, 33, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1034, 34, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1035, 35, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1036, 36, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1037, 37, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1038, 38, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1039, 39, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1040, 40, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1041, 41, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1042, 42, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1043, 43, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1044, 44, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1045, 45, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1046, 46, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1047, 47, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1048, 48, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1049, 49, 9, 39, NULL)
GO
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1050, 50, 9, 39, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1051, 1, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1052, 2, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1053, 3, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1054, 4, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1055, 5, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1056, 6, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1057, 7, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1058, 8, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1059, 9, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1060, 10, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1061, 11, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1062, 12, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1063, 13, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1064, 14, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1065, 15, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1066, 16, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1067, 17, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1068, 18, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1069, 19, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1070, 20, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1071, 21, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1072, 22, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1073, 23, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1074, 24, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1075, 25, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1076, 26, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1077, 27, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1078, 28, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1079, 29, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1080, 30, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1081, 31, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1082, 32, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1083, 33, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1084, 34, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1085, 35, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1086, 36, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1087, 37, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1088, 38, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1089, 39, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1090, 40, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1091, 41, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1092, 42, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1093, 43, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1094, 44, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1095, 45, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1096, 46, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1097, 47, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1098, 48, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1099, 49, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1100, 50, 9, 40, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1101, 1, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1102, 2, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1103, 3, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1104, 4, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1105, 5, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1106, 6, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1107, 7, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1108, 8, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1109, 9, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1110, 10, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1111, 11, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1112, 12, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1113, 13, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1114, 14, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1115, 15, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1116, 16, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1117, 17, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1118, 18, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1119, 19, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1120, 20, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1121, 21, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1122, 22, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1123, 23, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1124, 24, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1125, 25, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1126, 26, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1127, 27, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1128, 28, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1129, 29, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1130, 30, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1131, 31, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1132, 32, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1133, 33, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1134, 34, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1135, 35, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1136, 36, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1137, 37, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1138, 38, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1139, 39, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1140, 40, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1141, 41, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1142, 42, 10, 41, 22)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1143, 43, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1144, 44, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1145, 45, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1146, 46, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1147, 47, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1148, 48, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1149, 49, 10, 41, NULL)
GO
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1150, 50, 10, 41, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1151, 1, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1152, 2, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1153, 3, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1154, 4, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1155, 5, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1156, 6, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1157, 7, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1158, 8, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1159, 9, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1160, 10, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1161, 11, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1162, 12, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1163, 13, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1164, 14, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1165, 15, 10, 42, 11)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1166, 16, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1167, 17, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1168, 18, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1169, 19, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1170, 20, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1171, 21, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1172, 22, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1173, 23, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1174, 24, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1175, 25, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1176, 26, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1177, 27, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1178, 28, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1179, 29, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1180, 30, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1181, 31, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1182, 32, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1183, 33, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1184, 34, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1185, 35, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1186, 36, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1187, 37, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1188, 38, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1189, 39, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1190, 40, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1191, 41, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1192, 42, 10, 42, 22)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1193, 43, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1194, 44, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1195, 45, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1196, 46, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1197, 47, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1198, 48, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1199, 49, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1200, 50, 10, 42, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1201, 1, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1202, 2, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1203, 3, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1204, 4, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1205, 5, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1206, 6, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1207, 7, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1208, 8, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1209, 9, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1210, 10, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1211, 11, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1212, 12, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1213, 13, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1214, 14, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1215, 15, 10, 43, 11)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1216, 16, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1217, 17, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1218, 18, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1219, 19, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1220, 20, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1221, 21, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1222, 22, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1223, 23, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1224, 24, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1225, 25, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1226, 26, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1227, 27, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1228, 28, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1229, 29, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1230, 30, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1231, 31, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1232, 32, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1233, 33, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1234, 34, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1235, 35, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1236, 36, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1237, 37, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1238, 38, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1239, 39, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1240, 40, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1241, 41, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1242, 42, 10, 43, 22)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1243, 43, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1244, 44, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1245, 45, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1246, 46, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1247, 47, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1248, 48, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1249, 49, 10, 43, NULL)
GO
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1250, 50, 10, 43, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1251, 1, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1252, 2, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1253, 3, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1254, 4, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1255, 5, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1256, 6, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1257, 7, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1258, 8, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1259, 9, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1260, 10, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1261, 11, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1262, 12, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1263, 13, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1264, 14, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1265, 15, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1266, 16, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1267, 17, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1268, 18, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1269, 19, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1270, 20, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1271, 21, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1272, 22, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1273, 23, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1274, 24, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1275, 25, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1276, 26, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1277, 27, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1278, 28, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1279, 29, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1280, 30, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1281, 31, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1282, 32, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1283, 33, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1284, 34, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1285, 35, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1286, 36, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1287, 37, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1288, 38, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1289, 39, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1290, 40, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1291, 41, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1292, 42, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1293, 43, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1294, 44, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1295, 45, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1296, 46, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1297, 47, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1298, 48, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1299, 49, 10, 44, NULL)
INSERT [dbo].[seats] ([id], [seat_number], [course_id], [visit_id], [reservation_id]) VALUES (1300, 50, 10, 44, NULL)
SET IDENTITY_INSERT [dbo].[seats] OFF
SET IDENTITY_INSERT [dbo].[stations] ON 

INSERT [dbo].[stations] ([id], [name]) VALUES (15, N'Kalisz')
INSERT [dbo].[stations] ([id], [name]) VALUES (10, N'Katowice')
INSERT [dbo].[stations] ([id], [name]) VALUES (13, N'Krak?w')
INSERT [dbo].[stations] ([id], [name]) VALUES (16, N'L?dz')
INSERT [dbo].[stations] ([id], [name]) VALUES (12, N'Opole')
INSERT [dbo].[stations] ([id], [name]) VALUES (11, N'Piotrk?w Trybunalski')
INSERT [dbo].[stations] ([id], [name]) VALUES (14, N'Przemysl')
INSERT [dbo].[stations] ([id], [name]) VALUES (17, N'Warszawa')
INSERT [dbo].[stations] ([id], [name]) VALUES (9, N'Wroclaw')
SET IDENTITY_INSERT [dbo].[stations] OFF
SET IDENTITY_INSERT [dbo].[trains] ON 

INSERT [dbo].[trains] ([id], [name], [MODEL]) VALUES (3, N'Pendolino', N'XYZ300')
INSERT [dbo].[trains] ([id], [name], [MODEL]) VALUES (4, N'Dart', N'ABC200')
INSERT [dbo].[trains] ([id], [name], [MODEL]) VALUES (5, N'Flirt3', N'2000')
INSERT [dbo].[trains] ([id], [name], [MODEL]) VALUES (6, N'Nysa', N'PKJ-250')
INSERT [dbo].[trains] ([id], [name], [MODEL]) VALUES (7, N'Odra', N'BGH-2210')
SET IDENTITY_INSERT [dbo].[trains] OFF
SET IDENTITY_INSERT [dbo].[visits] ON 

INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (31, 9, 7, 1, 50, CAST(N'2018-01-24 14:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (32, 10, 7, 2, 50, CAST(N'2018-01-24 16:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (33, 11, 7, 3, 50, CAST(N'2018-01-24 18:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (37, 9, 9, 1, 50, CAST(N'2018-01-24 06:30:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (38, 12, 9, 2, 50, CAST(N'2018-01-24 07:30:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (39, 13, 9, 3, 50, CAST(N'2018-01-24 10:50:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (40, 14, 9, 4, 50, CAST(N'2018-01-24 14:20:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (41, 9, 10, 1, 50, CAST(N'2018-01-25 02:20:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (42, 15, 10, 2, 50, CAST(N'2018-01-25 04:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (43, 16, 10, 3, 50, CAST(N'2018-01-25 06:50:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (44, 17, 10, 4, 50, CAST(N'2018-01-25 09:30:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (47, 17, 7, 4, 50, CAST(N'2018-05-18 21:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (1045, 10, 11, 1, 50, CAST(N'2018-05-18 21:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (1046, 11, 11, 1, 50, CAST(N'2018-05-18 21:00:00' AS SmallDateTime))
INSERT [dbo].[visits] ([id], [station_id], [course_id], [visit_order], [available_seats], [visit_date]) VALUES (1047, 13, 11, 2, 50, CAST(N'2018-05-18 21:00:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[visits] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__stations__72E12F1B3376A0FA]    Script Date: 18.05.2018 20:38:53 ******/
ALTER TABLE [dbo].[stations] ADD UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__trains__72E12F1B39C68F58]    Script Date: 18.05.2018 20:38:53 ******/
ALTER TABLE [dbo].[trains] ADD UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[courses]  WITH CHECK ADD  CONSTRAINT [FK_courses_trains] FOREIGN KEY([train_id])
REFERENCES [dbo].[trains] ([id])
GO
ALTER TABLE [dbo].[courses] CHECK CONSTRAINT [FK_courses_trains]
GO
ALTER TABLE [dbo].[reservations]  WITH CHECK ADD  CONSTRAINT [FK_reservations_customers] FOREIGN KEY([customer_id])
REFERENCES [dbo].[customers] ([id])
GO
ALTER TABLE [dbo].[reservations] CHECK CONSTRAINT [FK_reservations_customers]
GO
ALTER TABLE [dbo].[seats]  WITH CHECK ADD  CONSTRAINT [FK_seats_courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[seats] CHECK CONSTRAINT [FK_seats_courses]
GO
ALTER TABLE [dbo].[seats]  WITH CHECK ADD  CONSTRAINT [FK_seats_reservations] FOREIGN KEY([reservation_id])
REFERENCES [dbo].[reservations] ([id])
GO
ALTER TABLE [dbo].[seats] CHECK CONSTRAINT [FK_seats_reservations]
GO
ALTER TABLE [dbo].[seats]  WITH CHECK ADD  CONSTRAINT [FK_seats_visits] FOREIGN KEY([visit_id])
REFERENCES [dbo].[visits] ([id])
GO
ALTER TABLE [dbo].[seats] CHECK CONSTRAINT [FK_seats_visits]
GO
ALTER TABLE [dbo].[visits]  WITH CHECK ADD  CONSTRAINT [FK_visits_courses] FOREIGN KEY([course_id])
REFERENCES [dbo].[courses] ([id])
GO
ALTER TABLE [dbo].[visits] CHECK CONSTRAINT [FK_visits_courses]
GO
ALTER TABLE [dbo].[visits]  WITH CHECK ADD  CONSTRAINT [FK_visits_stations] FOREIGN KEY([station_id])
REFERENCES [dbo].[stations] ([id])
GO
ALTER TABLE [dbo].[visits] CHECK CONSTRAINT [FK_visits_stations]
GO
/****** Object:  StoredProcedure [dbo].[ADD_COURSE]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_COURSE]
@train_id INT
AS

BEGIN
INSERT INTO courses(train_id)
VALUES (@train_id)

SELECT SCOPE_IDENTITY()

END

GO
/****** Object:  StoredProcedure [dbo].[ADD_RESERVATION]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_RESERVATION]
@customer_id INT,
@price SMALLMONEY,
@course_id INT,
@station_a VARCHAR(70),
@station_b VARCHAR(70),
@seat_number INT OUTPUT,
@reservation_id INT OUTPUT
AS

BEGIN
DECLARE @local_seat_number INT;

EXEC	[dbo].[GET_AVAILABLE_SEAT]
		@_course_id = @course_id,
		@first_station = @station_a,
		@last_station = @station_b,
		@out_seat_number = @local_seat_number OUTPUT;

DECLARE @first_visit_id INT = (
SELECT visits.id 
FROM visits INNER JOIN stations
ON visits.station_id = stations.id
WHERE stations.name = @station_a AND visits.course_id = @course_id)

DECLARE @last_visit_id INT = (
SELECT visits.id 
FROM visits INNER JOIN stations
ON visits.station_id = stations.id
WHERE stations.name = @station_b AND visits.course_id = @course_id)

DECLARE @visit_counter INT = @last_visit_id - @first_visit_id;

DECLARE @temp_date DATETIME = (
SELECT visits.visit_date
FROM visits
WHERE visits.id = @first_visit_id)

INSERT INTO reservations(customer_id, price, reservation_date)
VALUES (@customer_id, @price, @temp_date)

DECLARE @cnt INT = (
SELECT visits.visit_order 
FROM visits
WHERE visits.id = @first_visit_id) 
SET @visit_counter = @visit_counter + @cnt;

WHILE @cnt < @visit_counter
BEGIN
   UPDATE seats
	SET reservation_id = IDENT_CURRENT('reservations')
	FROM seats
	INNER JOIN visits
	ON seats.visit_id = visits.id
	WHERE visits.visit_order = @cnt AND visits.course_id = @course_id AND seats.seat_number = @local_seat_number;
	SET @cnt = @cnt + 1;
END;

SELECT @reservation_id=SCOPE_IDENTITY(), @seat_number=@local_seat_number;
END
GO
/****** Object:  StoredProcedure [dbo].[ADD_SEATS]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_SEATS]
@course_id INT,
@visit_id INT,
@number_of_seats INT
AS

BEGIN
DECLARE @cnt INT = 1;

WHILE @cnt < @number_of_seats + 1
BEGIN
   INSERT INTO seats(seat_number, course_id, visit_id, reservation_id)
	VALUES (@cnt, @course_id, @visit_id, NULL);
	SET @cnt = @cnt + 1;
END;

END

GO
/****** Object:  StoredProcedure [dbo].[ADD_STATION]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_STATION]
@name varchar(50)
AS

BEGIN
INSERT INTO stations(name)
VALUES (@name)
END

GO
/****** Object:  StoredProcedure [dbo].[ADD_TRAIN]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_TRAIN]
@name varchar(50),
@model varchar(70)

AS

BEGIN
INSERT INTO trains(name,model)
VALUES (@name,@model)

SELECT SCOPE_IDENTITY()

END

GO
/****** Object:  StoredProcedure [dbo].[ADD_VISIT]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ADD_VISIT]
@station_id INT,
@course_id INT,
@visit_order INT,
@available_seats INT,
@date smalldatetime
AS

BEGIN
INSERT INTO visits(station_id, course_id, visit_order, available_seats, visit_date)
VALUES (@station_id ,
@course_id,
@visit_order,
@available_seats,
@date)

SELECT SCOPE_IDENTITY()

END

GO
/****** Object:  StoredProcedure [dbo].[CREATE_NEW_CUSTOMER]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[CREATE_NEW_CUSTOMER]
@name varchar(50)
,@surname varchar(50)
,@address varchar(70)
,@city varchar(50)
,@zip_code varchar(6)
,@phone_number varchar(11)
,@email varchar(50)

AS

BEGIN
INSERT INTO customers(name,surname,address,city,zip_code, phone_number, email)
VALUES (@name,@surname,@address,@city,@zip_code, @phone_number, @email)
END

GO
/****** Object:  StoredProcedure [dbo].[DELETE_COURSE]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DELETE_COURSE]
@course_id INT
AS

BEGIN
DELETE FROM reservations
WHERE reservations.id = ANY(
SELECT seats.reservation_id FROM seats
INNER JOIN courses ON seats.course_id = courses.id
WHERE seats.course_id = @course_id);

DELETE FROM seats
WHERE seats.course_id = @course_id

DELETE FROM visits
WHERE visits.course_id = @course_id;

DELETE FROM courses
WHERE courses.id = @course_id;

END

GO
/****** Object:  StoredProcedure [dbo].[GET_AVAILABLE_SEAT]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_AVAILABLE_SEAT]
@_course_id INT,
@first_station VARCHAR(70),
@last_station VARCHAR(70),
@out_seat_number INT OUTPUT
AS

BEGIN

DECLARE @_first_station INT = (
SELECT visits.visit_order 
FROM visits INNER JOIN stations
ON visits.station_id = stations.id
WHERE stations.name = @first_station AND visits.course_id = @_course_id);

DECLARE @_last_station INT = (
SELECT visits.visit_order 
FROM visits INNER JOIN stations
ON visits.station_id = stations.id
WHERE stations.name = @last_station AND visits.course_id = @_course_id);

SELECT TOP 1 @out_seat_number = seats.seat_number
FROM (
SELECT seats.seat_number, COUNT(seats.seat_number) AS seat_count
FROM seats INNER JOIN visits
ON seats.visit_id = visits.id
WHERE visits.visit_order > (@_first_station - 1) AND visits.visit_order < (@_last_station + 1) AND seats.course_id = @_course_id AND seats.reservation_id is NULL
GROUP BY seats.seat_number) AS seats
WHERE seats.seat_count = @_last_station - @_first_station + 1;

SELECT @out_seat_number AS 'seat_number';
END
GO
/****** Object:  StoredProcedure [dbo].[MODIFY_CUSTOMER]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MODIFY_CUSTOMER]
(
@id int,
@name varchar(50),
@surname varchar(50),
@address varchar(70),
@city varchar(50),
@zip_code varchar(6),
@phone_number varchar(11),
@email varchar(50)
)
AS

	IF (@name IS NOT NULL)
		UPDATE customers
		SET name = @name
		WHERE id=@id
	
	IF (@surname IS NOT NULL)
		UPDATE customers
		SET surname = @surname
		WHERE id=@id

	IF (@address IS NOT NULL)
		UPDATE customers
		SET address = @address
		WHERE id=@id

	IF (@city IS NOT NULL)
		UPDATE customers
		SET city = @city
		WHERE id=@id


	IF (@zip_code IS NOT NULL)
		UPDATE customers
		SET zip_code = @zip_code
		WHERE id=@id


	IF (@phone_number IS NOT NULL)
		UPDATE customers
		SET phone_number = @phone_number
		WHERE id=@id

	IF (@email IS NOT NULL)
		UPDATE customers
		SET email = @email
		WHERE id=@id

GO
/****** Object:  StoredProcedure [dbo].[SHOW_AVAILABLE_COURSES]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SHOW_AVAILABLE_COURSES]
@station_a VARCHAR(30),
@station_b VARCHAR(30)
AS

BEGIN

(SELECT coursesAB.course_id, coursesABN.train, coursesABN.first_station, coursesABN.last_station, (

SELECT visits.visit_date
FROM visits INNER JOIN stations
ON visits.station_id = stations.id
WHERE visits.course_id = coursesAB.course_id AND stations.name = @station_a) AS departure_date, (

SELECT visits.visit_date
FROM visits INNER JOIN stations
ON visits.station_id = stations.id
WHERE visits.course_id = coursesAB.course_id AND stations.name = @station_b) AS arrival_date

FROM SHOW_COURSES_WITH_AB(@station_a, @station_b) AS coursesAB
INNER JOIN SHOW_COURSES AS coursesABN ON coursesAB.course_id = coursesABN.id
)
END

GO
/****** Object:  StoredProcedure [dbo].[SHOW_COURSE_VISITS]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*INSERT INTO reservations(customer_id, price, date)
VALUES(1, 25.00, GETDATE());*/

CREATE PROCEDURE [dbo].[SHOW_COURSE_VISITS]
(
  @course_id int
)
AS
SELECT visits.id, visits.course_id AS 'course_id',visits.station_id AS 'station_id',stations.name AS 'station_name', visits.visit_order AS 'order' , visits.visit_date AS 'arrival_date' 
FROM visits
INNER JOIN stations ON visits.station_id=stations.id
WHERE course_id = @course_id;

GO
/****** Object:  StoredProcedure [dbo].[SHOW_CUSTOMER]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SHOW_CUSTOMER]
@name varchar(50),
@surname varchar(50)

AS

BEGIN
SELECT *
FROM customers
WHERE name=@name AND surname=@surname
END

GO
/****** Object:  StoredProcedure [dbo].[SHOW_CUSTOMER_RESERVATION]    Script Date: 18.05.2018 20:38:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SHOW_CUSTOMER_RESERVATION]
@customer_id INT
AS
BEGIN
SELECT seats.reservation_id AS reservation_id, seats.seat_number AS seat_number, seats.course_id AS course_id, (

SELECT TOP(1) stations.name
FROM stations 
INNER JOIN visits ON stations.id = visits.station_id
INNER JOIN seats ON visits.id = seats.visit_id
INNER JOIN reservations ON seats.reservation_id = reservations.id
WHERE seats.reservation_id = seats.reservation_id
ORDER BY visits.visit_order ASC) AS start_station, (

SELECT stations.name FROM stations
INNER JOIN visits ON stations.id = visits.station_id
WHERE visits.course_id = seats.course_id AND visits.visit_order =

(SELECT TOP(1) visits.visit_order
FROM visits
INNER JOIN seats ON visits.id = seats.visit_id
INNER JOIN reservations ON seats.reservation_id = reservations.id
WHERE seats.reservation_id = seats.reservation_id
ORDER BY visits.visit_order DESC) + 1) AS end_station

FROM seats AS seats
INNER JOIN reservations ON seats.reservation_id = reservations.id
WHERE reservations.customer_id = @customer_id
GROUP BY seats.reservation_id, seats.course_id, seat_number;
END

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "customers"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SHOW_CUSTOMERS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'SHOW_CUSTOMERS'
GO
USE [master]
GO
ALTER DATABASE [RMS-app] SET  READ_WRITE 
GO
