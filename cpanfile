requires 'Function::Parameters';
requires 'Function::Return';
requires 'Math::Trig';
requires 'Moo';
requires 'Moo::Role';
requires 'Type::Utils';
requires 'Types::Standard';
requires 'experimental';
requires 'perl', 'v5.28.0';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};
