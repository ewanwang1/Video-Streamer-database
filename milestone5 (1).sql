-- drop table videos;
-- drop table video_specifics;
-- drop table adds;
-- drop table has;
-- drop table producedby;
-- drop table non_cartoon;
-- drop table cartoon;
-- drop table subscription_invoice;
-- drop table recommendation;
-- drop table watch_history;
-- drop table customers;
-- drop table customer_address;
-- drop table genre;
-- drop table position;
-- drop table movie_people;
-- drop table studio;
-- drop table membership;

/* Create Tables */

-- No foreign key

Create table video_specifics (
	title varchar(50), 
	video_year integer,
	Rating float,
	Primary Key (title, video_year));

Create table customer_address (
	postalCode varchar(6) Primary Key,
	province varchar (20),
	city varchar (20));

Create table genre (entity_name varchar(20) Primary Key);

Create table position (positionType varchar(20) Primary Key);

Create table movie_people (entity_name varchar(20) Primary Key);

Create table studio(
  	entity_name varchar(250),
 	PRIMARY KEY (entity_name));


Create table membership (
	membershipType varchar(20) Primary Key,
	price real);


Create table watch_history (
	dateAndTime timestamp Primary Key);

-- Has foreign key

Create table videos (
	videoID integer,
	title varchar(50), 
	video_year integer,
	video_length integer,
	video_description varchar(100),
	Episode integer,
	Primary Key (videoID),
	Foreign Key (title, video_year) references video_specifics(title,video_year));


Create table customers (
	customerID integer Primary Key,
	email varchar(40) UNIQUE,
	entity_name varchar(20),
	age INTEGER,
	postalCode varchar(6),
	Foreign Key (postalCode) references customer_address(postalCode));



Create table adds (
	videoID integer,
	customerID integer,
	dateAndTime timestamp,
	Primary Key(videoID, customerID, dateAndTime),
	Foreign Key(videoID) references videos(videoID),
	Foreign Key(customerID) references customers(customerID),
	Foreign Key(dateAndTime) references watch_history(dateAndTime) ON DELETE CASCADE);

Create table has (
	videoID integer,
    entity_name varchar(20),
    Primary Key(videoID),
    Foreign Key(videoID) references videos(videoID), 
    Foreign Key(entity_name) references genre(entity_name));

Create table producedby (
	videoID integer,
	entity_name  varchar(120),
	Primary key (videoID, entity_name),
	Foreign key (videoID) references videos(videoID),
	Foreign key (entity_name) references studio(entity_name));

Create table non_cartoon (
	videoID integer Primary Key, 
	location_setting varchar(50),
	Foreign Key (videoID) references videos(videoID));

Create table cartoon (
	videoID integer Primary Key,
	Setting varchar(20),
	Foreign Key (videoID) references videos(videoID));

Create table subscription_invoice (
	invoiceID integer,
	membershipType varchar(20),
	price float,
	PRIMARY KEY (invoiceID, membershipType),
	FOREIGN KEY (membershipType) references membership(membershipType) ON DELETE CASCADE);

Create table recommendation (
	customerID integer Primary Key,
	movieID integer,
	FOREIGN KEY (customerID) references customers(customerID) ON DELETE CASCADE,
	FOREIGN KEY	(movieID) references videos(videoID));



Create table MoviePeopleHavePositions (
	positionType varchar(20),
	personName varchar(20),
	Primary Key (personName, positionType),
	Foreign Key (personName) references movie_people(entity_name),
	Foreign Key (positionType) references position(positionType));







/* Instances */


-- No reference

insert into video_specifics
	values ('The Big Bang Theory', '2018', '5');

insert into video_specifics
	values ('Brooklyn 99', '2015', '4.5');

insert into video_specifics
	values ('One punch man', '2019', '4');

insert into video_specifics
	values ('Gossip Girl', '2007', '3.7');

insert into video_specifics
	values ('Game of Thrones', '2011', '4.5');

insert into video_specifics
	values ('Larva Island', '2018', '5');


insert into customer_address 
	values ('V9N', 'Richmond', 'BC');

insert into customer_address
	values ('V4Z', 'Burnaby', 'BC');

insert into customer_address
	values ('V2T', 'Vancouver', 'BC');

insert into customer_address
	values ('V3L', 'New Westminster', 'BC');

insert into customer_address
	values ('V6R', 'Vancouver', 'BC');



insert into genre
	values ('Comedy');

insert into genre
	values ('Horror');

insert into genre
	values ('Romance');

insert into genre
	values ('Documentary');

insert into genre
	values ('Action');

insert into genre
	values('Animation');



insert into position
	values ('Director');

insert into position
	values ('Actor');

insert into position
	values ('Scripter');

insert into position
	values ('Producer');

insert into position
	values ('Assistant');



insert into movie_people 
	values ('Bob');

insert into movie_people
	values ('John');

insert into movie_people
	values ('Amy');

insert into movie_people
	values ('Luke');

insert into movie_people
	values ('Rob');





insert into studio
	values ('Warner Bros');

insert into studio
	values ('21 fox');

insert into studio
	values ('Paramount Pictures');

insert into studio
	values ('Walt Disney');

insert into studio
	values ('Universal Pictures');




insert into membership
	values ('Basic', '9.99');

insert into membership
	values ('Standard', '13.99');

insert into membership
	values ('Premium', '16.99');

insert into watch_history
	values ('2020-04-20');

insert into watch_history
	values ('2020-03-20');

insert into watch_history
	values ('2020-02-29');

insert into watch_history
	values ('2020-01-30');

insert into watch_history
	values ('2020-06-05');

-- Has reference


insert into videos
	values ('1', 'The Big Bang Theory', '2018', '60', 'a comedy about brilliant physicists', '20');

insert into videos
	values ('2', 'Brooklyn 99', '2015', '20', 'follows the exploits of hilarious Det. Jake Peralta and his diverse, lovable colleagues', '13');

insert into videos
	values ('3', 'One punch man', '2019', '25', 'the story of Saitama, a superhero who can defeat any opponent with a single punch', '28');

insert into videos
	values ('4', 'Gossip Girl', '2007', '42', 'the lives of privileged teenagers on the upper east side', '18');

insert into videos
	values ('5', 'Game of Thrones', '2011', '50', 'the story of a civil war in the fictional continents of Westeros', '10');

insert into videos 
	values ('6', 'Larva Island', '2018', '30', 'Stranded on a tropical island, two silly larva buddies find slapstick fun in everything', '20');



insert into customers
	values ('1', 'milestone3@gmail.com', 'Owen', '39', 'V9N');

insert into customers
	values ('2', 'milestone3a@gmail.com', 'Amy', '19', 'V4Z');

insert into customers
	values ('3', 'milestone3b@gmail.com', 'Violet', '30', 'V2T');

insert into customers
	values ('4', 'milestone3c@gmail.com', 'Tris', '25', 'V3L');

insert into customers
	values ('5', 'milestone3d@gmail.com', 'Chris', '21', 'V9N');





insert into adds
	values ('1', '1', '2020-04-20');

insert into adds
	values ('1', '2', '2020-03-20');

insert into adds
	values ('2', '2', '2020-02-29');

insert into adds
	values ('1', '3', '2020-01-30');

insert into adds
	values ('1', '5', '2020-06-05');


insert into adds
	values ('2', '1', '2020-06-05');

insert into adds
	values ('3', '1', '2020-06-05');

insert into adds
	values ('4', '1', '2020-06-05');

insert into adds
	values ('5', '1', '2020-06-05');

insert into adds
	values ('6', '1', '2020-06-05');




insert into has
	values ('1', 'Comedy');

insert into has
	values ('2', 'Horror');

insert into has
	values ('3', 'Comedy');

insert into has
	values ('4', 'Romance');

insert into has
	values ('5', 'Horror');

insert into has
	values ('6', 'Animation');




insert into producedby
	values ('2', 'Warner Bros');

insert into producedby
	values ('3', '21 fox');

insert into producedby
	values ('1', 'Paramount Pictures');

insert into producedby
	values ('4', 'Walt Disney');

insert into producedby
	values ('5', 'Universal Pictures');



insert into non_cartoon
	values ('1', 'Pasadena, CA');

insert into non_cartoon
	values ('2', 'New York City');

insert into non_cartoon
	values ('4', 'New York City');

insert into non_cartoon
	values ('5', 'Seven Kingdoms of Westeros');



insert into cartoon
	values ('3', 'Supercontinent Earth');

insert into cartoon
	values ('6', 'Island');



insert into subscription_invoice
	values ('1', 'Basic', '9.99');

insert into subscription_invoice
	values ('2', 'Premium', '16.99');

insert into subscription_invoice
	values ('4', 'Standard', '13.99');

insert into subscription_invoice
	values ('5', 'Standard', '13.99');

insert into subscription_invoice
	values ('6', 'Premium', '16.99');



insert into recommendation
	values ('1', '5');

insert into recommendation
	values ('2', '5');

insert into recommendation
	values ('3', '1');

insert into recommendation
	values ('4', '2');

insert into recommendation
	values ('5', '4');




insert into MoviePeopleHavePositions
	values ('Director', 'Bob');

insert into MoviePeopleHavePositions
	values ('Actor', 'John');

insert into MoviePeopleHavePositions
	values ('Actor', 'Amy');

insert into MoviePeopleHavePositions
	values ('Scripter', 'Luke');

insert into MoviePeopleHavePositions
	values ('Assistant', 'Rob');


/* SQL Queries */











