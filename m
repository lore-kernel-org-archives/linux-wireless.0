Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:49126 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702AbYDNRhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2008 13:37:03 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZB004KISXPWAC0@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 14 Apr 2008 19:37:01 +0200 (CEST)
Date: Mon, 14 Apr 2008 19:37:00 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: RaLink RT2500 802.11g Cardbus/mini-PCI
In-reply-to: <200804141339.45645.IvDoorn@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Vladimir Koutny <vlado@ksp.sk>
Message-id: <4803963C.2000101@archlinux.org> (sfid-20080414_183709_968854_B9B4A603)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig92BCABCFC76F23BE1A4E0015
References: <35856.201.36.161.238.1206999707.squirrel@mamao.cetuc.puc-rio.br>
 <1208074049.4111.18.camel@johannes.berg> <4801C4FF.5060606@archlinux.org>
 <200804141339.45645.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig92BCABCFC76F23BE1A4E0015
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Ivo van Doorn schrieb:
>>> No, wait, I'm confused, the original patch is correct. As far as I ca=
n
>>> tell, the code there is correct. The bug in that code was actually
>>> introduced by me based on the wrong thinking I just did again.
>> I figured as much from the original commit message. So rt2500pci works=
=20
>> properly when the use_short_preamble has the wrong value, and breaks=20
>> when it has the right one.
>> By the way, 2.6.25-rc8 was the first time that rt2500pci was ever fast=
=20
>> enough to be usable at all for me, so the bug you introduced seemed to=
=20
>> be the fix for my speed problems (which is odd). My guess is that=20
>> rt2500pci treats use_short_preamble wrong.
>=20
> Could you test this with the below patch?
> This enables short_preamble for all rt2x00 drivers regardless of what m=
ac80211 issues.

What tree is this against? It doesn't apply to linux-2.6.git=20
(2.6.25-rc9), which was the one I was talking about all the time. I did=20
not test the wireless-testing or rt2x00 tree.



--------------enig92BCABCFC76F23BE1A4E0015
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkgDljwACgkQEda5KzHP/VBvvQCfZx7EDirpeJV7vdg7k0D8+05G
wqkAnie30DDgbEtluNFbSRkXv0fuya2z
=ofKF
-----END PGP SIGNATURE-----

--------------enig92BCABCFC76F23BE1A4E0015--
