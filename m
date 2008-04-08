Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYDHO1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 10:27:32 -0400
Subject: Re: deadlock bug in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vitja Makarov <vitja.makarov@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1925ef8a0804060302u74cb6dfey8ea8bfe98761beee@mail.gmail.com> (sfid-20080406_110215_361657_D7628490)
References: <1925ef8a0804060302u74cb6dfey8ea8bfe98761beee@mail.gmail.com>
	 (sfid-20080406_110215_361657_D7628490)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tsYN3o9GHJ1CEuvmVmKi"
Date: Tue, 08 Apr 2008 13:06:57 +0200
Message-Id: <1207652817.14253.0.camel@johannes.berg> (sfid-20080408_152758_385812_38CF716A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tsYN3o9GHJ1CEuvmVmKi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-04-06 at 14:02 +0400, Vitja Makarov wrote:
> Hi!
>=20
> Today I was trying wireless-testing in IBSS mode.
> And found this bug, I have iwl39.. built-in card and rt73usb one.
> Same bug with both.

This should be fixed by the patch I'm about to post.
Thanks for the report.

johannes

--=-tsYN3o9GHJ1CEuvmVmKi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/tR0KVg1VMiehFYAQJWJhAAiMvtZxMWEQKP1b8HUuFrSwkrTz66RJKj
XBaPzzZE4RpUaedC+/Pq7+MGhoOUAorAbg44LlB5hx0odg7THPQ1gHYI70hWntxw
2Acx3ezmwD5+YnETR0wYYD3ckJpb+5DdxL88WdZQYzxQ6CUfosR0+GP3GzR2vg6W
y230nsIdA0LVbPmsov3f8dydTSywTfWJ824Gg8kDnNyF301gnlzdc3JW5njUEnz0
HjKSeSsHxxeyksLgMlUbWz6eKruKT35J4Zj1gDnzxQJlAl+2HO+SRefi0lQcm+x5
MPF4T0B8PVSlY7Lc/ktP1g4J99tigEsO326rZSbczHVQlzrTN/sbpnjRXA/vp0nY
iEUvRfzGb+FXAtedC55EpYvhFN7NkllUgu5SpfcjxK+h0cKDnuBQhpR/svUmQupd
gSuZ8y+ylk0AYAGI31bKv7TW0OaKW2Gt1SwmzvRWTjjinUFXBgKfiO+/aSnDWqf4
Lx8BSm2tzdqfaGEsrDfXEqJK6MiyCYFlUqv2WZAFrlkPlVzRoQ5xKqnRGVmQSEbp
Jm15CEvdeN2y4OCNJodQuv7hYO6rxbhDm2tCYSfts9LuHre00GPjy+8/IsWijHT6
3QsX1SZQcW3Jl35dJApLv9rXkl2s7UAVQrZYATbBJf5QkLQRyb+/jnKgokTQOlGA
QMiJGw3cNo4=
=Sirm
-----END PGP SIGNATURE-----

--=-tsYN3o9GHJ1CEuvmVmKi--

