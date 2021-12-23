#!/usr/bin/env perl
#
# process the html
# run pandoc
# process the results of pandoc

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
  process_file( $file );
}

exit 0;

sub process_file {
  my @params = @_;
  my $pfile = $params[0];
  my $hfile = $pfile.".html";
  my $tfile = $pfile.".tmp";
  my $mfile = $pfile.".md";
  my $line;
  my $newline;
  my $iter = -1;
  my $ignore_header = 1;
  my $ignore_footer = 0;
  my $skip_line;
  open(PIN, "< $pfile") or die "Couldn't open $pfile";
  open(POUT, "> $hfile") or die "Couldn't open $hfile";
  while ( $line=<PIN> ) {
    chop $line;
    ++$iter;
    $skip_line = 1;
    if( $line =~ "wiki wiki-page" ) {
       #print "found wiki-page at line $iter\n";
       $ignore_header = 0;
    } 
    if( $line =~ "collapsible collapsed hide-when-print" ) {
       #print "found collapsible at line $iter\n";
       $ignore_footer = 1;
    } 
    $newline = $line;
    if( $line =~ "Edit this section" ) {
       #print "ignore $line\n";
       $skip_line=0;
    }
    if( $line =~ "email" ) {
      my $p1 = index($line, '<a class="email"');
      my $p2 = index($line, '</a>', $p1);
      my $nl1 = substr $line, 0, $p1;
      my $nl2 = substr $line, $p2+4;
      $newline = $nl1.$nl2;
      $newline =~ s/\&lt\;\&gt\;//;
    }
    if (!$ignore_header && !$ignore_footer && $skip_line) {
       #print "will process line $iter $newline\n";
       print POUT "$newline\n";
    }
  }
  close(PIN);
  close(POUT);
  my $cmd = "pandoc --no-wrap --smart -f html -t markdown -s \"".$hfile."\" -o \"".$tfile."\"";
  print "run $cmd\n";
  if ( system($cmd) != 0 ) {
     print "ERROR running $cmd\n";
     exit 1;
  }
  open(PIN, "< $tfile") or die "Couldn't open $tfile";
  open(POUT, "> $mfile") or die "Couldn't open $mfile";
  while ( $line=<PIN> ) {
    chop $line;
# (https://cdcvs.fnal.gov/redmine/projects/larsoft/wiki)
    $line =~ s/https\:\/\/cdcvs\.fnal\.gov\/redmine\/projects\/larsoft\/wiki\///g;
    $line =~ s/\/redmine\/projects\/larsoft\/wiki\///g;
    $line =~ s/Working_with_Github/Working_with_GitHub/g;
    $newline = $line;
    if( $line =~ '[¶]' ) {
      my $p3 = index($line,'[¶]');
      $newline = substr $line, 0, $p3;
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

