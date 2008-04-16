Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbYDPRdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 13:33:00 -0400
Subject: Re: 2.6.25-rc9 -- bcm4306 performance is in the toilet
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804161012w7c07efb0w68f9a8664f077556@mail.gmail.com> (sfid-20080416_181325_307669_A96F226B)
References: <48056406.2060502@gmail.com> <48060D71.6020507@lwfinger.net>
	 <a44ae5cd0804161012w7c07efb0w68f9a8664f077556@mail.gmail.com>
	 (sfid-20080416_181325_307669_A96F226B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZTneHi1LdyfgayjrfK0b"
Date: Wed, 16 Apr 2008 19:30:41 +0200
Message-Id: <1208367041.11676.55.camel@johannes.berg> (sfid-20080416_183324_207122_334D5770)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZTneHi1LdyfgayjrfK0b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> interface.c: In function 'get_if_type':
> interface.c:50: error: 'NL80211_IFTYPE_MESH_POINT' undeclared (first
> use in this function)
> interface.c:50: error: (Each undeclared identifier is reported only once
> interface.c:50: error: for each function it appears in.)
> interface.c: In function 'handle_interface_add':
> interface.c:121: error: 'NL80211_ATTR_MESH_ID' undeclared (first use
> in this function)

You need a newer copy of nl80211.h or revert back to an older revision
of iw before the mesh code was added.

johannes

--=-ZTneHi1LdyfgayjrfK0b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAY3v6Vg1VMiehFYAQKwGRAAvCTPzF8cfWKO5V3HURLTvsu3Bqd88/Ld
pvxVy56CCWvqrzKSd+X7bQ6hjmGjOso+pJmYUdGWk8caR8RZHpUBbGEUZ2WjQJPN
OQhM8RrUP7EWuFBVyp8qnT4FWxoEqKuAveogITxuDDytcD9SnLTboGilqfH0th1D
coHXC8wnzCVLgjBqaqCEUBQzFPGZw9TNC5cCgWh4ZamGJUq6sS/rKm++UFf1ikJF
DJ7I7ZfqmgfBthfP7HuxYjaje6Vh7sM26NhGTTHSsv3zlah2vz7gD1wQARucDFxE
8KBhI4oNlcDpm/H1w1Y51kMsIF+8P4fusTOyi1xQ03LSXUmzRJBxcL/C/qnYp7Xc
U9SN+1JSRG5Vwcjiy67eAMcm31YR/GUCZ/tLCQIZSabv7OFTaMUC3WnBz8RrycBh
K1Bc2+gR2Gj+utCWSuKEtrzQF9+Yoyt/MdeNhwCyh5Vu3oBbmzCSjZiwQzUQ4zgl
gtxSDWPy99RYM8rnARLXpbMgqhqWTM0xZDkNmSR+NkPY39OkkT937Uxyp/0zqqfs
PJchh4qiI4HLi0PxC6NK8hFY16Ya3WXv7KMCWEiLAZFBoQRYbV/5a94MdJO84FCW
BqNLh22JhOmWFnecpVrPzwYtnwt8jxizG9X+hqCuZGTq2HltLQIMvAEw/34TsA13
+utAExOxfhc=
=hOww
-----END PGP SIGNATURE-----

--=-ZTneHi1LdyfgayjrfK0b--

