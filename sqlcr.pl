#!/usr/bin/perl

# Author:	Badgerati
# License:	MIT
# Date:		25/09/2015

use Switch;
use Term::ANSIColor qw(:constants);

# Check arguments supplied
my $argc = $#ARGV + 1;
if ($argc == 0 || $argc > 2) {
	print RED, "Usage: sqlcr.pl sql_directory [TSQL|MySql]\n", RESET;
	exit;
}

my $sql_type = "TSQL";
if ($argc == 2) {
	$sql_type = uc $ARGV[1];
}

my $com_regex = undef;
switch ($sql_type) {
	case "TSQL"		{ $com_regex = qr/(\/\*.*?\*\/|--.*?$)/sm; }
	case "MYSQL"	{ $com_regex = qr/(\/\*[^!].*?\*\/|--\s.*?$|#.*?$)/sm; }
	else {
		print RED, "Usage: sqlcr.pl sql_directory [TSQL|MySql]\n", RESET;
		exit;
	}
}

# Set encoding, and walk through folders removing comments
my $encoding = ":encoding(UTF-8)";
walk_dir($ARGV[0]);

sub walk_dir {
	my ($dir) = @_;

	if ((-f $dir) && ($dir =~ m/\.sql$/)) {
		remove_comments($dir);
	}
	else {
		my $current_dir = undef;
		opendir DIR, $dir or die "Can't open directory: $!";
		
		while (my $file = readdir(DIR)) {
			$current_dir = "$dir/$file";

			if ((-f $current_dir) && ($file =~ m/\.sql$/)) {
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
