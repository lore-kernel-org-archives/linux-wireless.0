Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbXKNPVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:21:51 -0500
Subject: Re: Virtual wireless network card for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <rogge@fgan.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711141316.50393.rogge@fgan.de> (sfid-20071114_130227_204342_2DDA04DF)
References: <200711141316.50393.rogge@fgan.de>
	 (sfid-20071114_130227_204342_2DDA04DF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4vV/DjBl21ox8S0DSosW"
Date: Wed, 14 Nov 2007 16:22:43 +0100
Message-Id: <1195053763.4091.17.camel@johannes.berg> (sfid-20071114_152203_693495_FDAB321F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4vV/DjBl21ox8S0DSosW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm looking for a way to simulate a ieee802.11 card on a linux system. Is=
=20
> there an equivalent for tun/tap for the mac80211 layer, so I can just sen=
d=20
> the communication with a wireless device back to userspace (and data from=
=20
> userspace into the wireless stack) ?

No. I've described this task on
http://kernelnewbies.org/KernelProjects/Mac80211TestDriver and somebody
was interested in writing one, but I never heard back from him.

johannes

--=-4vV/DjBl21ox8S0DSosW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzsSwqVg1VMiehFYAQI/Ng/9FmDspbsXifOaSEa79qDFabiV+wGiOyZF
0bvJJ1RLRLqLqy0t1jDp+Ien8iIAvk0GTLChRZbQ7BA3Le6ck1FbDfcdQwGoe75t
fzC6YF9WC1uqFryNGVJ1FZhERbNQgCOupGv0Iuq2/2VFuGkrO0PTMS6P35AI86mZ
HkqrX/NMSDr70Fo+gbiohN9vBh8Ct/WJmCMYVwLSxCJ7Nl1l1stiB493QXxcapi2
l/+Zh+v6VPpu7ArK8v1grdmgLj57uzYGmhgpEa6dwsjKLUmh5b7U/QC5LhD2MCXu
BDGMKsxnnm6UaAxlujlZeiYonIpY5p7OqaEn3d4NXwA9ZYGDeH/Ip/E+yZ9p3tjW
DpPoeASQRgIPF2O0r7zT0OwDxaNv5KhFD68d55yIU0RqSxfRz+Won+HC5sgSWWjs
13VxnuVCJDQULF/ACBD46a/bB9maZy2jDoEgGU375bj+pszousUhRD4+eN0FqdcK
XpzxGqj9YGNK0nD1ekjjvW7n4dTCY29po0bB+RWutWIqG4FoRvg8LDDwYY2K/lGt
3dTAr7i49avFvCsLfLxhCIVoLVW8IRj1PaH/LRx2cNijAxDVdHOWsTv74aoEoGvz
WGr7fiW76pz+a1Fxg3YMV84G15ZPzX6tsloW2Y+ikyD/q+idsKhF6qgaRb/dnduG
c/mRMbtHTdc=
=cUbs
-----END PGP SIGNATURE-----

--=-4vV/DjBl21ox8S0DSosW--

