Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZHAIWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:22:06 -0400
Subject: Re: [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, proski@gnu.org
In-Reply-To: <4A73FA8D.5030804@gmail.com>
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis>
	 <4A73FA8D.5030804@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZYz7lrf6bC8/xN2tnXMa"
Date: Sat, 01 Aug 2009 10:21:58 +0200
Message-Id: <1249114918.26584.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZYz7lrf6bC8/xN2tnXMa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-01 at 10:19 +0200, Jiri Slaby wrote:

> > +	u32 current_time =3D (jiffies / HZ);
>=20
> jiffies are long. And they start from negative to catch such issues. You
> were lucky and/or tested after 5 minutes of uptime ;).

Actually, jiffies are unsigned long, but wrap after 5 minutes of
uptime :)

johannes

--=-ZYz7lrf6bC8/xN2tnXMa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKc/sjAAoJEODzc/N7+QmaJdUP/RDsW9279umdn2Gkc7NL7KlY
KXFOQnUWo57axT9SF7tGV9WCUBtX6m9LXcDDCoeRMzG5bV7mUCKQWkmJIjrjLYHf
BXShdjTYvTA+WnRechOmccjzHC0Q8Wt++vjUiFXXDcYuD5eZu2NGPUgfH5AI5Lcj
6lyCm33MMlBL1UGHWrS7GD2pwWL7sQvww09UGxKjUblS82B/HYgSyCA8JGnOZqsC
UwISKaThS5o6V2pT8baDX6Nh33ozxbsQ++O82NHLzvmxG0pN7Z0kdntKuJNxPubN
KjpEPN27TXKXOjN7zF5hddmeEJrX4K4DlsQUxTILyaelUW3VtLAb37PfxunleCyP
6n0W23YvOyhh/AV5gZp0S4B0687UZwYXl76NNVh/pDI1M+zAjwc08j9YqgZ4Xlg4
aGbk7ZkD77wKVOW5qvwzmHoiXr2afwir2DjAmEnKPDJU/pPWFTl5gPjWIaHA1wz4
yTWyk2zP9WgfZcIPcL4nbPt6cddUCjHpqw8kyxkdrR1Wwp7Qqs1gvCtJJdlfGSZp
1h6ZCpR/Y8C77HGQMcY+K7pcfnVjHqHbVeUmYhrkNhW2/2KpuYsd7QaYWrSN03Zh
Gvcy4Za/Z2aEvqPDIasTjBe0V0BwvTdnQowAqpGJhIa4kEJPzIuXE5zZ0EovKYBn
HMHfxyl1OIa8jGDqwKT2
=JSE8
-----END PGP SIGNATURE-----

--=-ZYz7lrf6bC8/xN2tnXMa--

