#!/usr/bin/perl

use JSON;
use File::Copy qw(copy);

my $msg = "";

my @pairs = split(/&/,$ARGV[0]);
my %queries;
my $item;
my $value;

# Store the item/value pairs in a hash
foreach (@pairs)
{
	my ($item,$value) = split(/=/,$_);
	$queries{$item} = $value;
}

#print "essid=$queries{essid}, password=$queries{password}\n";

# If this is the first time we've tried this then back up /etc/wpa_supplicant/wpa_supplicant.conf

my $supplicantPath = "/etc/wpa_supplicant/wpa_supplicant.conf";

if (! -e $supplicantPath.".orig") {
#	print "Backing up $supplicantPath to $supplicantPath".".orig\n";
	# Backup the original file
	copy ($supplicantPath, $supplicantPath.".orig") or $msg = "Copy #1 failed: $!";	
}
else {
#	print "deleting file and then making copy of .orig\n";
	# We've been here before so remove modified supplicant file and take a copy of the original
	unlink $supplicantPath;
	copy ($supplicantPath.".orig", $supplicantPath) or $msg = "Copy #2 failed: $!";
}

open(my $fh, '>>', $supplicantPath) or $msg = "Could not open file '$supplicantPath' $!";

print $fh "

network={
  ssid=\"$queries{essid}\"
  psk=\"$queries{password}\"
  scan_ssid=1
}
";

close $fh;

if ($msg eq "") {
	$msg = "Details have been stored and Guard Dog will try to connect. Go to $queries{essid} network and type http://guarddog-dev:9000 in your browser. If you do not see Guard Dog web page then connect back to the GuardDog network and re-enter password";
}

print "{ \"msg\" : \"$msg\" }\n";
