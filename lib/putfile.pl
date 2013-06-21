#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use File::Copy 'copy';
use autodie;

=head1 NAME

fileput.pl - put in any number of files

=head1 SYNOPSIS

fileput.pl [Number]

=head1 DESCRIPTION

Put The File

=cut

my %opts = ( number => 200 );
GetOptions(\%opts,qw(number=i));
my $number = $opts{'number'};

# get the file name of the current
my @all_file = glob("*");
my @files = ();

# normal file
foreach my $file( @all_file ) {
  push( @files , $file ) if( -f $file );
}

my $dircount = 1;
my @filelist = ();

foreach my $file( @files ) {

  push( @filelist , $file );

  if( @filelist >= $number ) {
      &copyfile( "./DATA$dircount", @filelist );
      $dircount++;
      @filelist = ();
  }

}

# default less than
if( @filelist > 0 ) {
   &copyfile( "./DATA$dircount", @filelist );
}

# copy and filelist
sub copyfile {

  my ( $dir , @filelist ) = @_;
  my $newfile = "$dir/list";

  mkdir("$dir");
  open my $fh , '>' , $newfile;

  my @command = ();
  foreach my $file ( @filelist ) {
    copy $file , $dir;
    push( @command , "$file\n");
  }

  print $fh @command;
  close $fh;

}

