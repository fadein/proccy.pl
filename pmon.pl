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

sub logger {
	print @_;
	open my $l, '|logger' or return;
	print $l @_;
	close $l;
}

%prev = ptabHash(); @prevPID = sort { $a <=> $b} keys %prev;
#print Dumper(\%prev), "\n"; exit;

sleep SLEEPYTIME;
while (1) {

	%curr = ptabHash(); @currPID = sort { $a <=> $b} keys %curr;

	my @diff = sdiff(\@prevPID, \@currPID);

	foreach my $p ( grep { $_->[0] eq '+' } @diff ) {
		my $c = $curr{$p->[2]};
		my $cmdl = $c->cmndline;
		my $when = scalar localtime $c->start;
		my $exec = $c->exec;
		my $pid  = $c->pid;
		my $f = $c->fname;
		$cmdl =~ s/^$f//;
		logger( sprintf "[%s] <%5d> '%s'\n", $when, $pid, $exec . $cmdl);
	}

	%prev = %curr; @prevPID = @currPID;
	sleep SLEEPYTIME;
}
