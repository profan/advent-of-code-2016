#!/usr/bin/env perl6

my $data = slurp "1.input";

# N, E, S, W
my @dirs = [%(x => 0, y => -1), %(x => 1, y => 0), %(x => 0, y => 1), %(x => -1, y => 0)];
my %state = pos => %(x => 0, y => 0), dir => 0;
my %visited;

for $data.trans(" " => "").split(",") -> $data {
	given $data {
		when /$<d> = [L|R] $<n> = [\d+]/ {
			given $<d> {
				when "L" {
					%state<dir> = (%state<dir> - 1) % @dirs.elems
				}
				when "R" {
					%state<dir> = (%state<dir> + 1) % @dirs.elems
				}
			}
			for 1..$<n>.Int {
				%state<pos><x> += @dirs[%state<dir>]<x>;
				%state<pos><y> += @dirs[%state<dir>]<y>;
			}
		}
	}
}

my $blocks = abs %state<pos><x> + abs %state<pos><y>;
say "final position, x: %state<pos><x> y: %state<pos><y>";
say "final distance: $blocks blocks";
