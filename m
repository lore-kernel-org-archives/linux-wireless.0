Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52649 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbbCJUaA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 16:30:00 -0400
Message-ID: <54FF5431.3020708@rempel-privat.de> (sfid-20150310_213004_737548_D86BEE8F)
Date: Tue, 10 Mar 2015 21:29:37 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>,
	Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath9k_htc: force FW v1.4.0
References: <1425929918-860-1-git-send-email-linux@rempel-privat.de>	<87385dz2yx.fsf@kamboji.qca.qualcomm.com> <CAJ-Vmon6j71Eurbe7Sg2ZB06hbOymVYSge_-LeUKCXRDmLE5mw@mail.gmail.com>
In-Reply-To: <CAJ-Vmon6j71Eurbe7Sg2ZB06hbOymVYSge_-LeUKCXRDmLE5mw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T4fhS9k7f5unlUcFdMOqpXrDVLcVEu7k2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T4fhS9k7f5unlUcFdMOqpXrDVLcVEu7k2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 10.03.2015 um 16:35 schrieb Adrian Chadd:
> Yeah, let's have it warn for a month or two.
>=20
> There's some pending work that will break the API with 1.3 firmware,
> so it has to happen sooner rather than later. But yeah, maybe warn for
> about a month would be good. the older firmware is still in the git
> tree in case people want it.

I'm not sure if warning patch will do the trick.
Let me resend this patch in one or two months. Are you ok with it?
Like Adrian said, there are pending patches (since 2013) which will
brake compatibility with 1.3

--=20
Regards,
Oleksij


--T4fhS9k7f5unlUcFdMOqpXrDVLcVEu7k2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlT/VDEACgkQHwImuRkmbWkuRQD/bov/7vZQpwbXwHVeKDZuFMa0
H/y2VqmIiVfkNpvWqSIA/1qQhbKWasMFeAdEwgvj9W4Uw/FEj60RaCJbtmajFLis
=ivK+
-----END PGP SIGNATURE-----

--T4fhS9k7f5unlUcFdMOqpXrDVLcVEu7k2--
