package In::Korean::Numbers::SinoKorean;

use POSIX;

# Map Hangul to integer
my %numbers = (
  1 => '일',
  2 => '이',
  3 => '삼',
  4 => '사',
  5 => '오',
  6 => '육',
  7 => '칠',
  8 => '팔',
  9 => '구',
  10 => '십',
  100 => '백',
  1000 => '천',
  10000 => '만',
);

# Numbers expressed in combination of the following units
my @units = (10000, 1000, 100, 10, 1);

# - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub new {
  my $class = shift;
  return bless {}, $class;
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub getHangul {

  my( $self, $num );

  if ( @_ == 2 ) {
    ( $self, $num ) = @_; 
  } elsif ( @_ == 1 ) {
    ( $num ) = @_;
  } else {
    return undef;
  }
  
  my @hangul = ();

  my $remaining = $num;

  foreach my $unit ( @units ) {

    last if $remaining == 0; # Performance reasons only

    # Find the mutiple for the current unit.
    # E.g., 502,217 for key=10,000, then multiple = 52
    my $multiple = floor( $remaining / $unit );

    next if $multiple < 1;

    $remaining %= $unit;

    # Recursively call to get value greater than 10
    my $multiple_str = $multiple >= 10 ? getHangul( $self, $multiple ) : $numbers{ $multiple };

    # Don't push Hangul value for 1 unless currently handling 1 unit
    push @hangul, $multiple_str unless $multiple == 1 && $unit != 1;
    push @hangul, $numbers{ $unit } if $unit != 1;
  }

  return join( '', @hangul ) if @hangul;

  return '공';
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub getInt {

}

1;
