Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbZDPWWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 18:22:10 -0400
Subject: Re: [PATCH 2.6.30!] mac80211: validate TIM IE length
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Christian Lamparter <chunkeey@web.de>,
	Vivek Natarajan <vivek.natraj@gmail.com>
In-Reply-To: <1239920291.26575.37.camel@johannes.local> (sfid-20090417_001849_051533_DC947D05)
References: <1239920291.26575.37.camel@johannes.local>
	 (sfid-20090417_001849_051533_DC947D05)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qef3EK7nnNb2rwHn1Apl"
Date: Fri, 17 Apr 2009 00:21:38 +0200
Message-Id: <1239920498.26575.38.camel@johannes.local> (sfid-20090417_002215_771553_87A08C19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qef3EK7nnNb2rwHn1Apl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 00:18 +0200, Johannes Berg wrote:
> The TIM IE must not be shorter than 4 bytes, so verify that
> when parsing it and use the proper type. To ease that adjust
> struct ieee80211_tim_ie to have a virtual bitmap of size
> at least 1.
>=20
> Also check that the TIM IE is actually present before trying
> to parse it!
>=20
> Because other people may need the function, make it a static
> inline in ieee80211.h.
>=20
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> I can provide a shorter fix for 2.6.30 if required.
>=20
> Kalle!!

Oops, sorry, that was Vivek :)

johannes

--=-qef3EK7nnNb2rwHn1Apl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ569vAAoJEKVg1VMiehFYrRwQAKFRGlnOThfONGvOZgk8myZh
jn9flWy53x8snAj+rssX2rX8h1QWvKJwkMGAxrEZM27rtKwVJIGN2UFeKUOHHzQ1
GMW+JptmiK7ur71MBmUifsxQmT6lHAn0F6dIY7ZbhdoPP+CmdTfKRXp9Eu7XPXbk
woX+A7HhEap+B5VRK4dkzjwVS66ANgX3l6fa59xT76+K7ZbZ4e4O73z19xMJYY6t
weF43W7zb50Hu6VrjA5tKOKt8otJp7zDWOBfGMaEj/cRTl2/BpSSjcZ9Ku66KuW0
9eS9+g3/gSUByMXrYFxEfAS+7gLQo+jiGeZQv3vJRHPvZYIBJMmfX5WaGF9kfFKg
yT8C29Ud7/ptZYsnCmixk+JR0lS6xNi9yHsZkEoCLJM1SJtxAGNmmVIrl8VVAME/
H8j6eLkIAwPKgWFcrxGLSUMTezQ5AlTXaA+G4SV9kUXWxfggQoo03IGCWy6tLuXR
0kL/8RpdJEzSToBIq4aK2ZZ+QxdHuwBOptllNa9L5volsMR5nR4GqpOVcQPFzHn4
Ju4TC86r1alODFuBcEXvk7xveY4tFsYzwr1SzV4xWfjWGx1VsNdhH4D/5qplxNO7
euTXwlPPao1wWLVWr4M0T5B8ZQrHfdZ1y8QMztBGwvbGr3TXzOgJn/JKubnGk9mp
tkbn52Ku154XobWsY9iE
=KbeR
-----END PGP SIGNATURE-----

--=-qef3EK7nnNb2rwHn1Apl--

