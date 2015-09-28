Comment Remover
===================
Comment Remover is a Perl script which will remove all comments from a given file or files in directories. Useful for if you need to remove sensitive data from comments, or to save some extra bytes.

Comment Remover currently supports the following comments for these languages:

* TSQL
* MySQL
* C#
* Java

The comments removed can be anywhere within the file. Please note, that if it detects a "comment" within a string value, this will be removed.


Usage
=====
To run Comment Remover, use:

```shell
perl cremove.pl [directory|file] [comment type]
```

Comment Remover will strip down all files within the given directory and all sub-directories, or from a single file if a literal file is passed.


Example
=======
Say you have the following SQL file:

```sql
/***************************************************************
 This is some dummy comment with a history and muliple other lines

 Author: Badgerati
 Date:   25/09/2015

 History
 Who            When            Why
 Badgerati      Now             Who knows
****************************************************************/
CREATE PROCEDURE uspRetrieveSomething
(
        @id     INT NOT NULL
)
AS
BEGIN
        -- Look I'm a comment too!
        SELECT
                *
        FROM
                SomeTable -- OMG SO AM I!
        WHERE
                ID = /* I'm an awkward inline comment, booo */ @id;
END
```

Running the following shell command:

```shell
perl cremove.pl C:\path\to\directory TSQL
```

Will remove all comments from all SQL files within the directory and sub-directories using the TSQL comment format. Meaning the above will be stripped down to:

```sql

CREATE PROCEDURE uspRetrieveSomething
(
        @id     INT NOT NULL
)
AS
BEGIN
        
        SELECT
                *
        FROM
                SomeTable 
        WHERE
                ID =  @id;
END
```

As you can see, all comments are gone!