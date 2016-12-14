#!/usr/bin/env perl6

sub calculate-distance($data) {

	# N, E, S, W
	my @dirs = [%(x => 0, y => -1), %(x => 1, y => 0), %(x => 0, y => 1), %(x => -1, y => 0)];
	my %state = pos => %(x => 0, y => 0), dir => 0;

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

	# return final position, distance in blocks
	return %state<pos>, abs %state<pos><x> + abs %state<pos><y>;

}

my $data = slurp "1.input";
my ($final-pos, $blocks) = calculate-distance($data);
say "final position, x: $final-pos<x> y: $final-pos<y>";
say "final distance: $blocks blocks";
