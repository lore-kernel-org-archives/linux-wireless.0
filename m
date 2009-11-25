Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468AbZKYQb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:31:56 -0500
Subject: Re: RFC: mac80211: add ethtool support
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B0D58EA.8060304@trash.net>
References: <4B0D58EA.8060304@trash.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DHnywhhYoqL1FTQdrevj"
Date: Wed, 25 Nov 2009 17:31:32 +0100
Message-ID: <1259166692.32372.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DHnywhhYoqL1FTQdrevj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-25 at 17:18 +0100, Patrick McHardy wrote:
>=20
>     mac80211: add ethtool support
>    =20
>     Add ethtool support and add a drvname field to struct ieee80211_ops, =
which is
>     used for ethtool driver information. This is useful with multiple dif=
ferent
>     wireless cards to find out which device is using which driver.
>    =20

I thought we _had_ ethtool support via cfg80211?!

johannes

--=-DHnywhhYoqL1FTQdrevj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDVvgAAoJEODzc/N7+QmarDIQALG23dUb1tKuiUPuIDWAKoIT
fV68rRUSH9NW53wH5M0nde+h3WMBqMXc8iutzPASbSr200zjIJyvIHBM/Qemx7Zz
AuO2aBp2QBM6Z8UE34ZRjPtZCGnGUQF/XSuJN6t5QQmICTlMAqoehqoEA5H/ZmZn
86CngFE/o/NgtFYJ97DxsJAoMu2JmGmElG+/vlWOCwoGiAayni2EJjBoa5Cr2RJ5
CffQSooqE8jEy79bdkgrSHz1CzsbDpW/eNAqK70e0XO4IbDqxCUOo7PFWukPvN/0
P6Bm2QTgF1FsjV9zd2/1U9fFldeURoF8bFTtQw2fUdJzytZqq2vkDN+oZVk9O787
qI+1zb2E08w5u13DKg3UbMevCpwDho3ltZsUut16mQqrrwlv+20ggdgGR4R8WUtK
x5UdjYGX+h90BzRqjKXl7JYN2poG58mKvpqo0TMJwT6R/pXu+gc1/7iZNdsAXY13
GkKHDjpPihXGVcAa77ABSduLv3uyxchI7tBJ4S4niQkJho5pXDqIkhpPuY+4/qxN
lqm5SbnKRkMOkaTz3XPvgkfWOrpI1DeNVjAJW45MZT3d5VnNRekmuRQvDI66nLMz
v9R2j37zEJAFpLoah1masFmpRaTcHp8OX/eJu32zKe2NmjgAGee4XWZKO5sw+Fz8
Koe8Nta2GkpvkOYZVtK9
=7iMS
-----END PGP SIGNATURE-----

--=-DHnywhhYoqL1FTQdrevj--

