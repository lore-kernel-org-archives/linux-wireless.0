Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZIXHUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 03:20:18 -0400
Subject: Re: BUG: can bring wpa_supplicant/mac80211 into a stuck state at
 will
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <200909211722.33577.hs4233@mail.mn-solutions.de>
References: <200909211259.45431.hs4233@mail.mn-solutions.de>
	 <200909211722.33577.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VWoaOu+HdiIHdamHpThN"
Date: Thu, 24 Sep 2009 09:20:15 +0200
Message-Id: <1253776815.3868.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VWoaOu+HdiIHdamHpThN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-21 at 17:22 +0200, Holger Schurig wrote:

> iw eth1 link
> Connected to 00:1b:53:11:dc:40 (on eth1)
>         SSID: MNFUNK
>         freq: 2412
> Authenticated with 00:13:19:80:da:30 (on eth1)
>         RX: 78173 bytes (722 packets)
>         TX: 144 bytes (4 packets)
>         signal: -67 dBm
>         tx bitrate: 11.0 MBit/s

This is very odd, I'll look into it.

> If I understand this right, then mac80211 thinks it's connected,=20
> even before the 4-way key exchange?

Umm, it is supposed to think so.

johannes

--=-VWoaOu+HdiIHdamHpThN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKux2sAAoJEODzc/N7+QmaVEAQAIowZi/O0USZKS+kEWsV4NXZ
tvoXQuGwSQa4op5nQE46jwK5Xn/JnvjY1yeUaU0bRz/vUFhtF/1EF+BHcxaqT3yH
kCJjt4UmzfR68OB8ZYKWts5cMLZGXzeERoWXoPQ8dzHCvE4i7MtQKJPFSqY3bmYe
rmIUwljPe5WgDkyEYrRiRN0NpDATGERgFMRcajltX07PiPCrfYPbPM+X4ny1b/7u
XYXjK7FaNKO8WSIXggVOFW82ywGkiQfx8VDWM61H6XQbarBPNL7j5+Suji3EWGmQ
8gwlTtKw6AVnibQsyEHkL2zdYdXa+gObD5v+aXyIjem4W1XsNGSZ76fpBfikg+B2
9rYuBHhif5AEvZ5MtT/Bn9oYMOY5HuVV6yJtorV2RPkXQHBJ+E9w9/wDhRUvi3/X
FcBIrNTGdVqkJlM2Pb1d8TgggT9QF3eqs3Eg1jWaosrY5PWMsE/qpVxjZcNI5aAx
fk2/aR1Nabic91IRIuWhzz3spipgGvDnVngb/9vFZvfK4yOY0CiqZu9G5WdkJ6ch
FZliuwmoo6I0uusvzCEb9QIT++bjVNvo2EEXpa2CZ6ibbe4Pq858ZVeRkpZ40xZv
Odqq2bNAdM4HoRrjduMBc3cRd/mpPOlGYcjGdY/LtXOvwb5eTMXkVmsnLdUqPkLH
sgTmtDpP9NE2hedrUgDH
=L3E/
-----END PGP SIGNATURE-----

--=-VWoaOu+HdiIHdamHpThN--

