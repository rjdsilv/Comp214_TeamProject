﻿ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

DROP INDEX IX_BOOKS_01;
DROP INDEX IX_BOOKS_02;
DROP INDEX IX_BOOK_RENTAL_01;
DROP INDEX IX_BOOKS_AUTHORS_01;
DROP INDEX IX_BOOK_RENTAL_DETAIL_01;

DROP SEQUENCE USER_SEQ;
DROP SEQUENCE BOOK_RENTAL_SEQ;

DROP TABLE TBUB_BOOK_RENTAL_DETAIL;
DROP TABLE TBUB_BOOKS_CATEGORIES;
DROP TABLE TBUB_BOOKS_AUTHORS;
DROP TABLE TBUB_BOOK_RENTAL;
DROP TABLE TBUB_BOOKS;
DROP TABLE TBUB_PUBLISHERS;
DROP TABLE TBUB_AUTHORS;
DROP TABLE TBUB_CATEGORIES;
DROP TABLE TBUB_USERS;

CREATE SEQUENCE USER_SEQ        START WITH 10000 INCREMENT BY 1 MAXVALUE 99999999999     CACHE 50 ORDER;
CREATE SEQUENCE BOOK_RENTAL_SEQ START WITH 20000 INCREMENT BY 1 MAXVALUE 999999999999999 CACHE 50 ORDER;

CREATE TABLE TBUB_PUBLISHERS (
    PUBLISHER_ID
        DECIMAL(6, 0)
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY
        NOT NULL
,	PUBLISHER_NAME
        VARCHAR2(64)
        NOT NULL
,	PUBLISHER_CREATE_DATE
        TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
        NOT NULL
);

CREATE TABLE TBUB_AUTHORS (
    AUTHOR_ID
        DECIMAL(10, 0)
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY
        NOT NULL
,	AUTHOR_NAME
        VARCHAR2(128)
        NOT NULL
,	AUTHOR_CREATE_DATE
        TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
        NOT NULL
);

CREATE TABLE TBUB_CATEGORIES (
    CATEGORY_ID
        DECIMAL(4, 0)
        GENERATED ALWAYS AS IDENTITY
        PRIMARY KEY
        NOT NULL
,	CATEGORY_NAME
        VARCHAR2(64)
        NOT NULL
        UNIQUE
,	CATEGORY_CREATE_DATE
        TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
        NOT NULL
);

CREATE TABLE TBUB_USERS (
    USER_ID
        DECIMAL(11, 0)
        DEFAULT USER_SEQ.NEXTVAL
        PRIMARY KEY
        NOT NULL
,	USER_EMAIL
        VARCHAR2(64)
        NOT NULL
        UNIQUE
,	USER_PASSWORD
        CHAR(64)
        NOT NULL
,	USER_FIRST_NAME
        VARCHAR2(32)
        NOT NULL
,	USER_LAST_NAME
        VARCHAR2(64)
        NOT NULL
,	USER_ROLE
		VARCHAR2(5)
		NOT NULL
,	USER_CREATE_DATE
        TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
        NOT NULL
);

CREATE TABLE TBUB_BOOK_RENTAL (
    RENTAL_ID
        DECIMAL(15, 0)
        DEFAULT USER_SEQ.NEXTVAL
        PRIMARY KEY
        NOT NULL
,	RENTAL_DATE
        DATE
        DEFAULT SYSDATE
        NOT NULL
,	RENTAL_DUE_DATE
		DATE
		DEFAULT (SYSDATE + 7)
		NOT NULL
,	RENTAL_RETURN_DATE
        DATE
        NULL
,	USER_ID
        DECIMAL(11)
        NOT NULL
,   CONSTRAINT FK_BOOK_RENTAL_01
        FOREIGN KEY(USER_ID) REFERENCES TBUB_USERS(USER_ID)
);

CREATE TABLE TBUB_BOOKS (
    BOOK_ISBN
        DECIMAL(13, 0)
        PRIMARY KEY
        NOT NULL
,	BOOK_TITLE
        VARCHAR2(128)
        NOT NULL
,	BOOK_DESCRIPTION
        VARCHAR2(2048)
,	BOOK_PUBLICATION_DATE
        DATE
        NOT NULL
,	BOOK_EDITION
        DECIMAL(2, 0)
        NOT NULL
,	BOOK_IS_AVAILABLE
        DECIMAL(1, 0)
        NOT NULL
,	BOOK_QUANTITY_AVAILABLE
        DECIMAL(3, 0)
        NOT NULL
,	BOOK_PAGES
		DECIMAL(5, 0)
		NOT NULL
,	BOOK_IMG_URL_01
        VARCHAR2(255)
        NOT NULL
,	BOOK_IMG_URL_02
        VARCHAR2(255)
,	BOOK_IMG_URL_03
        VARCHAR2(255)
,	BOOK_IMG_URL_04
        VARCHAR2(255)
,	BOOK_IMG_URL_05
        VARCHAR2(255)
,	BOOK_CREATE_DATE
        TIMESTAMP
        DEFAULT CURRENT_TIMESTAMP
        NOT NULL
,	BOOK_REMOVE_DATE
        TIMESTAMP
,	BOOK_LAST_UPDATE_DATE
        TIMESTAMP
,	PUBLISHER_ID
        DECIMAL(6, 0)
        NOT NULL
,       CONSTRAINT FK_BOOKS_01
            FOREIGN KEY(PUBLISHER_ID) REFERENCES TBUB_PUBLISHERS(PUBLISHER_ID)
);

CREATE TABLE TBUB_BOOKS_AUTHORS (
    BOOK_ISBN
        DECIMAL(13, 0)
        NOT NULL
,	AUTHOR_ID
        DECIMAL(10, 0)
        NOT NULL
,	CONSTRAINT PK_BOOKS_AUTHORS
        PRIMARY KEY(BOOK_ISBN, AUTHOR_ID)
,   CONSTRAINT FK_BOOKS_AUTORS_01
        FOREIGN KEY(BOOK_ISBN) REFERENCES TBUB_BOOKS(BOOK_ISBN)
,   CONSTRAINT FK_BOOKS_AUTORS_02
        FOREIGN KEY(AUTHOR_ID) REFERENCES TBUB_AUTHORS(AUTHOR_ID)
);

CREATE TABLE TBUB_BOOKS_CATEGORIES (
    BOOK_ISBN
        DECIMAL(13, 0)
        NOT NULL
,	CATEGORY_ID
        DECIMAL(4, 0)
        NOT NULL
,	CONSTRAINT PK_BOOKS_CATEGORIES
        PRIMARY KEY (BOOK_ISBN, CATEGORY_ID)
,   CONSTRAINT FK_BOOKS_CATEGORIES_01
        FOREIGN KEY(BOOK_ISBN)   REFERENCES TBUB_BOOKS(BOOK_ISBN)
,   CONSTRAINT FK_BOOKS_CATEGORIES_02
        FOREIGN KEY(CATEGORY_ID) REFERENCES TBUB_CATEGORIES(CATEGORY_ID)
);

CREATE TABLE TBUB_BOOK_RENTAL_DETAIL (
    RENTAL_ID
        DECIMAL(15, 0)
        DEFAULT BOOK_RENTAL_SEQ.NEXTVAL
        NOT NULL
,	BOOK_ISBN
        DECIMAL(13, 0)
        NOT NULL
,	CONSTRAINT PK_BOOK_RENTAL_DETAIL
        PRIMARY KEY(RENTAL_ID, BOOK_ISBN)
,   CONSTRAINT FK_BOOK_RENTAL_DETAIL_01
        FOREIGN KEY(RENTAL_ID) REFERENCES TBUB_BOOK_RENTAL(RENTAL_ID)
,   CONSTRAINT FK_BOOK_RENTAL_DETAIL_02
        FOREIGN KEY(BOOK_ISBN) REFERENCES TBUB_BOOKS(BOOK_ISBN)
);

/*
 * Creating Indexes.
 */    
CREATE INDEX IX_BOOKS_01 ON TBUB_BOOKS(BOOK_TITLE);
CREATE INDEX IX_BOOKS_02 ON TBUB_BOOKS(PUBLISHER_ID);
CREATE INDEX IX_BOOK_RENTAL_01 ON TBUB_BOOK_RENTAL(USER_ID);
CREATE INDEX IX_BOOK_RENTAL_DETAIL_01 ON TBUB_BOOK_RENTAL_DETAIL(BOOK_ISBN);
CREATE INDEX IX_BOOKS_AUTHORS_01 ON TBUB_BOOKS_AUTHORS(AUTHOR_ID);

/*
 * Inserting Data.
 */
INSERT INTO	TBUB_USERS (USER_EMAIL, USER_PASSWORD, USER_FIRST_NAME, USER_LAST_NAME, USER_ROLE, USER_CREATE_DATE)
VALUES( 'admin_01@admin.com', 'Admin1234', 'Administrator 1', '01', 'ADMIN', CURRENT_TIMESTAMP);
INSERT INTO	TBUB_USERS (USER_EMAIL, USER_PASSWORD, USER_FIRST_NAME, USER_LAST_NAME, USER_ROLE, USER_CREATE_DATE)
VALUES( 'admin_02@admin.com', 'Admin1234', 'Administrator 2', '02', 'ADMIN', CURRENT_TIMESTAMP);
INSERT INTO	TBUB_USERS (USER_EMAIL, USER_PASSWORD, USER_FIRST_NAME, USER_LAST_NAME, USER_ROLE, USER_CREATE_DATE)
VALUES( 'admin_03@admin.com', 'Admin1234', 'Administrator 3', '03', 'ADMIN', CURRENT_TIMESTAMP);
INSERT INTO	TBUB_USERS (USER_EMAIL, USER_PASSWORD, USER_FIRST_NAME, USER_LAST_NAME, USER_ROLE, USER_CREATE_DATE)
VALUES( 'user_01@admin.com', 'User1234', 'User 1', '01', 'USER', CURRENT_TIMESTAMP);
INSERT INTO	TBUB_USERS (USER_EMAIL, USER_PASSWORD, USER_FIRST_NAME, USER_LAST_NAME, USER_ROLE, USER_CREATE_DATE)
VALUES( 'user_02@admin.com', 'User1234', 'User 2', '01', 'USER', CURRENT_TIMESTAMP);

INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Fantasy');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Magic');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Information Technology');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Artificial Intelligence');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Game Programming');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Mathematics');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('History');
INSERT INTO TBUB_CATEGORIES(CATEGORY_NAME) VALUES('Thriller');

INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('J. K. Rowling');
INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('Peter Norvig Stuart J Russell');
INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('Jason Gregory');
INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('Robert Nystrom');
INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('Eric Lengyel');
INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('George R.R. Martin');
INSERT INTO TBUB_AUTHORS(AUTHOR_NAME) VALUES('Bernard Cornwell ');

INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('Bloomsbury Childre''s Books');
INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('Pearson India');
INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('A K Peters/CRC Press');
INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('Genever Benning');
INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('Course Technology PTR');
INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('Bantam; Media Tie In edition');
INSERT INTO TBUB_PUBLISHERS(PUBLISHER_NAME) VALUES('HarperCollins');

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9781408845646, 'Harry Potter and the Philosopher''s Stone: Illustrated Edition',
	'Prepare to be spellbound by Jim Kay''s dazzling depiction of the wizarding world and much loved characters in this full-colour illustrated hardback edition of the nation''s favourite children''s book – Harry Potter and the Philosopher''s Stone. Brimming with rich detail and humour that perfectly complements J.K. Rowling''s timeless classic, Jim Kay''s glorious illustrations will captivate fans and new readers alike.',
	'2015-10-06', 1, 1, 2, 300, 1,
	'https://images-na.ssl-images-amazon.com/images/I/51sTwK7kBxL.jpg', 
	'https://images-na.ssl-images-amazon.com/images/I/51bor5867kL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/A1Zq8UVPX5L.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/A1WzMnxvS4L.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/91oBYD92sIL.jpg');

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9781408845653, 'Harry Potter and the Chamber of Secrets: Illustred Edition',
	'Prepare to be spellbound by Jim Kay''s dazzling full-colour illustrations in this stunning new edition of J.K. Rowling''s Harry Potter and the Chamber of Secrets. Breathtaking scenes, dark themes and unforgettable characters await inside this fully illustrated edition. With paint, pencil and pixels, award-winning illustrator Jim Kay conjures the wizarding world as we have never seen it before. Fizzing with magic and brimming with humour, this inspired reimagining will captivate fans and new readers alike, as Harry and his friends, now in their second year at Hogwarts School of Witchcraft and Wizardry, seek out a legendary chamber and the deadly secret that lies at its heart.',
	'2016-10-04', 1, 1, 1, 289, 1,
	'https://images-na.ssl-images-amazon.com/images/I/61%2BabdOC5gL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/A1ikEJqTnuL.jpg',
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9781408845660, 'Harry Potter and the Prisoner of Azkaban',
	'An extraordinary creative achievement by an extraordinary talent, Jim Kay''s inspired reimagining of J.K. Rowling''s classic series has captured a devoted following worldwide. This stunning new fully illustrated edition of Harry Potter and the Prisoner of Azkaban brings more breathtaking scenes and unforgettable characters – including Sirius Black, Remus Lupin and Professor Trelawney. With paint, pencil and pixels, Kay conjures the wizarding world as we have never seen it before. Fizzing with magic and brimming with humour, this full-colour edition will captivate fans and new readers alike as Harry, now in his third year at Hogwarts School of Witchcraft and Wizardry, faces Dementors, death omens and, of course, danger.',
	'2017-10-03', 1, 1, 3, 334, 1,
	'https://images-na.ssl-images-amazon.com/images/I/A1RGxzkX3ML.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/41Lu0KOI3cL.jpg',
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9781408890769, 'Harry Potter - A History of Magic: The Book of the Exhibition',
	'Harry Potter: A History of Magic is the official book of the exhibition, a once-in-a-lifetime collaboration between Bloomsbury, J.K. Rowling and the brilliant curators of the British Library. It promises to take readers on a fascinating journey through the subjects studied at Hogwarts School of Witchcraft and Wizardry - from Alchemy and Potions classes through to Herbology and Care of Magical Creatures.',
	'2017-10-20', 1, 1, 1, 256, 1,
	'https://images-na.ssl-images-amazon.com/images/I/61Lo-%2BFBs%2BL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/51Ck3uTZQEL.jpg',
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9789332543515, 'Artificial Intelligence : A Modern Approach',
	'Brand New. Artificial Intlelligence theory book.',
	'2015-09-12', 3, 1, 5, 795, 2,
	'https://images-na.ssl-images-amazon.com/images/I/71MgQIMnAWL.jpg',
	NULL,
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9781466560017, 'Game Engine Architecture',
	'Hailed as a "must-have textbook" (CHOICE, January 2010), the first edition of Game Engine Architecture provided readers with a complete guide to the theory and practice of game engine software development. Updating the content to match today’s landscape of game engine architecture, this second edition continues to thoroughly cover the major components that make up a typical commercial game engine.',
	'2014-08-15', 2, 1, 2, 1052, 3,
	'https://images-na.ssl-images-amazon.com/images/I/51P2wXledgL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/51wlTrj0q1L.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/41GV0KOj4ZL.jpg',
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9780990582908, 'Game Programming Patterns',
	'The biggest challenge facing many game programmers is completing their game. Most game projects fizzle out, overwhelmed by the complexity of their own code. Game Programming Patterns tackles that exact problem. Based on years of experience in shipped AAA titles, this book collects proven patterns to untangle and optimize your game, organized as independent recipes so you can pick just the patterns you need.',
	'2014-11-02', 1, 1, 1, 354, 4,
	'https://images-na.ssl-images-amazon.com/images/I/71Kfg2zTisL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81NmSfv4NoL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/31mSaO0vaFL.jpg',
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9781435458864, 'Mathematics for 3D Game Programming and Computer Graphics',
	'This updated third edition illustrates the mathematical concepts that a game developer needs to develop 3D computer graphics and game engines at the professional level. It starts at a fairly basic level in areas such as vector geometry and linear algebra, and then progresses to more advanced topics in 3D programming such as illumination and visibility determination. Particular attention is given to derivations of key results, ensuring that the reader is not forced to endure gaps in the theory. The book assumes a working knowledge of trigonometry and calculus, but also includes sections that review the important tools used from these disciplines, such as trigonometric identities, differential equations, and Taylor series.',
	'2011-07-02', 3, 1, 3, 624, 5,
	'https://images-na.ssl-images-amazon.com/images/I/61k9lBQjfWL.jpg',
	NULL,
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9780345535528, 'Game of Thrones 5-Book Boxed Set (Song of Ice and Fire Series)',
	'For the first time, all five novels in the epic fantasy series that inspired HBO’s Game of Thrones are together in one boxed set. An immersive entertainment experience unlike any other, A Song of Ice and Fire has earned George R. R. Martin—dubbed “the American Tolkien” by Time magazine—international acclaim and millions of loyal readers. Now here is the entire monumental cycle:<br /><br />A GAME OF THRONES<br/>A CLASH OF KINGS<br />A STORM OF SWORDS<br />A FEAST FOR CROWS<br />A DANCE WITH DRAGONS',
	'2013-10-29', 1, 1, 2, 5216, 6,
	'https://images-na.ssl-images-amazon.com/images/I/61Y-vYqyqYL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/919-FLL37TL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81sBQOYFeSL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81tE51KeB7L.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81tE51KeB7L.jpg');

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9780007218011, 'The Last Kingdom Series, Book 1 - The Last Kingdom',
	'The first book in Bernard Cornwell’s epic and bestselling series on the making of England and the fate of his great hero, Uhtred of Bebbanburg. BBC2’s major Autumn 2015 TV show THE LAST KINGDOM is based on the first two books in the series.',
	'2006-03-20', 1, 1, 5, 352, 7,
	'https://images-na.ssl-images-amazon.com/images/I/515enqa9E6L.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81v3TpKxfrL.jpg',
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9780007149933, 'The Last Kingdom Series, Book 2 - The Pale Horseman',
	'The second book in Bernard Cornwell’s epic and bestselling series on the making of England and the fate of his great hero, Uhtred of Bebbanburg. BBC2’s major Autumn 2015 TV show THE LAST KINGDOM is based on the first two books in the series.',
	'2007-07-08', 1, 1, 3, 464, 7,
	'https://images-na.ssl-images-amazon.com/images/I/51nK9GYj4hL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81BhVT8b1HL.jpg',
	NULL,
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS(BOOK_ISBN, BOOK_TITLE, BOOK_DESCRIPTION, BOOK_PUBLICATION_DATE, BOOK_EDITION, BOOK_IS_AVAILABLE, BOOK_QUANTITY_AVAILABLE, BOOK_PAGES, PUBLISHER_ID, BOOK_IMG_URL_01, BOOK_IMG_URL_02, BOOK_IMG_URL_03, BOOK_IMG_URL_04, BOOK_IMG_URL_05)
VALUES(
	9780007219704, 'The Last Kingdom Series, Book 3 - The Lords of the ',
	'The third book in Bernard Cornwell’s epic and bestselling series on the making of England and the fate of his great hero, Uhtred of Bebbanburg. BBC2’s major Autumn 2015 TV show THE LAST KINGDOM is based on the first two books in the series.',
	'2006-03-27', 2, 1, 7, 400, 7,
	'https://images-na.ssl-images-amazon.com/images/I/51IaKfJoMpL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/81s5D-QQ4yL.jpg',
	'https://images-na.ssl-images-amazon.com/images/I/41TgdMs80ZL.jpg',
	NULL,
	NULL);

INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9781408845646, 1);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9781408845653, 1);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9781408845660, 1);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9781408890769, 1);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9789332543515, 2);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9781466560017, 3);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9780990582908, 4);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9781435458864, 5);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9780345535528, 6);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9780007218011, 7);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9780007149933, 7);
INSERT INTO TBUB_BOOKS_AUTHORS(BOOK_ISBN, AUTHOR_ID) VALUES(9780007219704, 7);

INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408845646, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408845646, 2);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408845653, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408845653, 2);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408845660, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408845660, 2);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408890769, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781408890769, 2);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9789332543515, 3);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9789332543515, 4);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781466560017, 3);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781466560017, 5);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780990582908, 3);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780990582908, 5);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781435458864, 3);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781435458864, 5);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9781435458864, 6);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780345535528, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780345535528, 2);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007218011, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007218011, 7);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007218011, 8);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007149933, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007149933, 7);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007149933, 8);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007219704, 1);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007219704, 7);
INSERT INTO TBUB_BOOKS_CATEGORIES(BOOK_ISBN, CATEGORY_ID) VALUES(9780007219704, 8);

COMMIT;

/*
 * CREATE FUNCTIONS
 */
CREATE OR REPLACE FUNCTION FNUB_OPENED_RENT (
	UserId	IN  DECIMAL
)
RETURN DECIMAL
IS
	lvReturnDate	DATE;
BEGIN
	SELECT		RENTAL_RETURN_DATE
	INTO		lvReturnDate
	FROM		TBUB_BOOK_RENTAL
	WHERE		USER_ID		=	UserId
	ORDER BY	RENTAL_DATE	DESC
	,           RENTAL_ID
	OFFSET		0	ROWS
	FETCH NEXT	1	ROWS ONLY;

	IF (lvReturnDate IS NULL) THEN
		RETURN 1;
	END IF;

	RETURN 0;

EXCEPTION
	WHEN NO_DATA_FOUND	THEN RETURN 0;
	WHEN OTHERS			THEN RETURN 0;

END FNUB_OPENED_RENT;

/

CREATE OR REPLACE FUNCTION FNUB_USER_REGISTERED (
	UserEmail	IN  VARCHAR2
)
RETURN DECIMAL
IS
    lvNumOfUsersWithEmail   DECIMAL(1, 0);
BEGIN
    SELECT  COUNT(1)
    INTO    lvNumOfUsersWithEmail
    FROM    TBUB_USERS
    WHERE   USER_EMAIL  =   UserEmail;

	IF (lvNumOfUsersWithEmail > 0) THEN
		RETURN 1;
	END IF;

	RETURN 0;

EXCEPTION
	WHEN OTHERS THEN RETURN 0;

END FNUB_USER_REGISTERED;

/

/*
 * CREATE PROCEDURES
 */

CREATE OR REPLACE PROCEDURE SPUB_LOGIN (
    UserEmail        IN  VARCHAR2
,   UserPassword     IN  CHAR
,   UserId			 OUT DECIMAL
,	UserRole		 OUT VARCHAR2
,   UserFirstName    OUT VARCHAR2
,   UserLastName     OUT VARCHAR2
)
IS
BEGIN

    SELECT  USER_ID
	,		USER_ROLE
    ,       USER_FIRST_NAME
    ,       USER_LAST_NAME
    INTO    UserId
	,		UserRole
    ,       UserFirstName
    ,       UserLastName
    FROM    TBUB_USERS
    WHERE   USER_EMAIL      =   UserEmail
    AND     USER_PASSWORD   =   UserPassword;

EXCEPTION
    WHEN NO_DATA_FOUND THEN UserId := -1;

END SPUB_LOGIN;

/

CREATE OR REPLACE PROCEDURE SPUB_REGISTER (
    UserEmail        IN  VARCHAR2
,   UserPassword     IN  CHAR
,   UserFirstName    IN  VARCHAR2
,   UserLastName     IN  VARCHAR2
,   UserId           OUT DECIMAL
,	UserRole		 OUT VARCHAR2
)
IS
    lvUserRegistered   DECIMAL(1, 0);
BEGIN
	lvUserRegistered := FNUB_USER_REGISTERED(UserEmail);
    
    IF (lvUserRegistered = 0) THEN
		INSERT
		INTO	TBUB_USERS (
			USER_EMAIL
		,	USER_PASSWORD
		,	USER_ROLE
		,	USER_FIRST_NAME
		,	USER_LAST_NAME
		) VALUES (
			UserEmail
		,	UserPassword
		,	'USER'
		,	UserFirstName
		,	UserLastName
		);
    
        COMMIT;

        SELECT  USER_ID
		,		USER_ROLE
        INTO    UserId
		,		UserRole
        FROM    TBUB_USERS
        WHERE   USER_EMAIL  =   UserEmail;
    ELSE
        UserId := -1;
    END IF;

EXCEPTION
	WHEN OTHERS	THEN ROLLBACK;

END SPUB_REGISTER;

/

CREATE OR REPLACE PROCEDURE SPUB_UPDATE_PROFILE (
	UserEmail		IN	VARCHAR2
,	UserFirstName	IN	VARCHAR2
,	UserLastName	IN	VARCHAR2
,	UserId			OUT	DECIMAL
,	UserRole		OUT	VARCHAR2
)
IS
	lvUserRegistered	DECIMAL(1, 0);
BEGIN
	lvUserRegistered := FNUB_USER_REGISTERED(UserEmail);
	
	IF (lvUserRegistered > 0) THEN
		UPDATE	TBUB_USERS
		SET		USER_FIRST_NAME	=	UserFirstName
		,		USER_LAST_NAME	=	UserLastName
		WHERE	USER_EMAIL		=	UserEmail;

		SELECT	USER_ID
		,		USER_ROLE
		INTO	UserId
		,		UserRole
		FROM	TBUB_USERS
		WHERE	USER_EMAIL	=	UserEmail;
	ELSE
		UserId := -1;
	END IF;

EXCEPTION
	WHEN NO_DATA_FOUND	THEN
		UserId := -1;
		ROLLBACK;

	WHEN OTHERS			THEN
		UserId := -1;
		ROLLBACK;

END SPUB_UPDATE_PROFILE;

/

CREATE OR REPLACE PROCEDURE SPUB_RESERVE_BOOK (
	UserId			IN	DECIMAL
,	BookIsbn		IN	DECIMAL
,	RentalId		OUT	DECIMAL
,   RentalDate		OUT	DATE
,	RentalDueDate	OUT	DATE
)
IS
	lvHasOpenedRent	DECIMAL(1, 0);
BEGIN
	RentalId		:= BOOK_RENTAL_SEQ.NEXTVAL;
	lvHasOpenedRent := FNUB_OPENED_RENT(UserId);

	IF (lvHasOpenedRent = 0) THEN
		INSERT INTO	TBUB_BOOK_RENTAL (RENTAL_ID, USER_ID) VALUES (RentalId, UserId);

		INSERT INTO	TBUB_BOOK_RENTAL_DETAIL (
			RENTAL_ID
		,	BOOK_ISBN
		) VALUES (   
			RentalId
		,	BookIsbn
		);

		COMMIT;

		SELECT	RENTAL_DATE
		,		RENTAL_DUE_DATE
		INTO	RentalDate
		,		RentalDueDate
		FROM	TBUB_BOOK_RENTAL
		WHERE	RENTAL_ID		=	RentalId;
	ELSE
		RentalId := -1;
	END IF;

EXCEPTION
	WHEN NO_DATA_FOUND	THEN
		RentalId := -1;
		ROLLBACK;

	WHEN OTHERS			THEN
		RentalId := -1;
		ROLLBACK;
		
END SPUB_RESERVE_BOOK;

/

CREATE OR REPLACE PROCEDURE SPUB_UPDATE_BOOK (
	BookIsbn				DECIMAL
,	BookTitle				VARCHAR
,	BookDescription			VARCHAR
,	BookPublicationDate		DATE
,	BookEdition				DECIMAL
,	BookIsAvailable			DECIMAL
,	BookQuantityAvailable	DECIMAL
,	BookPages				DECIMAL
,	BookImageUrl01			VARCHAR
,	BookImageUrl02			VARCHAR
,	BookImageUrl03			VARCHAR
,	BookImageUrl04			VARCHAR
,	BookImageUrl05			VARCHAR
)
IS
BEGIN
	UPDATE	TBUB_BOOKS
	SET		BOOK_TITLE				=	BookTitle
	,		BOOK_DESCRIPTION		=	BookDescription
	,		BOOK_PUBLICATION_DATE	=	BookPublicationDate
	,		BOOK_EDITION			=	BookEdition
	,		BOOK_IS_AVAILABLE		=	BookIsAvailable
	,		BOOK_QUANTITY_AVAILABLE	=	BookQuantityAvailable
	,		BOOK_PAGES				=	BookPages
	,		BOOK_IMG_URL_01			=	BookImageUrl01
	,		BOOK_IMG_URL_02			=	BookImageUrl02
	,		BOOK_IMG_URL_03			=	BookImageUrl03
	,		BOOK_IMG_URL_04			=	BookImageUrl04
	,		BOOK_IMG_URL_05			=	BookImageUrl05
	WHERE	BOOK_ISBN				=	BookIsbn;

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN ROLLBACK;

END SPUB_UPDATE_BOOK;

/

/*
 * Create Triggers
 */
CREATE OR REPLACE TRIGGER TGUB_DECREASE_AVAILABLE_BOOKS
    AFTER INSERT ON TBUB_BOOK_RENTAL_DETAIL
    FOR EACH ROW
BEGIN
	UPDATE		TBUB_BOOKS
	SET			BOOK_QUANTITY_AVAILABLE	=	BOOK_QUANTITY_AVAILABLE - 1
	,			BOOK_IS_AVAILABLE		=	CASE
												WHEN BOOK_QUANTITY_AVAILABLE > 1 THEN 1
												ELSE 0
											END
	where       BOOK_ISBN	            =	:NEW.BOOK_ISBN;
END TGUB_DECREASE_AVAILABLE_BOOKS;

/

CREATE TRIGGER TGUB_INCREASE_AVAILABLE_BOOKS
	AFTER UPDATE OF RENTAL_RETURN_DATE ON TBUB_BOOK_RENTAL
	FOR EACH ROW
BEGIN
	UPDATE		TBUB_BOOKS
	SET			BOOK_QUANTITY_AVAILABLE	=	BOOK_QUANTITY_AVAILABLE + 1
	,			BOOK_IS_AVAILABLE		=	1
	WHERE		:OLD.RENTAL_RETURN_DATE	IS	NULL
	AND			:NEW.RENTAL_RETURN_DATE	IS	NOT NULL
	AND			BOOK_ISBN	IN	(
		SELECT	BOOK_ISBN
		FROM	TBUB_BOOK_RENTAL_DETAIL
		WHERE	RENTAL_ID	=	:NEW.RENTAL_ID
	);
END TGUB_INCREASE_AVAILABLE_BOOKS;

/