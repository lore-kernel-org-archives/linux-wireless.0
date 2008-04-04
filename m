Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41922 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYDDXc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 19:32:28 -0400
Subject: Re: [PATCH 5/5] p54: update Makefile and Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net
In-Reply-To: <E1Jhv2j-0006LQ-3j@debian64.daheim>
References: <E1Jhv2j-0006LQ-3j@debian64.daheim>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/UMkuMQ+7CJOJxkWUMwQ"
Date: Sat, 05 Apr 2008 01:32:19 +0200
Message-Id: <1207351939.6675.2.camel@johannes.berg> (sfid-20080405_003231_270394_F1320D70)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/UMkuMQ+7CJOJxkWUMwQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-04-05 at 01:09 +0200, Christian Lamparter wrote:
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
>  drivers/net/wireless/Kconfig      |   65 -------------------------------=
-------
>  drivers/net/wireless/Makefile     |    4 --
>  drivers/net/wireless/p54/Kconfig  |   63 +++++++++++++++++++++++++++++++=
+++++
>  drivers/net/wireless/p54/Makefile |    3 +

You can't do this in five patches, it'll break git bisect. Also, for
files that are exactly the same you might just want to ask John to do a
'git mv' instead of posting full patches.

johannes

--=-/UMkuMQ+7CJOJxkWUMwQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/a6gqVg1VMiehFYAQLVKBAAl3pvQK5+Gwek1G6zGhccd5fiqotRU7A6
BP8pA7bINb+fS4GqX92ShAwA/ompvtOJ3+g1ldumFJ8jKSp2dutB0sa5LUiHnzTM
/e+lWkVzpkTVlBi0XvYC4f/HBOKttfayv/NAz3m+83/MuWqPQ56TR3nhoE4XMpFY
r5MO5vJ224i8hrMIVEYBMimTqxSss3JHHMsuYeyme3Knx2N/e0+MQMGDkebp8DjD
eCIaSwymPbghYkvXFU4m38GlIj+4Q2jKx13dAQ0jcnhV/pB0Q0GqEmUsKXpV2KyX
V3ojH6ccf+Ohm7UsXxLL6qFj9fFYi1OGQ2phObDWPz0HqV6nCxasd/2CBtzOELWp
h7cRv8U/kQxITiRcg210tK7JCLEoRSLZQ9FQhLVeB9cFfWFi2hm6IRkCuL9j+BpK
gnmS/xz6OB8qSFyswEp0cy4Xz203oznf3smqd5RGTCzpzO3b5CxuTEa40ODBTUvY
r+DV/+CRN4a6GvXOPzrmvj7owgZclKN/UMobBMC34u6jcVm8kVvxT+AGpg/V2L/S
PAHO6S8g8LzWRYlR2VvzwqPT6bNxO98/2xNBvZSaLeAgK82s+Xcx32/1q0eXMQvV
o4yN8RRo6VesGtkv+UF2MbZSFL36PC8VHTJXF3fdWIR+taMw5btnI9MINuBo10Li
fOxYOaze7xk=
=ho+U
-----END PGP SIGNATURE-----

--=-/UMkuMQ+7CJOJxkWUMwQ--

