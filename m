Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYA3Mnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 07:43:33 -0500
Subject: Re: [PATCH] mac80211: remove port control enable switch, clean up
	sta flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080130020811.GD5015@jm.kir.nu>
References: <1201537178.9397.16.camel@johannes.berg>
	 <20080130020811.GD5015@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/ry4L8rFiGlVdky/Gs0V"
Date: Wed, 30 Jan 2008 13:35:09 +0100
Message-Id: <1201696509.4014.10.camel@johannes.berg> (sfid-20080130_124356_549542_3DE0A274)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/ry4L8rFiGlVdky/Gs0V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-01-29 at 18:08 -0800, Jouni Malinen wrote:

> > Also, since I was working in that area, this documents station
> > flags and removes the unused "permanent" one.
>=20
> And changes the flags.. These used to be shared with hostapd. Has that
> been abstracted so that there is some kind of mapping taking care of the
> differences between hostapd and mac80211? If not, this change does not
> look safe..

That flag sharing is long gone, they're translated in net/mac80211/cfg.c
when stations are added/changed via cfg80211/nl80211.

johannes

--=-/ry4L8rFiGlVdky/Gs0V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6Bu/KVg1VMiehFYAQKR0g/+OWl2XCyfbrLEFgxRjJNXEixawx2BkZdt
Q61P+Euj2FduwesmbRWNM8pEdjgmPkvJIwpv9MNMHAlexOp5TbbPdKWzBQtogKQt
nVMnGSKk/XZxdCoHNkWFNV9538CnFZIaA2RPhu0r7TPiWK8MERG19bfw+S/9DnGr
1QBcpKKA1xoTXj4MyoeOC+jpM/TreRz1Rzq+2Wxuabcdd2yNnH22IfmljTC7egya
bhrVglsNmOoj5fVTMo5/Lf+qOWdUat+wJWbWUuta0lJIbQ3el36R7L2NW5UCHPrj
LmBG4UBBQO5nbky+FCFuEdI3zeSAoTMsu0tIFD5Ll9FqkAzH4Zo2UUmvkgzJjLTt
E0GXHEygSCQd0Ss3jsFhJPAN4c3+XjJE69RNzsyHGeJqTyTq96DHWdJmm9nXO68G
ECeeTDqmMY+/JRPS4F87b6poJzcX+rcPOcQvZB6enmshMi86FCjkbTDFzL9pDwPM
uFdy/QS5PxtQsoMn81RPqyxVbmbhorg9V1ozX/3ownRqbowZ3os02S6gkfG2yqBV
HfRgZoZwXfjOCDlqtbWKHkZAqYG9jH3na4aIGC5lsr9grgEsKNHyb6lj8Kke9BBF
hzlJ0SlBBuvQjrWAqGtG2QoA3+jTQ79QpLPYYhWE7YPa6N/hkcTEIV3l2uKxnOuN
uuuZZhS8NTg=
=u9du
-----END PGP SIGNATURE-----

--=-/ry4L8rFiGlVdky/Gs0V--

