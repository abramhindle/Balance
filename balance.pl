#    A Scale Based musical instrument
#    Copyright (C) 2011 Abram Hindle
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
use Time::HiRes qw(sleep);
use strict;

# my @a = map { 0 } (1..100);
# my @b = map { 0 } (1..10);

my $maxentropy = 0;
my $maxentropy10 = 0;
my $N = 100;
my @scale = ();  # scale records

while(1) {
	my @lines = `usbscale/usbscale 2> /dev/null`;
	chomp( @lines );
	my @values = ();
	foreach my $line ( @lines ) {
		my ($id,$val,$unit) = split(/: /, $line);
		warn "SCALE: $id $val $unit";
		if (!$scale[ $id ]) {
			$scale[ $id ] = [ map { 0 } (1..$N) ];
		}
		shift @{$scale[$id]};
		push @{$scale[$id]}, $val;
		push @values, $val;
	}
	my $entropy = balance_entropy( @values );
	my @entropies = map { my @a = @$_; entropy( @a ); } @scale;
	my @ve = zip( \@values, \@entropies );

	my $str = sprintf("i666 0.0001 1 %0.03f ".(" %0.03f "x(scalar(@ve))).$/, 
				$entropy, @ve);

	warn $str;
	print $str;
	sleep( 0.25 );
}
sub balance_entropy {
	my @weights = @_;
	my $sum = 0;
	foreach my $w (@weights) {
		$sum += $w;
	}
	my $ent = 0;
	foreach my $w (@weights) {
		my $wn = ($sum==0.0)?0.0:((1.0 * $w) / $sum);
		$ent += ($wn == 0.0)?0.0:($wn * log($wn)/log(2));
	}
	return -1 * $ent;

}
sub entropy {
	my %h = ();
	my $n = @_;
	foreach my $v (@_) {
		$h{$v}++;
	}
	my $sum = 0;
	while(my ($key,$val) = each %h) {
		my $vn = (1.0 * $val) / $n;
		$sum += $vn * (log($vn)/log(2));
	}
	return -1* $sum;
}
sub zip {
	my ($a, $b) = @_;
	my @o = ();
	while (@$a || @$b) {
		if (@$a) {
			push @o, (shift @$a);
		}
		if (@$b) {
			push @o, (shift @$b);
		}
	}
	return @o;
}
