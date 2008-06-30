Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbYF3LJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:09:55 -0400
Subject: Re: compat-wireless high packet loss.
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Cohen <guy.cohen@intel.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Patrick McHardy <kaber@trash.net>
In-Reply-To: <247d6d340806282323v3192ead8v149359e482375991@mail.gmail.com> (sfid-20080629_082355_009658_4E662435)
References: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
	 <247d6d340806282323v3192ead8v149359e482375991@mail.gmail.com>
	 (sfid-20080629_082355_009658_4E662435)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-d28OrUwL7NdCqCrsbT2/"
Date: Mon, 30 Jun 2008 13:09:09 +0200
Message-Id: <1214824149.5507.36.camel@johannes.berg> (sfid-20080630_130959_317441_6930A2C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d28OrUwL7NdCqCrsbT2/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-06-29 at 09:23 +0300, Guy Cohen wrote:
> More info on the issue.. The problem is with TX of unrestrained UDP
> stream, when the traffic generated at the application layer is larger
> than the link can pass. With kernel 2.6.26-* the traffic is restrained
> when the TX FIFOs gets full while in 2.6.25.* frames are dropped at
> some layer. It seems that the drop happens after the IP fragmentation
> step at the stack.

does compat use multiqueue now? if not, look in the mac80211 fake mq
code.

johannes

--=-d28OrUwL7NdCqCrsbT2/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaL7SAAoJEKVg1VMiehFYBTEP/il6uOq0lb5S8y09nCYqdK5d
qfenCdlYS/Z/km2JkYxfLLB33MCvwyMDeAe3YuGlYH4zfrPsUPdgXENrYhiCBicl
TyvAWgODdtDR7kvt3Pd3tdgifyZOBh8A7zxCQ5/KwnjEMWeHLfUssPAuBTcT0/xy
1TPaz5LqZ2/s0G1x3qfCdQKU3uu6R7nxz8hQdnPANujckBYEcCFG0edwVZskfho3
8NDyiJPleKGG3F0mQblG6QmSazW1dTvIkTv3ADYf6bikpqtX68zbyy4xUfWgJWZI
BEA/U7Dbk+dIwnL6HZKgI0WPw8eXXkfnAS0DLBiv5gXw0hIkrfylERzEwIs+2bNc
Q9HLcoPTTIJCE5Y8hlYr2d3ed27yBIBOvp1UhKmDFyJ2F+DfBAUsuYf0WYK1HJSN
THDHubEq5znqYrlqCb/fpCR/ZAlSmkqsGqe5QU6EGzZ4pQoWRIn6Kd+OJdGlv21p
seKVpx5kC0EjJVaraqdfRYobjF7ktGkXXtSg8gfi602KwhQTjf9Z5bo5MnJBgvMF
3ABrK6qbSoeR6m6UxMzj/K/yHrUQeIk3gXAebwuISxZLhjnjDq2nduU0UjKwqTmF
+mFgwMY7LuNf6N+BdH0GXOKeSB1oVNzsUqJSNVcRVFy16UW2QVbgsGKx64AqhWQd
pc5uDFXo/O7CQY7KshFO
=4HWO
-----END PGP SIGNATURE-----

--=-d28OrUwL7NdCqCrsbT2/--

