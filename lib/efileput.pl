#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use File::Copy 'copy';
use autodie;

=head1 NAME

efileput.pl - put in any number of files

=head1 SYNOPSIS

efileput.pl [Number] [dir]

=head1 DESCRIPTION

Put The File

=cut

my %opts = ( number => 200 , dir => "." );
GetOptions(\%opts,qw(number=i dir=s));
my $number = $opts{'number'};
my $dir = $opts{'dir'};

# get the all file
my @all_file = glob("$dir/*.cmd");
my @files = ();

# normal file
foreach my $file( @all_file ) {
  push( @files , $file ) if( -f $file );
}

my $list = [{}];
pop @$list;

foreach my $file( @files ) {
  open my $fh , '<' , $file;
  while( my $line = <$fh> ) {
    my @content = split(/\s+/ , $line );
    push( @$list , { 'a' => $content[1] , 'b' => $content[2] , 'c' => $content[3] } );
  }
}

my $dircount = 1;
my $filelist = [{}];
pop @$filelist;

my $max = @$list;
my $now = 0;

for my $i( 0 .. @$list -1 ) {

 push( @$filelist , { 'a' => $list->[$i]->{'a'} , 'b' => $list->[$i]->{'b'} , 'c' => $list->[$i]->{'c'} } );

  if( @$filelist >= $number ) {

      &copyfile( "./DATA$dircount", $filelist );
      $dircount++;

      $now += @$filelist;
      &progress( $now , $max , $number , $dircount );

      $filelist = [{}];
      pop @$filelist;
  }

}

# default less than
if( @$filelist > 0 ) {
   &copyfile( "./DATA$dircount", $filelist );

   $now += @$filelist;
   &progress( $now , $max , $number , $dircount );
}

print "\n";

# file copy and list file
sub copyfile {

  my ( $dir , $filelist ) = @_;
  my $newfile = "$dir/list";

  mkdir("$dir");

  open my $fh , '>' , $newfile;

  my @command = ();
  for my $i( 0 .. @$filelist-1 ) {
    copy $filelist->[$i]->{'a'} , $dir;
    copy $filelist->[$i]->{'b'} , $dir;
    copy $filelist->[$i]->{'c'} , $dir;
    push( @command , "$filelist->[$i]->{'a'} $filelist->[$i]->{'b'} $filelist->[$i]->{'c'}\n");
  }

  print $fh @command;

  close $fh;

}

# display progress
sub progress {

  my ( $now , $max , $number , $dircount ) = @_;

  sleep 0.8;

  my $prog = $now * 100 / $max;
  local $| = 1;
  printf (" %3.0f%s" , $prog , '%:' );
  my $i = $dircount * ( 20 / ( $max / $number ) ) ;
  print "#" x $i;
  print "\r";
  local $| = 0;

}
