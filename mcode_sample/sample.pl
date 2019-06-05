use Mcode;

my $mcode_dir = '/usr/local/lib/mobalog/data/dat/mcode';
my $mcode = new Mcode($mcode_dir);

my $src = <<EOF;
<html>
  <body>
    <h1>Hello, mcode!</h1>
  </body>
</html>
EOF

print "----\n";
print "$src\n";

$src = $mcode->any2u($src);
print "---- any2u\n";
print "$src\n";

$mcode->u2any($src, 'D');

print "---- u2any\n";
print "$src\n";
