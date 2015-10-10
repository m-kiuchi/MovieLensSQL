#!/usr/bin/perl
use strict;
use utf8;

open(FH, "<", "users.dat") or die("users.dat open error");
open(FHW, ">>", "users.json") or dir("users.json write error");
while(my $line = <FH>){
  chomp($line);
  my @ar = split(":", $line);
  my $out = "{ \"UID\": $ar[0], \"GENDER\": \"$ar[2]\", \"SubID\": \"$ar[8]\" }";
  print FHW "$out\n";
}
close(FHW);
close(FH);

open(FH, "<", "movies.dat") or die("movies.dat open error");
open(FHW, ">>", "movies.json") or dir("movies.json write error");
while(my $line = <FH>){
  chomp($line);
  my @ar = split(":", $line);
  $ar[2] =~ s/['|"]/-/g;
  my $out = "{ \"MOVIE\": $ar[0], \"TITLE\": \"$ar[2]\", \"GENRE\": \"$ar[4]\" }";
  print FHW "$out\n";
}
close(FHW);
close(FH);

open(FH, "<", "ratings.dat") or die("movies.dat open error");
open(FHW, ">>", "ratings.json") or dir("movies.json write error");
while(my $line = <FH>){
  chomp($line);
  my @ar = split(":", $line);
  my $out = "{ \"UID\": $ar[0], \"MOVIE\": $ar[2], \"RATE\": $ar[4] }";
  print FHW "$out\n";
}
close(FHW);
close(FH);
