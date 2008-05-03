Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYECOKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 10:10:20 -0400
Subject: another mesh bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-knZyfRzbABQ5JE3W0Kx8"
Date: Sat, 03 May 2008 16:10:12 +0200
Message-Id: <1209823812.3987.36.camel@johannes.berg> (sfid-20080503_160952_476068_C940B76D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-knZyfRzbABQ5JE3W0Kx8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

                                if (!xmit_skb && net_ratelimit())
                                        printk(KERN_DEBUG "%s: failed to cl=
one "
                                               "multicast frame\n", dev->na=
me);=20
                                else
                                        xmit_skb->pkt_type =3D PACKET_OTHER=
HOST;


does not look great.

johannes

--=-knZyfRzbABQ5JE3W0Kx8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBxyQ6Vg1VMiehFYAQItHA//Uu8+hDP8ncBC4Wc0bVg2yioxPjPZdjom
smjjI91ropWbnNDX8tUx0oVGSRYEQOafc4k0pvu1Y58XDvOt2am4BxmzrfBg84Ir
Nm3FUaQLvYCrf+UhSepzQxomCha21iOrcm6+6RyAdXJKdSXaAWGW6++vpn+9rw62
ARRnXKtJHhc3dQuAND5Wv/6ayfRB0+Q1VHRlyoI4eHxdSorCu09UTm4MV5H268dL
jHuHjhw6ZHSFLVbhRGHqGfpBmOnhXN7hKX4/BppIzLqaKqeV0ITwoHq7slDQjBVv
c6Li45Uk7sy9gtY6Gj/KIKkB0rLPSWXkVCWF4PGIhUvtzaFaYag+TuyIuLNboYW1
7wpxu32ItmTdM5bh+e2729i9RN/+ZYckA6Jjf/I+97jWmHDCEbI4ckBs8yDI71XM
8vKcz3BYL4DAkVtLlfBonWklgmjIs0OAyyG7QNEKmp97tXg5uiKSq4oMIPwueCPj
wTLJqI5wvh+i663L0iJ9q+KoQdGC/sum3DGGoKihmwH2zpKcjyr9brAUZtUvK7Eo
FdCmkgCm7COmGHO1JiIJWnc7Yqnzboir1pQkXZxb3feo3VSN/nt1qRK7SLh/09eL
0EuKz8vl0H2YCdhexAcGza9kEzwZdswfnG3sapfE1IvrcWYz/3icrmq/3zCVeSz8
e1TnL0RWDMs=
=Ds0v
-----END PGP SIGNATURE-----

--=-knZyfRzbABQ5JE3W0Kx8--

