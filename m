Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZELSFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 14:05:11 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242151180.3203.19.camel@localhost.localdomain>
References: <1242030669.6930.10.camel@johannes.local>
	 <4A09B130.9000106@gmail.com>
	 <1242151180.3203.19.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HYUgRdJZmMQ9HIsAzt2k"
Date: Tue, 12 May 2009 20:04:39 +0200
Message-Id: <1242151479.11924.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HYUgRdJZmMQ9HIsAzt2k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 13:59 -0400, Dan Williams wrote:

> > Please leave rfkill-input available as a module, at least until the bug
> > I reported in my previous e-mail 'Soft Lockup With rfkill_input and
> > thinkpad_acpi' is resolved.  Otherwise it will render Thinkpads, and
> > possibly other systems, unusable with rfkill enabled.
>=20
> The problem gets fixed where the problem is at...  if the actual root
> cause is in the rfkill rewrite, then maybe Johannes should take a look.

We don't even know yet whether the bug is present after the rewrite!

> If the actual root cause is a bug in thinkpad-acpi, then it shouldn't
> block the rfkill rewrite, but should be fixed in thinkpad-acpi.

Unfortunately thinkpad-acpi hasn't been ported yet in my rewrite, so we
can't know. I've poked hmh, but if he doesn't respond soon I'll do a
crude port and ask Will to test it.

johannes

--=-HYUgRdJZmMQ9HIsAzt2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCboxAAoJEODzc/N7+Qmau2AQALeaRbr/DV4eWvnR2PdymZQz
hoZjSOwJB9GbzWyreUDB6yHPZSJWSncuEhcWIJJeJcq4L+iRHRigr3N25HS2STPM
ANROvEwuPhhlWdE1/Ah9jIB41X4yGF9BokB4kRVjJWEhLBJlgnZTg3HKHa5gPfdb
0O7yqtJbdWMybIrPeATpyYBd0iVxV5jpdUGDcTV7KBRz9XTPKIQBauDYxGKi2nCc
m2oy30z/gMimSfX6rNBnr3Zg9e5aR6pUXuwNlkOgnnNft0WC27wedSvGmCmuwzbR
oYkK5XDS2chvBDDQMe5PTTQELuIdvFDaCCYCdKFaqWSc1UgPl4AunO/QbMfctrYu
M1rlI5xBUxKyAKToXDdK8XUXsnmrGAf3Vc6pp7pYI/JsOYe0PP7kfJ2rPYy9BPVs
GlCYBgw5FTJ7xH94basSIAUDBGJ7OI7G9B/Rl9QNHpuWKbAr7SpcoBZ607wsN9+i
+5YdBaE66G969lnRWc6B0YLYkMMLCnWI1XBJ7LKGzuR+pB+sW1DAB3ABCY5A5ZkA
w394WA2p2TBn4g8vtrVd3/INb0/ZZV9UjkzBkt5vBbTG6TEGbeH7oFdnjXCKf7aS
utYoVu+tqM+QJYnoBjuLuMej3twwkACGVREwkDw8niHwdfrNbL67L2QOQLfIpXgp
cuFXgelVsITm076/oCdZ
=m+Gx
-----END PGP SIGNATURE-----

--=-HYUgRdJZmMQ9HIsAzt2k--

