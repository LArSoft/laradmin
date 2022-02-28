#!/usr/bin/env perl
#
# process textile
# run pandoc
#    ~/bin/pandoc --wrap=none -f textile -t gfm -s ${in_file} -o ${out_file}  || exit 1
# process the results of pandoc
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
  # need recent pandoc built by spack
  my $tfile = $file.".tmp";
  my $pdfile = $file.".pd";
  my $cmd = "~/bin/pandoc --wrap=none -f textile -t gfm -s \"".$tfile."\" -o \"".$pdfile."\"";
  #print "run $cmd\n";
  if ( system($cmd) != 0 ) {
     print "ERROR running $cmd\n";
     exit 1;
  }
  process_tmp( $file );
}

exit 0;

sub process_tmp {
  my @params = @_;
  my $pfile = $params[0];
  my $orgfile = $pfile.".textile";
  my $tfile = $pfile.".tmp";
  my $pdfile = $pfile.".pd";
  my $mfile = $pfile.".md";
  my $line;
  my $newline;
  my $p1;
  my $p2;
  my $p22;
  my $p3;
  my $pc;
  my $nl1;
  my $nl2;
  my $nl3;
  my $nl4;
  open(PIN, "< $pdfile") or die "Couldn't open $pdfile";
  open(POUT, "> $mfile") or die "Couldn't open $mfile";
  while ( $line=<PIN> ) {
    chop $line;
    $line =~ s/\\_/_/g;
    $newline = $line;
    if( $line =~ m/\Q\[\[/ ) {
      #print "fix $line\n";
      $p1 = index($line, '\[\[');
      $p2 = index($line, '\|', $p1);
      $p22 = index($line, '|', $p1);
      $p3 = index($line, '\]\]', $p1);
      #print "found $p1 - $p2 - $p22 - $p3\n";
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
      } elsif (( $p22 > $p1 ) && ( $p22 < $p3 )) {
        #print " special case for $line\n";
        $nl1 = substr $line, 0, $p1;
        $nl2 = substr $line, $p1+4, $p22-$p1-4;
        $nl3 = substr $line, $p22+1, $p3-$p22-1;
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
        #print "nl1: $nl1---\n";
        #print "nl2: $nl2---\n";
        #print "nl3: $nl3---\n";
        #print "nl4: $nl4---\n";
        $newline = $nl1."[".$nl3."](".$nl2.")".$nl4;
        #print "$newline\n";
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
    if( $line =~ '":https' ) {
      #print "deal with: $line\n";
      # there may be more than one occurance of the pattern
      my $remnant = $line;
      my $working_line = "";
      while( $remnant =~ '":https' ) {
        $p1 = index($remnant, '"');
        $p2 = index($remnant, '":https');
        $p3 = index($remnant, " ", $p2);
        if ($p1 <= $p2 ) {
          $nl1 = substr $remnant, 0, $p1;
          # strip out the quotes when we get nl2
          $nl2 = substr $remnant, $p1+1, $p2-$p1-1;
          $nl3 = substr $remnant, $p2+2, $p3-$p2-2;
          $nl4 = substr $remnant, $p3;
          #print "nl1: $nl1\n";
          #print "nl2: $nl2\n";
          #print "nl3: $nl3\n";
          #print "nl4: $nl4\n";
          #$newline = $nl1."[".$nl2."](".$nl3.")".$nl4;
          $working_line = $working_line.$nl1."[".$nl2."](".$nl3.")";
          $remnant = $nl4;
          #print "working line: $working_line\n";
          #print "remnant: $remnant\n";
        } else {
          print "STUMPED by $remnant\n";
          exit 1
        }
      }
      #print "ending with $working_line\n";
      #print "       and $remnant\n";
      $newline = $working_line.$remnant;
    }
    if( $newline =~ '\!\[\]\(' ) {
      #print "found image line $line\n";
      $p1 = index($newline, ')');
      $nl1 = substr $newline, 4, $p1-4;
      #print "keep: $nl1\n";
      if ( $nl1 =~ "http" ) {
        $newline = $line;
      } else { 
        $newline = "![".$nl1."](/assets/img/larsoft/".$nl1.")";
      }
      #print "newline $newline\n";
    }
    if( $newline =~ m/\Q\> \*/ ) {
      ##print "fix $newline\n";
      $newline =~ s%\Q\> \*%> -%g;
      #print "fixed $newline\n";
    }
    if( $newline =~ m/\Q\> / ) {
      $newline =~ s%^\s*\\> %> %g;
    }
    if( $newline =~ m/\Q\>/ ) {
      $newline =~ s%^\s*\\>%>%g;
    }
    print POUT "$newline\n";
  }
  print "finished with $pfile\n";
  return;
}

sub process_textile {
  my @params = @_;
  my $pfile = $params[0];
  my $orgfile = $pfile.".textile";
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
  my $templine;
  my $code_block = 0;
  open(PIN, "< $orgfile") or die "Couldn't open $orgfile";
  open(POUT, "> $tfile") or die "Couldn't open $tfile";
  while ( $line=<PIN> ) {
    chop $line;
    $newline = $line;
    if( $line =~ "p{border: 1px solid black;}." ) {
       #print "found border: $line\n";
       print POUT "<pre><code class=\"sh\">\n";
       $newline =~ s%p{border: 1px solid black;}.%%;
       #print "newline: $newline\n";
       $code_block = 1;
    } 
    if ( $code_block ) {
       #print "looking for end of code block: $line\n";
       if ($newline =~ /^\s*$/) {
         $code_block = 0;
         #print "ending code block at $newline\n";
         print POUT "</code></pre>\n";
       } else {
         # removing formatting that does not translate
         $newline =~ s%@%%g;
         $newline =~ s%\*%%g;
         #print "code block line: $newline\n";
       }
    }
    # put all code block delmeters on a separate line
    if ( $line =~ "<pre><code" ) {
      #print "break apart $line\n";
      $p1 = index($line, '<pre>');
      $p2 = index($line, '">', $p1);
      #print "found $p1 - $p2\n";
      $nl1 = substr $line, 0, $p1;
      $nl2 = substr $line, $p1, $p2-$p1+2;
      #print "first line: $nl1\n";
      #print "second line: $nl2\n";
      if ($nl1 =~ /^\s*$/) {
      } else { print POUT "$nl1\n"; }
      print POUT "$nl2\n";
      if ( $line =~ "</code></pre>" ) {
        $p3 = index($line, '</code></pre>');
        if ( $p3 < $p1 ) { print "OOPS\n"; exit 1; }
        #print "found $p1 - $p2 - $p3\n";
        $nl3 = substr $line, $p2+2, $p3-$p2-2;
        $nl4 = substr $line, $p3+13;
        #print "part 3: $nl3\n";
        #print "finish: $nl4\n";
        print POUT "$nl3\n";
        if ($nl4 =~ /^\s*$/) {
          $newline = "</code></pre>";
        } else {
          print POUT "</code></pre>\n";
          $newline = $nl4;
        }
      } else {
        $nl3 = substr $line, $p2+2;
        #print "finish: $nl3\n";
        $newline = $nl3;
      }
    } elsif ( $line =~ "</code></pre>" ) {
      #print "break apart $line\n";
      $p1 = index($line, '</code></pre>');
      $nl1 = substr $line, 0, $p1;
      $nl2 = substr $line, $p1+13;
      #print "first line: $nl1\n";
      #print "finish $nl2\n";
      if ($nl1 =~ /^\s*$/) {
      } else { print POUT "$nl1\n"; }
      if ($nl2 =~ /^\s*$/) {
        $newline = "</code></pre>";
      } else {
        print POUT "</code></pre>\n";
        $newline = $nl2;
      }
    }
    print POUT "$newline\n";
  }
  close(PIN);
  close(POUT);
}

sub print_usage {
    print "Usage: $thisfile <file list>\n";
    print "Usage: $thisfile -h\n";
    print "  Options:\n";
    print "      -h : this printout\n";
}

