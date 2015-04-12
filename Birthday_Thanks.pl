package Birthday_Thanks;  

use JSON;
use strict;
use warnings;
use Data::Dumper;
use HTTP::Request;
use LWP::UserAgent;                     #It's being used for dispatching the HTTP request
require HTTP::Headers;

my $x_auth_token = 'CAACEdEose0cBAK7g8glp42dvg9vkUFXd4wSbeBuBRqB5rUJp0zJZCthZAZBbIb1RXZBBhR38ylhJB1ajbj9CnD7BF1mZA3zEyy5Fn5qdYV4nW76FT38u5YUPiPZBi4GJxg8yD7jT3WZBo3GzpWo7hQ4pUZCbVvNhDKsS3ZATkg9cHr6fsRY2rZAMqmDCcNfzkKD30OK1pyraSLVEZAfS5PIXexYyV9Sr96zZAsYZD';


sub commentOnPost {
    
	my ($post_id,$name)= @_;
	my $request = HTTP::Request->new('POST',"https://graph.facebook.com/$post_id/likes&access_token=$x_auth_token");
    $request = HTTP::Request->new('POST',"https://graph.facebook.com/$post_id/comments?message=Thanks $name&access_token=$x_auth_token");
    my $ua = LWP::UserAgent->new;
    my $response = $ua->request($request);  
    print Dumper($response);

}

sub getPosts {
    
    my $header = HTTP::Headers->new;
    $header->header('Content-Type' => 'text/plain',);
    my $request = HTTP::Request->new('GET',"https://graph.facebook.com/me/feed?fields=message,from&limit=40&access_token=$x_auth_token",$header);
  
    my $ua = LWP::UserAgent->new;
    my $response = $ua->request($request);  
    
    # print Dumper($response);
	
	my $return_hash = from_json($response->{'_content'});
	
	my $i;
	my $post_id;
	my $name;
    for($i=0;$i<40;$i++)
    {
      if($return_hash->{'data'}->[$i]->{'message'} =~/Happy/i or $return_hash->{'data'}->[$i]->{'message'} =~/hapie/i)
      {
      $post_id =  $return_hash->{'data'}->[$i]->{'id'};
      $name = $return_hash->{'data'}->[$i]->{'from'}->{'name'};
      print $post_id."\n".$name."\n";
	  commentOnPost($post_id,$name);
	  }
    }
}

getPosts();

=head1 Script Name,Desc
Birthday_Thanks
Perl script for liking and commenting on the wall post.

=head Basic Info
Four Major HTTP methods - GET,POST,PUT,DELETE
1 Get comments and user_id associated with it.
2 Like and comment the post

posting comment - post_id/comments?message={message}&access_token="". It returns new post_id.
liking comment  - post_id/likes. It returns true.

Facebook limits number of response through GRAPH API.
=cut
