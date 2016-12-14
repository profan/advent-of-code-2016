#!/usr/bin/env perl6

sub calculate-distance($data) {

	# N, E, S, W
	my @dirs = [%(x => 0, y => -1), %(x => 1, y => 0), %(x => 0, y => 1), %(x => -1, y => 0)];
	my %state = pos => %(x => 0, y => 0), dir => 0;

	my %visited;
	my $first-visited = False;

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
					if not %state<pos> ~~ %visited {
						%visited{%state<pos>} = 1;
					} elsif not $first-visited {
						$first-visited = %(x => %state<pos><x>, y => %state<pos><y>);
					}
				}
			}
		}
	}

	# return final position, distance in blocks, first place visited twice
	my $first-blocks-away = do if $first-visited {
		abs $first-visited<x> + abs $first-visited<y>;
	} else {
		0;
	}

	return %state<pos>, (abs %state<pos><x> + abs %state<pos><y>), $first-visited, $first-blocks-away;

}

my $data = slurp "1.input";
my ($final-pos, $final-blocks, $first-visited, $first-blocks) = calculate-distance($data);
say "final position, x: $final-pos<x> y: $final-pos<y>";
say "final distance: $final-blocks blocks";

if $first-visited {
	my ($f-x, $f-y) = $first-visited<x y>;
	say "first place visited twice - x: $f-x y: $f-y, blocks away: $first-blocks";
}
