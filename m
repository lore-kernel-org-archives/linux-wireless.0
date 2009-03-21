Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZCUOXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 10:23:35 -0400
Subject: Re: [PATCH 0/5] cfg80211: few reg fixes and removes OLD_REG
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Quentin@armitage.org.uk
In-Reply-To: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
References: <1237607588-6316-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cyFTrIflA343/YRonRn8"
Date: Sat, 21 Mar 2009 15:23:28 +0100
Message-Id: <1237645408.5100.199.camel@johannes.local> (sfid-20090321_152338_117803_62FA46D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cyFTrIflA343/YRonRn8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 23:53 -0400, Luis R. Rodriguez wrote:
> First two are bug fixes candidates for stable, the rest removes OLD_REG.
>=20
> Luis R. Rodriguez (5):
>   cfg80211: force last_request to be set for OLD_REG if regdom is EU
>   cfg80211: fix incorrect assumption on last_request for 11d
>   cfg80211: make regdom module parameter available oustide of OLD_REG
>   cfg80211: remove code about country IE support with OLD_REG
>   cfg80211: remove CONFIG_WIRELESS_OLD_REGULATORY

Looks good, except the comment for 5/5 seems a little misleading,
roaming is generally thought of going from one AP to another, not from
one country to another :)

johannes

--=-cyFTrIflA343/YRonRn8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxPhdAAoJEKVg1VMiehFYk/MP/RCC4M6RYTVNKp9F6jZARXnm
6FafoblGN601jXDQrZuMWuLR5sPeY6WNBj37BMK0sdeg2+SyeJbjKrzcv0TfCy3W
ArQnlQJRSgqQHbjcMUn/XWcYtg90T+1H+sl/mNS8IduoW+43cBNcpw6N1xXxJVbg
fyka6hckSB93LIMcCCT62NBljtnafMhxv8cPwXICmWm8xNtTxPS1d9lyePxgnm2N
crutsodcOtX3HToBkNxi53RRAqxbA7NgUiabgiiYI0k06yrBX3g+ScSxBCDOM9oo
QiIJ0fo5WyDuHwvuac/l63cyJ9S5wa0Dsr1IlJPQ32TiCdyQsGGgXr5tvFHPH6/Q
3PyUOVQwQ09CrI/ieBsPU89AJ/xzfFkEYLJ0WEt8bVFNn845C0mYx7hijP1gnBok
OoiZnBBq+W9HNaN5D07w9lxSTU7fOcw/PR23K0adCaCsVY7CpD4oVf9s9T/e1gl6
ngN1bSusXfvSoMMgZY+CCp9RtS9MhDIQ8UIrbkQTz43eml/2oGM1YPCgNzPGtmyI
QMdnhANuqedNc9WkYHVuycNhX9f2VGLf7roQ7eib/wKWFQzkwlx/E33+vZSKM7Tj
+t7yhtYz5l0zBhTjAre/XIEEG0Up5grGH3Ptec+aAS7AvOGC3+9/d6FDkGHYrGrN
dNguYz9jWNg8kAceZ5BC
=kuA3
-----END PGP SIGNATURE-----

--=-cyFTrIflA343/YRonRn8--

