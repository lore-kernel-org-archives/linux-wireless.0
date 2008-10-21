Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYJUKrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 06:47:01 -0400
Subject: Re: [RFC] make ieee80211 invisible
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>
In-Reply-To: <1224006562.10113.47.camel@johannes.berg> (sfid-20081014_195730_335063_053D77F1)
References: <1224006562.10113.47.camel@johannes.berg>
	 (sfid-20081014_195730_335063_053D77F1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CN7cNWaLe61QOYe9ZrEs"
Date: Tue, 21 Oct 2008 12:46:55 +0200
Message-Id: <1224586015.5521.14.camel@johannes.berg> (sfid-20081021_124706_139738_7B2C2239)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CN7cNWaLe61QOYe9ZrEs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 19:49 +0200, Johannes Berg wrote:
>=20
> This makes CONFIG_IEEE80211 invisible. The drivers that require it
> (ipw2100, ipw2200, hostap) select it, and everybody else really
> shouldn't even think about using it. Also, since there really is
> no point in compiling anything without crypto support these days,
> remove the crypto options and just enable them, leaving only the
> debugging option which only shows up when a driver is select that
> requires it. This makes it hard to enable, but most people wouldn't
> want to anyway.

Do I have to repost to upgrade from [RFC] to [PATCH]?

johannes

--=-CN7cNWaLe61QOYe9ZrEs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/bMcAAoJEKVg1VMiehFYnLoP/AuiCm4iooolHPS45C6mAH+4
1b2Lkh0o6F7yJLQfudlbwYyGhWtoMAs4bQ+zT1eoErxvRhnQgtFfkHXmckDH8EqV
bPqK1xn+XOQnJMz9BqRbLaRHreM06iXOuVaCd8QwmJPXnUWg86kH3YNI1WmeuS7Y
RcKf2fU4etSwfEYONTqlZJn+HJd8hfh+QfceOkCMW36HoUlpih3HZMp77Lb4wt15
Hqck99vuOYsClsK/Xdjn+ItNsGVNkkaNmtTOMOaBKzLX5JHhj9KBDYyCl43OPzwW
BvRTwxFmJqVjaS2NqyL6s+r4CjJ61ng5iaElzpehp1PNiXXUEeCMvHeuZVhEYb4j
5SJBUGfnjoChwPOHz141BUDZykpIpQ6v7zBzUV33PljAa5ykmOdmYhmVqWkLeWsY
5WTGl7g5FFjYwLQjBsPrSnUKBhF9G2KYIxTgIWWv2ry3/QcVNY+ahxoK0pSpjFNd
ttckV/pSRGAM7P3KlWa5VJ39RAE8Bnenr/EsVxJq6ofIoWjMYuv4iME2TMY/SiL+
7Ua3ek5Ci+c0Ckc3fM7d9xqORMf8FBbGmSBPc12ZuMW6WSHx/X6Q+La1slZFSFX0
7LF7qbsJQUrc7d8B6FuoVe1xBXt6cOm+6GeqZYiCNo2zEobr2KZC5cjrETXsy0qu
4aB4rlSl7K/6BeQRWUlE
=OJ2b
-----END PGP SIGNATURE-----

--=-CN7cNWaLe61QOYe9ZrEs--

