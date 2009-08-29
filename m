Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZH2JIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 05:08:45 -0400
Subject: rndis endian warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8Ahw2qOvVMbARTg8AFjz"
Date: Sat, 29 Aug 2009 11:08:43 +0200
Message-Id: <1251536923.3456.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8Ahw2qOvVMbARTg8AFjz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

There are a whole bunch of endianness warnings from sparse in rndis --
please run

make M=3Ddrivers/net/wireless C=3D2 CF=3D-D__CHECK_ENDIAN__

and check the result.

johannes

--=-8Ahw2qOvVMbARTg8AFjz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKmPAUAAoJEODzc/N7+QmanGkP/RTJUJD54mCAboss47Ts5Dgv
eumuG6k+v7Q5SFZz1QfA1CVW4xt4586KBxs1l8kcYw3enFz7C3u+uxRXJwB7/DU4
hunfALQ6T3xhgqH1QzTv/yeM2mAc0B9A4569q0FdwqA6h9tjzQb8IJBNbDb8Cekh
qkHvp5NHkeD7OYzHwUhqrAxHxORWUlUBYoAKbMA+z89GcumZDcYh6uX1XRHU8NKk
LneiACX64oJRkDl7LUIMtaFo1aHZvBZIYRIGDAcJWxT+EW9nhn5eeAZEunce54cQ
og6aTFvwKOQO6d3PmzKoBQwc7E71NDGJ0ftVq2gxX3PK22iD4iuux8QtlBOyYzL6
gl2njefWZozasK/52zo6LySc6ryEAJoAVjsJEjP9B5SfufgkvQZpwAkXN+3/bvDI
0cZv2zbu1GbI94BALD75AdAYL5yNv+vShtT99liX5oX5tURpGe8ffRnO34xUOU2l
to2KVt/0WcmYFzxXLW2UcggzzHsggj489q8dolBuCIbd+r/1gKklwsxrWXZ3G/pu
K3YFWPUmxmvhhQMzDow/OGAVAuWBZmbqY6gy0IaAgDhuKMdPzDmY9A7fGcpvMgYM
k3xUS4lPpHa+spUES9icOjBQa2ak/KNvHo3Uu+S/tTL8zadbnZ7lww09UE7156B8
992sDelYzvyvPqlgd7aO
=UHMh
-----END PGP SIGNATURE-----

--=-8Ahw2qOvVMbARTg8AFjz--

