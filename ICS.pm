package ICS;

our %obj_index = {};
our @array_vars = (
    'VEVENT',
    'TODO',
    'ATTACH',
    'ATTENDEE',
    'CATEGORIES',
    'COMMENT',
    'CONTACT',
    'EXDATE',
    'EXRULE',
    'FREEBUSY',
    'RDATE',
    'RELATED',
    'RESOURCES',
    'RRULE',
    'RSTATUS'
);

sub new() {
    my $self = {};
    return bless $self;
}

sub nest_create {
    my ($ref, $key, @nesting, $index) = @_;
    if ((scalar @nesting) == 0) {
        if (grep(/$key/, @array_vars)) {
            $ref->{$key}->[$obj_index{$key}] = {};
        } else {
            $ref->{$key} = {};
        }
    } else {
        my $shift = shift @nesting;
        if (grep(/$shift/,@array_vars)) {
            $ref = $ref->{$shift}->[$obj_index{$shift}];
        } else {
            $ref = $ref->{$shift};
        }
        nest_create($ref, $key, @nesting);
    }
}

sub nest_assign {
    my ($ref, $key, $value, @nesting) = @_;
    if ((scalar @nesting) == 0) {
        if (defined $ref->{$key}) {
            $ref->{$key} .= $value;
        } else {
            $ref->{$key} = $value;
        }
    } else {
        my $shift = shift @nesting;
        if (grep(/$shift/,@array_vars)) {
            $ref = $ref->{$shift}->[$obj_index{$shift}];
        } else {
            $ref = $ref->{$shift};
        }
        nest_assign($ref, $key, $value, @nesting);
    }
}

sub decode {
    my $self = shift;
    my $raw = shift;

    my @rows = split('\r?\n',$raw);

    my @nest;
    my %hash;
    my $last_var;
    my $last_object;
    foreach my $row (@rows) {
        my $current = \%hash;
        my ($var, $val);
        $row =~ s/\\//g;
        if ($row =~ m/^BEGIN:/) {
            my $object = $row;
            $object =~ s/^BEGIN:(.*)$/$1/;
            if (grep(/$object/,@array_vars)) {
                if (!defined $obj_index{$object} || ($object ne $last_object)) {
                    $obj_index{$object} = 0;
                } elsif ($object eq $last_object) {
                    $obj_index{$object}++;
                }
            }
            nest_create($current,$object,@nest);
            push @nest, $object;
            next;
        } elsif ($row =~ m/^END:/) {
            my $object = pop @nest;
            $last_object = $object;
            next;
        } elsif ($row =~ m/^ /) {
            $row =~ s/^ //;
            nest_assign($current,$last_var,$row,@nest);
        } else {
            $var = $val = $row;
            $var =~ s/^([^:]*):.*$/$1/;
            $val =~ s/^[^:]*:(.*)$/$1/;
            nest_assign($current,$var,$val,@nest);
            $last_var = $var;
        }
    }
    return \%hash;
}

1
