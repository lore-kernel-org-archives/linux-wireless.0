Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761791AbYBCMig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 07:38:36 -0500
Subject: Re: [PATCH] wireless: Fix WARN_ON() with ieee802.11b
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200802031221.28432.IvDoorn@gmail.com> (sfid-20080203_112200_987671_49ED46D1)
References: <200802022353.10286.IvDoorn@gmail.com>
	 <1202034082.4188.116.camel@johannes.berg>
	 <200802031221.28432.IvDoorn@gmail.com>
	 (sfid-20080203_112200_987671_49ED46D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Gl4VmNWTEic5e3vd6gF+"
Date: Sun, 03 Feb 2008 13:38:29 +0100
Message-Id: <1202042309.4188.120.camel@johannes.berg> (sfid-20080203_123839_960097_6C1AAE31)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gl4VmNWTEic5e3vd6gF+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well from your code it seemed that you only made 1Mbit mandatory for
> 802.11b. So if you want to make all b rates mandatory then the 6 check sh=
ould
> indeed be removed.
> But shouldn't the 2Mbit, 5.5Mbit and 11Mbit set as IEEE80211_RATE_MANDATO=
RY_B
> as well?

Ah, right, no, those aren't mandatory afaict so your patch is correct.
This is only a fairly lax sanity check anyway.

johannes

--=-Gl4VmNWTEic5e3vd6gF+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6W1xKVg1VMiehFYAQKWmBAAsDFlI8dUzLsR+9p9p5v2jPrqDVtWfLoF
mVuj3a7P4mSD+zNDIvT5kYY3azbsRPklyOJs5fDDEsyy8wxFoxYRUsGk9UtIQfI2
KCWWgdrXlWTz73y6ivcgK7pNIlpQVM6NHKaFVVbY/NIwVdRK1hN+qYJYDA2R6qfv
HhtvviGCh5diBm6jdZG8u5KkHnj60Sh2oqwzhZURM/lVdxAhXbLbsmqaB/nw5UoF
H6nQmcpG89lAwCbsxdrES5qeS8rGCa4mAcJ0hdcjLHtNK4HE1pB7IqnSuVp1OCeS
2UW1NnqFZdCOjwt653uAGgXhKCY5N+PeHk0bSk3sIWDv+JQxRvK3UUm0X7Ht/V04
ITqxEQQNdIl5r7IqMXtIB1fPVhCCcv2GNX2vtFFURIxjVnI5Tat1v441Llit6aDi
pmZ2GUaO1LYyJCktAeQ0jVYUx4Kf4gGn0o277HRk2XOWegTOru4T9LTtNnGvrXO/
4UfWbI3xQ02rGLjUps4JZ7IqLeJ1FMdxYyE680e+HwxL6lNDAK1uQQyd0PHjHV2P
FH4sacdIg05gEldH9MRipGU1WGSNok2wMo2rZF1bjEs7sPyo0DAixq9l/6Z3ZFrQ
28YWhWnBEC3tX3H0rqEOxMvHtRyxen81vCTKf/JrNztnaCUBbvNjUMmTCLEkR8i+
X0rEXuQmf4g=
=8QNF
-----END PGP SIGNATURE-----

--=-Gl4VmNWTEic5e3vd6gF+--

