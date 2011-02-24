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
my @a = map { 0 } (1..100);
my @b = map { 0 } (1..10);
my $maxentropy = 0;
my $maxentropy10 = 0;
while(1) {
	my $line = `usbscale/usbscale 2> /dev/null`;
	chomp($line);
	my ($id,$val,$unit) = split(/: /, $line);
	warn "$id $val $unit";
	shift @a;
	push @a, $val;
	shift @b;
	push @b, $val;
	my $entropy = entropy( @a );
	my $entropy10 = entropy( @b );
	$maxentropy = ($entropy > $maxentropy)?$entropy:$maxentropy;
	$maxentropy10 = ($entropy10 > $maxentropy10)?$entropy10:$maxentropy10;
	my $str = sprintf("i1 0.0001 2  1000 %0.03f %0.03f %0.03f %0.03f %0.03f$/",  $val*100, $entropy, $maxentropy, $entropy10, $maxentropy10);
	warn $str;
	print $str;
	sleep( 0.5 );
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
