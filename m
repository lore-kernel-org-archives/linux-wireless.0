Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXLKNWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 08:22:00 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>, David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071210180921.GB7168@bougret.hpl.hp.com>
References: <20071206191150.GC5237@bougret.hpl.hp.com>
	 <1197022818.2603.20.camel@localhost.localdomain>
	 <20071207192756.GA15864@bougret.hpl.hp.com>
	 <20071207.180408.55119728.davem@davemloft.net>
	 <1197221706.9149.36.camel@localhost.localdomain>
	 <1197223174.9149.60.camel@localhost.localdomain>
	 <1197288928.6035.59.camel@johannes.berg>
	 <20071210180921.GB7168@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ifcSWt8z2ZbcfJwEYUlZ"
Date: Tue, 11 Dec 2007 14:21:33 +0100
Message-Id: <1197379293.4037.7.camel@johannes.berg> (sfid-20071211_132204_654888_DD248905)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ifcSWt8z2ZbcfJwEYUlZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Because wext is stupidly defined, you can never extend any structures i=
t
> > uses. Wext never passes in the length that userspace expects to passing
> > in longer structures than the fixed one userspace expects will always
> > overwrite something in userspace, possibly on the stack.
> >=20
> > johannes
>=20
> 	Please check again...

I have. It's worse than I thought, there's a length parameter but it's
not used properly.

johannes

--=-ifcSWt8z2ZbcfJwEYUlZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR16O3KVg1VMiehFYAQIicw/+OGnrnipqurU5rpbuFWar4hBdvs3BvSJD
/qbyGSxoUDydWc7MHJbzh9BIm0iuSzGYyjJSAwPcUJo2nO1Mu1ybTmkX6pu96Wy5
mpY1Q9blOZnyosdojPSr4En3jG63LAPCbSNhg4T5YaIzfY9v2N/AZ160bpXD3/D1
LXnQ//zO7ZVuX1yaf5RUOLt2/hiLkAsV+vu1p76KRxVebPVYcRqPG+OjmfLXk08g
MHe7J7Yaael8s0PH1FPiRWksDXO8t6ms0u3q+efeNia8MJmfBXXtduWS7xFlL7kd
tz9r5q7cv1Bn/LNOEvW36evqrnL4SfL+wHPvwy91RPoFZX4cFAjAKWvqkGC+ELhy
UphCNmxbZNaX3mpQfexLawVp7Joo/RiI0SYBn1YmzqT6gEdnCF+dEU+mdb9SUUeH
e64l0aHf4viIA2Y1RjoNSaL/UDRQCSG4gOvBiPJ9v8rKwgU/3M4pt+0Oa3iEPLG3
nNrJSGc3p9B7i49s5YZfxJpjjJr8QsSwQBYZ3pQ3CRVNl98+AxPX4HkR98K+mZFw
a3SbGImQqb/UHj8cDgf5urWJFIQ6dDyIHncK5boi3korCBkvRAM2DUl6yVMh59lU
TAllTgmekIY/AZPyKG3gKJRKiJKcJtDKcP+hsvuGrKuJg7i4KtcG0MfVACcUlGD/
B04fS5KPZog=
=XjJQ
-----END PGP SIGNATURE-----

--=-ifcSWt8z2ZbcfJwEYUlZ--

