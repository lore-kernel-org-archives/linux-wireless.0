Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYJFUsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 16:48:14 -0400
Subject: Re: [PATCH] p54: fix build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810062245.32965.chunkeey@web.de>
References: <1223322501.3778.20.camel@johannes.berg>
	 <200810062245.32965.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GztC0fMrC0tbDzKT3hhc"
Date: Mon, 06 Oct 2008 22:47:45 +0200
Message-Id: <1223326065.3778.32.camel@johannes.berg> (sfid-20081006_224818_947752_583E4B6C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GztC0fMrC0tbDzKT3hhc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

still HTML and as such not really useful.

However,


> +int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int
> len);

How about just killing the export instead? It isn't used anywhere else
anyway?

johannes

--=-GztC0fMrC0tbDzKT3hhc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6nltAAoJEKVg1VMiehFYjiwQAJL45AgcWL/ijP5gB0viEWFj
Agrxh4F2OLSrtKSoAOHqkccVqmXkbTac0Eh761UK9B+6ouSqbmyJ4PGkIoetEreo
d+Ijo4bPwlB90+Qr9cENnL/JLRta0dUOu/1y3w5hKncPkTj2rMGpkF2eiy4snoZs
NH3K39XtmRZY7Wby9V+CbbEChZ2DOSxAKuaHMbgPMBximYjkdp/E/FgBWFKA8CJR
KE2c12Vx7tWKeM52QSpfhlEueSvGco1TkmmSjIZCBjg9jTkdjph7hoL5pEY3rjdQ
nDhLF7fTXxQEGR0Gp6JWTrqgFB6BbOBEGUNCZBi/xd3NKm9el3mXKIbeUnHHh2vC
Z1DZXnKCGIjyGnaNUJarC/5W35VMCUgQEz7OgTc7VbLV4XPrfFpCiUMKucU+KnjQ
l4fi0YAXyYzz8lJh11adLA+SXmnMVJizHUHB8tP0uMZCPbEuCcRxTwCeD+TFwMFe
376RMmgnhvPjAybRbR+8Hzi/yVc2uG7mSHzmvjGGm1wlclcnpYtOQGEYWj1lNJ3u
IkDvOSn5tM8TMRneKO3bdXNjuPGxSFETP4/pQQe6JCXq58zcSrw4f0oYdNVsqWUE
LG96jFy3Et0rA1SbXtOZYJDjmNoBv/JnBwNaFcA8MBe0RLMeIHIG83C1kQLTIz9C
p4GvUvsY0PBfMbpBjSUx
=sVsL
-----END PGP SIGNATURE-----

--=-GztC0fMrC0tbDzKT3hhc--

