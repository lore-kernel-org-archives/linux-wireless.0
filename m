Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYLFJFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 04:05:44 -0500
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b3153e950812051553r2035b8aex4f54f6cf704a26b3@mail.gmail.com> (sfid-20081206_005321_937743_7F6AE4A8)
References: <1226915999.3599.33.camel@johannes.berg>
	 <1ba2fa240811170632s49c38320y18da189bf2432d54@mail.gmail.com>
	 <1226933141.3902.19.camel@johannes.berg>
	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>
	 <1226942887.3902.30.camel@johannes.berg>
	 <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com>
	 <1226944799.3902.52.camel@johannes.berg>
	 <20081118194652.GD21772@tuxdriver.com>
	 <1ba2fa240811181508y633be12pd9f2f9bd0e2c81e4@mail.gmail.com>
	 <b3153e950812051553r2035b8aex4f54f6cf704a26b3@mail.gmail.com>
	 (sfid-20081206_005321_937743_7F6AE4A8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JavIrmxdnN5L1CLiaQt8"
Date: Sat, 06 Dec 2008 10:05:33 +0100
Message-Id: <1228554333.15939.0.camel@johannes.berg> (sfid-20081206_100551_734643_10F738B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JavIrmxdnN5L1CLiaQt8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-05 at 15:53 -0800, mohamed salim abbas wrote:
> some bugs related to coming from resume is filed caused by removing
> this callback function, any body looking into alternatives to share
> how to fix this problem.

Yes, in fact, somebody _is_ looking into implementing _proper_
suspend/resume support. You'll either have to wait or help out.

johannes

--=-JavIrmxdnN5L1CLiaQt8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOkBZAAoJEKVg1VMiehFYyNMP/RpG8dVIkffA31/sHKOXE6zd
vMhIEIULwB9Q6qGwQq5XHlpDsBgEWp1uABN1mLA005YKz/MNw30Cx4ou0CtZOi/R
EFhjdulU+oRqUktT6PJ4K9cW/8bnuCv8eqTcaBJxB6pu0WMA1tYc/P7FQ92Hue3W
usbtTXX4ahGpQPbE6zNVp19h8dQKylGrD4fVWv9DmoB3rrjkYK8P7478ne20F5tx
QfLCDHmo0Wjk3sFXwBeSD5ZItYGStjQBcr/7IOZJ5B5F6UVV5po+k4ZfXze6NmVz
Eem966Wuf0JnLDOdeHyx/dZrrfjdvBliFb3+9sXkGshOgmFetll8MmmP4FL7oc4+
SyRY8HvRH+hhbv4ZNOMmjPQFkDWA54GZV/6jfTepDzPDRGNvhvo4bmlxj6pnfSgq
9AXlIM/rDu2YBEV6sDDzboeMZOpF79HbUWZmXsvAw8reG4QM/pcA15+C/e3MOzwE
d4bbvPCRy9KrARBGUCrTbODg6j/cmSGN13SBO18IVbs2Y/OoRktgB2wLUgM7tNMQ
LcuJDkS9TvFfXhiADQHsid4KZGPdwDcweVeYayP1J2N3gfyimV/toJH+j9Kouj8u
wLDAoPJ64F5hb3dHvwXb7Gy5rctkWXm01b7Ia1odJn4eI1Ob99IigBq040caILlS
IMP0l7tg8KGNYf19mu/r
=0AI8
-----END PGP SIGNATURE-----

--=-JavIrmxdnN5L1CLiaQt8--

