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
      print "fix $line\n";
      $p1 = index($line, '\[\[');
      $p2 = index($line, '\|', $p1);
      $p3 = index($line, '\]\]', $p1);
      print "found $p1 - $p2 - $p3\n";
      if ( $p2 > $p1 ) {
        $nl1 = substr $line, 0, $p1;
        $nl2 = substr $line, $p1+4, $p2-$p1-4;
        $nl3 = substr $line, $p2+2, $p3-$p2-2;
        $nl4 = substr $line, $p3+4;
        $pc = index($nl2, ':');
        print "found $pc in $nl2\n";
        if ( $pc > 0 ) {
          my $nl21 = substr $nl2, 0, $pc;
          my $nl22 = substr $nl2, $pc+1;
          print "nl2 splits into %$nl21%$nl22%\n";
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
        print "found $pc in $nl2\n";
        if ( $pc > 0 ) {
          my $nl21 = substr $nl2, 0, $pc;
          my $nl22 = substr $nl2, $pc+1;
          print "nl2 splits into %$nl21%$nl22%\n";
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
  my $ignore_toc = 0;
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
    if( $line =~ '<ul class="toc' ) {
      #print "found TOC: $line\n";
       $ignore_toc = 1;
       $skip_line=0;
    }
    if( $ignore_toc == 1 ) {
      #print "should we skip $line\n";
      if ( $line =~ /^\s*$/) { 
        $ignore_toc = 0;
      } else { 
        $skip_line=0;
      }
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
    if( $line =~ "issue tracker" ) {
      my $p1 = index($line, '<a class="issue');
      my $p2 = index($line, 'class', $p1);
      my $p3 = index($line, 'href', $p1);
      my $nl1 = substr $line, 0, $p2;
      my $nl2 = substr $line, $p3;
      $newline = $nl1.$nl2;
    }
    # remove leading whitespace
    $newline =~ s/^\s+//;
    if (!$ignore_header && !$ignore_footer && $skip_line) {
       #print "will process line $iter $newline\n";
       print POUT "$newline\n";
    }
  }
  close(PIN);
  close(POUT);
  # need pandoc 2.14 as built by spack
  my $cmd = "pandoc --no-wrap --smart -f html -t markdown_github -s \"".$hfile."\" -o \"".$tfile."\"";
  print "run $cmd\n";
  if ( system($cmd) != 0 ) {
     print "ERROR running $cmd\n";
     exit 1;
  }
  open(PIN, "< $tfile") or die "Couldn't open $tfile";
  open(POUT, "> $mfile") or die "Couldn't open $mfile";
  while ( $line=<PIN> ) {
    chop $line;
    # the larsoft wiki
    $line =~ s/https\:\/\/cdcvs\.fnal\.gov\/redmine\/projects\/larsoft\/wiki\///g;
    $line =~ s/\/redmine\/projects\/larsoft\/wiki\///g;
    # other redmine projects
    if( $line =~ 'redmine/projects' ) {
      if( $line =~ 'https://cdcvs.fnal.gov/redmine/projects' ) {
         #skip
      } else {
    $line =~ s/\/redmine\/projects/https\:\/\/cdcvs\.fnal\.gov\/redmine\/projects/g;
      }
    }
    # redmine issues
    $line =~ s/\/redmine\/issues/https\:\/\/cdcvs\.fnal\.gov\/redmine\/issues/g;
    $line =~ s/\[\\\#/\[redmine issue /g;
    $line =~ s/Working_with_github/Working_with_GitHub/g;
    $line =~ s/\\_/_/g;
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

