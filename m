Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbXGGQkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2007 12:40:17 -0400
Subject: Re: Errors when firmware is missing
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UBBnwQ2J80pfk8EddJpq"
Date: Sat, 07 Jul 2007 18:41:15 +0200
Message-Id: <1183826476.3779.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UBBnwQ2J80pfk8EddJpq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-07 at 12:27 -0400, Jon Smirl wrote:
> I have a new Broadcom 4318 adapter (which has exactly the same issues
> with promiscuous mode).

Huh? That's really weird.

> I didn't have the right firmware down for it
> and I received this error message when I did "ifconfig wlan up"
> SIOCSIFFLAGS: No such file or directory.  This is not the most user
> friendly error message, but I did receive a log entry.
>=20
> I tried the same thing with the zd1211. In this case the wlan0 device
> didn't get created.
>=20
> Does it make sense to specify consistent behavior when the firmware is mi=
ssing?

It does, and I believe we've talked about it at the wireless summits,
but I'm not aware that we've reached a conclusion. It would probably be
nice to have an error message -EFIRMWARE or something; that for zd1211
no device is created is probably counter-productive, that way userspace
will never know that a wireless adapter is plugged in.

johannes

--=-UBBnwQ2J80pfk8EddJpq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGj8Ir/ETPhpq3jKURAtnRAJ0arD21tntF2/5NrkjZNV/qIl68QwCeJxO6
sBT6gPJPaXBsmWqiVe/ADZs=
=YfL6
-----END PGP SIGNATURE-----

--=-UBBnwQ2J80pfk8EddJpq--

