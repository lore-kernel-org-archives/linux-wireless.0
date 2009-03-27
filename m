Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZC0Hb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 03:31:59 -0400
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on
 5GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Seibold <bernhard.seibold@uni-ulm.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <148ad3659dd1afe81ce6408e2a48715a.squirrel@secure.sipsolutions.net>
References: <1238113267.29544.14.camel@blob>
	 <148ad3659dd1afe81ce6408e2a48715a.squirrel@secure.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rScnWFA/UivOnUPym3/h"
Date: Fri, 27 Mar 2009 08:31:20 +0100
Message-Id: <1238139080.4331.89.camel@johannes.local> (sfid-20090327_083201_986376_381DA8DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rScnWFA/UivOnUPym3/h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 08:15 +0100, Johannes Berg wrote:

> > Please CC me on replies.
> >
> >
> > --- a/db.txt	2009-03-25 19:38:22.838975857 +0100
> > +++ b/db.txt	2009-03-25 19:39:37.722248019 +0100
> > @@ -165,8 +165,8 @@
> >  country DE:
> >  	# entries 279004 and 280006
> >  	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> > -	# entries 303005 and 304002
> > -	(5150 - 5255 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> > +	# entries 303005, 304002 and 305002
> > +	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> >  	# entries 308002 and 309001
> >  	(5470 - 5650 @ 40), (N/A, 1000 mW), DFS

Also, the 5250-5350 range requires TPC, but we haven't covered that
requirement yet I think we need to use the lower EIRP limit of 100 mW. I
guess we should also update 5470-5650 to 5470-5725 and take into account
the TCP limitation (500 mW max power then instead of 1W) which I seem to
have gotten wrong too.

johannes

--=-rScnWFA/UivOnUPym3/h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzIDFAAoJEKVg1VMiehFYYAYP/2VN6gx4JUQtq0uwn3zALhRa
sQoBEHP5LH5R4OwYVtuXZcstFoeksT0qun3NK/GAZN/7HJG4XmV62dDvvOk5JEYo
cbtaqmXoF7nHceN0MX3YOS0mISI7NfvBD0d/bbJ9AveRcJVNsB1IuVZmH/zPuRb0
6ccz8j5u83qs1sXtKxxtU7b2u5k8Z0C/ESVXFYoPLRWj1t18U72gad/FVLenu4pd
GXZn0yEKHINjbuO25mgkjIKpJYIyVuSd/lijdjNZX/a879hFPg3lxC0vkIJHH9Eb
QtiYEbOZPio9RUteCCjbgFD99xsJnS/irl+DI9HaO+WalU+zYwfgkmmzJCyCMUB9
M2PuSVTLkr5zyliDD+r/u/xKkYV9BwVKfmpbp5PfwYnhse9RGlGWeNzi6zXE5Czv
aR1ske5mvmCbkgTSyUZRLT3Nd0kf89NFxqMMVV8N7qEJZGnodle8idrYgAq1nS5V
88Of6x7Z/yuHNDDEqf1l/7ZNn0amvzMxGGs+CYEMgKdkSjs4PgCd0O/JMapSZL61
8761s11bk2E8+is9oFkM7R/pokmiQZHHePEhIIjJGvivdx42H2vTEGBkrjOx0Gx0
nyIA1oriu8MBC6zKXd6ViXJ94DMN2P9UsLheBCStEQGsnEzvT9ceIkeOWycwsXQ6
cwu9oLV/TzV6QIzzrA1y
=pVbX
-----END PGP SIGNATURE-----

--=-rScnWFA/UivOnUPym3/h--

