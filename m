Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYIOQFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 12:05:07 -0400
Subject: Re: [PATCH 2/2] Don't destroy authentication algorithm
	before	authenticating.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48CE86B6.6080704@odi.ch> (sfid-20080915_180118_027162_C9C60EF5)
References: <48CE8452.9080604@odi.ch>
	 (sfid-20080915_175050_484202_3CD78757) <1221494039.3700.47.camel@johannes.berg>
	 <48CE86B6.6080704@odi.ch> (sfid-20080915_180118_027162_C9C60EF5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-96UDNvUfMB7gGwTmQxrG"
Date: Mon, 15 Sep 2008 18:04:33 +0200
Message-Id: <1221494673.3700.54.camel@johannes.berg> (sfid-20080915_180511_109727_E9560108)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-96UDNvUfMB7gGwTmQxrG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 18:00 +0200, Ortwin Gl=C3=BCck wrote:
>=20
> Johannes Berg wrote:
> > On Mon, 2008-09-15 at 17:50 +0200, Ortwin Gl=C3=BCck wrote:
> >> reset_auth is called before each authentication try. So it should not =
destroy
> >> the auth_alg that was set before.
> >>
> >> NB: this may have side-effects with automatic algorithm selection if A=
P responds=20
> >> with alg not supported.
> >=20
> > This seems entirely wrong.
> >=20
> > Is your AP not capable of/configured to do open auth and _also_ doesn't
> > reject the attempt? That is, the AP is just completely broken?
>=20
> Well, I see that with other (binary) drivers it actively rejects such=20
> authentication attempts. But with this driver it doesnt. The only differe=
nce=20
> that I can see from the packet logs is that mac80211 sends no probes befo=
re the=20
> authentication, and that the sequence number is being reset.

When's the sequence number reset? Which sequence number?

>  So maybe that keeps=20
> this Netgear AP (yes it's crap) from rejecting. Or then it's something in=
 ath9k=20
> that causes the AP not to receive the packets in the first place.

That'd be weird.

johannes

--=-96UDNvUfMB7gGwTmQxrG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzoeNAAoJEKVg1VMiehFYBiYP/3lD5lnTkIVEkLUqDUlsi2hs
8atXKRCqHLyxokP8ISchR4DpVgwmuEd1pGaUyfDOQx2pEnqwmDV3xNxkfLNrDXRJ
UVSJGHu8ts34nDvwPnUbwrXNfnVP+FymuRRDcmnk97UjAA2FgMWIoX3UOkDQL6nD
2k94E3kCyWi30OhMdUBozF2b6dOSpN4FquikkYGwhEEkVTUWYVscQCPWZ2UgDNLp
7XtmaVT9cWdAHcGlX4+DOvoXXQrR8hhfAVGAqf26eGcpAQh2NUjDyL67ZkAM6WXI
13Z3rr/ObxYnzshD/FIOza/yoEzjcTmP+LAIOHcdzTqTYgw6ZrhMgAoOySuQ+55i
21GhjgVNUSJujIfdXUIy2Z49YHX0q5aQ4zd4lpi/ipO8DjRZbcD4rfuu4pwGMew/
WuHtqYrvuC2Kpumu2U2rAZOq/QPhg7nrOQfAnSGaQY5ShjZ3eKOK2EADACLnb3Ow
d+zOeXq6fpgphYxoJNKSVPYnaod98Wk9+U+HpscSgYTw/LeibMbdBTm62aBLX3Ir
BnJTAHJG+JOraYdDWZ/DtAVoKx3gLJ02d/gctJLx3GFrWzW7smcE7sN/sq3Z0LQm
rFI+stbgIrsOp8MtFPA2nSlkC1m6rYd39sMR5148c+HU7yHw0N64aB9SsvU0/gvr
3kxxTUgfNPujkFbKFn7u
=Serc
-----END PGP SIGNATURE-----

--=-96UDNvUfMB7gGwTmQxrG--

