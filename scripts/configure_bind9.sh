# Here's all the steps I followed to get it set up. Though I haven't managed to test it yet. Obviously all the below need to be automated

# This is what I used below:
# http://blog.philippklaus.de/2014/08/deploy-your-own-bind9-based-ddns-server/

# Here's another one that I found but have not used:
# http://andrwe.org/linux/own-ddns


apt-get install bind9

#########################################

/etc/bind/named.conf.local


// ---***--- Own DynDNS
include "/etc/bind/ddns-keys.conf";
zone "dd.skad.io" IN {
        type master;
        file "/var/lib/bind/db.dd.skad.io";
        // for Apple OS X 10.8 "dynamic global hostname":
        //allow-update { key mac.d.example.com; };
        update-policy {
                grant *.dd.skad.io. selfsub dd.skad.io. A AAAA TXT;
                //grant *.d.example.com. self d.example.com. A AAAA TXT;
                //grant sb.d.example.com. name sb.d.example.com. A AAAA TXT;
                //grant sb.d.example.com. subdomain d.example.com.;
        };
        notify no;
};

#########################################

/var/lib/bind/db.dd.skad.io


	$ORIGIN .
	$TTL 10 ; 10 seconds
	dd.skad.io.             IN SOA  ns1.dd.skad.io. hostmaster.skad.io. (
		                        2014080101      ; serial
		                        120             ; refresh (2 minutes)
		                        120             ; retry (2 minutes)
		                        2419200         ; expire(4 weeks)
		                        120             ; minimum (2 minutes)
		                        )
		                NS      ns1.dd.skad.io.
		                NS      ns2.dd.skad.io.

	$ORIGIN dd.skad.io.
	$TTL 30 ; 30 seconds
	ipv4                    A       38.68.84.19
	ipv4v6                  A       38.68.84.19
		                AAAA    2001:0db8::2
	ipv6                    AAAA    2001:0db8::2

	ns1                     A       38.68.84.19
	ns2                     AAAA    2001:0db8::2

#########################################

/etc/bind/ddns-keys.conf


Fill /etc/bind/ddns-keys.conf with all the keys you want to support. Generate them with dnssec-keygen -a HMAC-SHA512 -b 512 -n HOST sb.d.example.com. (to be found in the .key file):



dnssec-keygen -a HMAC-SHA512 -b 512 -n HOST sb.dd.skad.io



key "sb.d.example.com." {
    algorithm HMAC-SHA512;
    secret "5f2It/b/7wF0QmnFQ2DiTVIF6Z/cN8a8dxyIf149my61ihkgNHqn4KjG eTlbYQ7CKVskV4lmV1R0M1xAPj4Ipg==";
};


#########################################


named-checkconf

named-checkzone dd.skad.io /var/lib/bind/db.dd.skad.io

/etc/init.d/bind9 reload



