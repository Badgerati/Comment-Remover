SQL Comment Remover
===================
SQLCR is a Perl script which will remove all comments from a given SQL file. Useful for if you need to remove sensitive data from comments, or to save some extra bytes.

SQLCR currently only supports TSQL comments (MySQL will come soon).

Comments of the following are supported:

* /* ... */
* -- ...

The comments removed can be anywhere within the file.


Usage
=====
To run SQLCR, use:

```shell
perl sqlcr.pl C:\path\to\sql\files
```

SQLCR will strip down all SQL files within the given directory and all sub-directories.
(Support for individual files will come soon).


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
perl sqlcr.pl C:\path\to\directory
```

Will remove all comments from all SQL files within the directory and sub-directories. Meaning the above will be stripped down to:

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