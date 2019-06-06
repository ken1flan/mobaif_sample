my $src = "a";
my $pk = pack('L', 4 + 0x10000 * 2 + length($src));
my $pk_hex = unpack('H*', $pk);

print "$src\n";
print "$pk_hex\n";
