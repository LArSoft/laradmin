#!/usr/bin/env perl
#
# process output of pandoc as run on textile files
#

use strict;
use warnings;

use File::Basename;

use lib dirname($0);

my $thisfile = basename($0);

if( $#ARGV < 0 ) {
    print_usage();
    exit 1;
}

my @filelist = ();
my $iter = -1;
while ( $iter < $#ARGV ) {
  ++$iter;
  if ( $ARGV[$iter] eq "-h" ) { 
    print_usage();
    exit 0;
  } else { 
    push (@filelist, ( $ARGV[$iter] ));
  }
}

foreach my $file (@filelist) {
  print "$thisfile: reading $file\n";
  process_textile( $file );
}

exit 0;

sub process_textile {
  my @params = @_;
  my $pfile = $params[0];
  my $tfile = $pfile.".tmp";
  my $mfile = $pfile.".md";
  my $line;
  my $newline;
  my $p1;
  my $p2;
  my $p3;
  my $pc;
  my $nl1;
  my $nl2;
  my $nl3;
  my $nl4;
  open(PIN, "< $tfile") or die "Couldn't open $tfile";
  open(POUT, "> $mfile") or die "Couldn't open $mfile";
  while ( $line=<PIN> ) {
    chop $line;
    $line =~ s/\\_/_/g;
    $newline = $line;
    if( $line =~ m/\Q\[\[/ ) {
      #print "fix $line\n";
      $p1 = index($line, '\[\[');
      $p2 = index($line, '\|', $p1);
      $p3 = index($line, '\]\]', $p1);
      #print "found $p1 - $p2 - $p3\n";
      if ( $p2 > $p1 ) {
        $nl1 = substr $line, 0, $p1;
        $nl2 = substr $line, $p1+4, $p2-$p1-4;
        $nl3 = substr $line, $p2+2, $p3-$p2-2;
        $nl4 = substr $line, $p3+4;
        $pc = index($nl2, ':');
        #print "found $pc in $nl2\n";
        if ( $pc > 0 ) {
          my $nl21 = substr $nl2, 0, $pc;
          my $nl22 = substr $nl2, $pc+1;
          #print "nl2 splits into %$nl21%$nl22%\n";
          $nl2 = "https://cdcvs.fnal.gov/redmine/projects/".$nl21."/wiki/".$nl22
        }
        #print " $nl1\n";
        #print " $nl2\n";
        #print " $nl3\n";
        #print " $nl4\n";
        $newline = $nl1."[".$nl3."](".$nl2.")".$nl4;
      } else {
        $nl1 = substr $line, 0, $p1;
        $nl3 = substr $line, $p1+4, $p3-$p1-4;
        $nl4 = substr $line, $p3+4;
        $nl2 = $nl3;
        $nl2 =~ s% %_%g;
        $pc = index($nl2, ':');
        #print "found $pc in $nl2\n";
        if ( $pc > 0 ) {
          my $nl21 = substr $nl2, 0, $pc;
          my $nl22 = substr $nl2, $pc+1;
          #print "nl2 splits into %$nl21%$nl22%\n";
          $nl2 = "https://cdcvs.fnal.gov/redmine/projects/".$nl21."/wiki/".$nl22
        }
        #print " $nl1\n";
        #print " $nl2\n";
        #print " $nl3\n";
        #print " $nl4\n";
        $newline = $nl1."[".$nl3."](".$nl2.")".$nl4;
        #$newline =~ s%\Q\[\[%(%g;
        #$newline =~ s%\Q\]\]%)%g;
      }
      #print "$newline\n";
    }
    print POUT "$newline\n";
  }
  print "finished with $pfile\n";
  return;
}

sub print_usage {
    print "Usage: $thisfile <file list>\n";
    print "Usage: $thisfile -h\n";
    print "  Options:\n";
    print "      -h : this printout\n";
}

