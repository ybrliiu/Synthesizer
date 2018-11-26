package Synthesizer::Frequency {

  use Moo;
  use utf8;
  use Types::Standard qw( :types );
  use Function::Parameters qw( method );

  use overload (
    '0+'     => 'as_num',
    fallback => 1,
  );

  has value => (
    is       => 'ro',
    isa      => Num,
    required => 1,
  );

  method as_num(@) {
    $self->value;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

周波数クラス
