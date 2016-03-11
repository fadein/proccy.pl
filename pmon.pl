#!/usr/bin/perl
use Proc::ProcessTable;
use Algorithm::Diff qw(sdiff diff compact_diff);
use strict; use warnings;
use Data::Dumper;

use constant SLEEPYTIME => 1;
my (@prevPID, @currPID);
my (%prev, %curr);

sub ptabHash {
	my $t = Proc::ProcessTable->new();
	my %h = map { $_->pid => $_ } @{ $t->table };
	return %h;
}



%prev = ptabHash(); @prevPID = sort { $a <=> $b} keys %prev;
#print Dumper(\%prev), "\n"; exit;


sleep SLEEPYTIME;
while (1) {

	%curr = ptabHash(); @currPID = sort { $a <=> $b} keys %curr;
	print "currPID = (@currPID)\n";
	print "prevPID = (@prevPID)\n";

	my @diff = sdiff(\@prevPID, \@currPID);

	map { print "Process $curr{$_->[0]}->cmdline has appeared\n" }
		grep { $_->[0] eq "+" } @diff;

	%prev = %curr; @prevPID = @currPID;
	print "\n";
	sleep SLEEPYTIME;
}
