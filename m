Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gerolde.archlinux.org ([66.211.214.132]:45067 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840Ab1AVX5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 18:57:41 -0500
Message-ID: <4D3B6D0D.6070002@archlinux.org>
Date: Sun, 23 Jan 2011 00:49:33 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k prevents CPU from entering C4 state (kernel 2.6.37 regression)
References: <4D3B4057.5000206@t-online.de> <201101222352.42913.chunkeey@googlemail.com>
In-Reply-To: <201101222352.42913.chunkeey@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig75DAAE32130EB485389EDF5D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig75DAAE32130EB485389EDF5D
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 22.01.2011 23:52, schrieb Christian Lamparter:
> On Saturday 22 January 2011 21:38:47 Richard Sch=FCtz wrote:
>> I noticed that from kernel 2.6.37 on (i've tested 2.6.38-rc2, too) ath=
9k=20
>> prevents my CPU (Intel Atom N450) from entering the C4 power state. It=
=20
>> only goes down to C2 (there's no C3) instead. In 2.6.36(.3) everything=
=20
>> is still fine. The CPU will only go down to C4 with 2.6.37 when the=20
>> wireless interface is brought down.
>=20
> "ath9k: Fix a DMA latency issue for Intel Pinetrail platforms."
> http://www.spinics.net/lists/linux-wireless/msg58264.html

I experience the same problem, and I do not have a Pinetrail. I run
Intel Core i5-520M (Arrandale) with an AR9280 Rev 2.


--------------enig75DAAE32130EB485389EDF5D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAk07bQ0ACgkQEda5KzHP/VD7TACgu8SzP19H92svXStIlcc2uQpM
wroAoKhCyB0sYHZbXh+IH4/yIzvLZiHA
=QZ92
-----END PGP SIGNATURE-----

--------------enig75DAAE32130EB485389EDF5D--
