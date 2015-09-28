#!/usr/bin/perl

#########################################################
# Author:   Badgerati
# License:  MIT
# Date:     25/09/2015
#
# Description:
# Removes all comments from a given supported file type
#
# Warning:
# If a "comment" is detected within a string value, it
# will also be removed. Please ensure there are none
# before running this script
#########################################################

use Switch;
use Term::ANSIColor qw(:constants);

# Check arguments supplied
my $argc = $#ARGV + 1;
if ($argc != 2) {
        show_help();
}

my $type = uc $ARGV[1];
my $com_regex = undef;
my $ext = undef;

switch ($type) {
    case "TSQL" {
        $com_regex = qr/(\/\*.*?\*\/|--.*?$)/sm;
        $ext = "sql";
    }

    case "MYSQL" {
        $com_regex = qr/(\/\*[^!].*?\*\/|--\s.*?$|#.*?$)/sm;
        $ext = "sql";
    }

    case "JAVA" {
        $com_regex = qr/(\/\*.*?\*\/|\/\/.*?$)/sm;
        $ext = "java";
    }

    case "CS" {
        $com_regex = qr/(\/\*.*?\*\/|\/\/.*?$)/sm;
        $ext = "cs";
    }
    
    else {
        show_help();
    }
}

# Set encoding, and walk through folders removing comments
my $encoding = ":encoding(UTF-8)";
walk_dir($ARGV[0]);

sub walk_dir {
    my ($dir) = @_;

    if ((-f $dir) && ($dir =~ m/\.\Q$ext\E$/)) {
        remove_comments($dir);
    }
    else {
        my $current_dir = undef;
        opendir DIR, $dir or die "Can't open directory: $!";
        
        while (my $file = readdir(DIR)) {
            $current_dir = "$dir/$file";

            if ((-f $current_dir) && ($file =~ m/\.\Q$ext\E$/)) {
                remove_comments($current_dir);
            }
            elsif ((-d $current_dir) && !($file =~ m/^\./)) {
                walk_dir($current_dir);
            }
        }

        closedir(DIR);
    }
}

sub remove_comments {
    my ($file) = @_;
    my $handle = undef;

    open ($handle, "< $encoding", $file) || die "$0: can't open $file for reading: $!";
    @lines = <$handle>;
    close $handle or die "$handle: $!";

    $joined_lines = join('', @lines);
    $joined_lines =~ s/$com_regex//g;

    open ($handle, "> $encoding", $file) || die "$0: can't open $file for writing: $!";
    print $handle $joined_lines;
    close $handle or die "$handle: $!"
}

sub show_help {
    print YELLOW, "Usage: cremove.pl [directory|file] [comment type]\n", RESET;
    print YELLOW, "\nComment Types:\n\n TSQL\n MySql\n CS\n Java\n", RESET;
    exit;
}