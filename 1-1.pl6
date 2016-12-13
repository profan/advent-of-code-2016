#!/usr/bin/env perl6

my $data = slurp "1.input";

sub wrap($v, $min, $max) {
	if $v > $max {
		return $min;
	} elsif $v < $min {
		return $max;
	} else {
		return $v;
	}
}

# N, E, S, W
my @dirs = [%(x => 0, y => -1), %(x => 1, y => 0), %(x => 0, y => 1), %(x => -1, y => 0)];
my %state = pos => %(x => 0, y => 0), dir => 0;

for $data.trans(" " => "").split(",") -> $data {
	given $data {
		when /$<d> = [L|R] $<n> = [\d+]/ {
			given $<d>.Str {
				when "L" {
					%state<dir> = wrap(%state<dir> - 1, 0, 3);
				}
				when "R" {
					%state<dir> = wrap(%state<dir> + 1, 0, 3);
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
say "final position, x: {%state<pos><x>} y: {%state<pos><y>}";
say "final distance: $blocks";
