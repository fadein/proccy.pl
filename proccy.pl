#!/usr/bin/perl


# A cheap and sleazy version of ps
use Proc::ProcessTable;

my $FORMAT = "%-6s %-10s %-8s %-24s %s\n";

while (1) {
	my $t = Proc::ProcessTable->new();
	printf($FORMAT, "PID", "TTY", "STAT", "START", "COMMAND"); 
	foreach my $p ( @{$t->table} ){
		printf($FORMAT, 
			$p->pid, 
			$p->ttydev, 
			$p->state, 
			scalar(localtime($p->start)), 
			$p->cmndline);
	}
	sleep 1;
}

