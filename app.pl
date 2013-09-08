use Mojolicious::Lite;
use DBI;
use Data::Dumper;

my $dbh = DBI->connect("dbi:SQLite:dbname=perlcasts.db", "", "");

get '/' => sub {
    my $self = shift;
    my @videos = @{$dbh->selectall_arrayref("select id, youtube_id, title from perlcasts")};
    $self->render('index', videos => \@videos);
};

get '/:id' => sub {
    my $self = shift;
    my $id = $self->param('id');
    my ($title, $desc, $yt_id) = $dbh->selectrow_array(
        "select title, description, youtube_id from perlcasts where id = ?", {}, $id);
    $self->render('video', title => $title, description => $desc, yt_id => $yt_id);
};

app->start;

__DATA__

@@ index.html.ep
% for (@$videos) {
    <p>
        <a href="<%= $_->[0] %>"><img src="http://img.youtube.com/vi/<%= $_->[1] %>/mqdefault.jpg"><%= $_->[2] %><img></a>
    </p>
% }

@@ video.html.ep
<h3><%= $title %></h3>
<p><%= $description %></p>

<iframe width="640" height="480" src="http://www.youtube.com/embed/<%= $yt_id %>" frameborder="0" allowfullscreen></iframe>
