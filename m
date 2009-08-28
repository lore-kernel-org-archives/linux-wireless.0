Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZH1JKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:10:37 -0400
Subject: Re: [PATCH 13/13] wl1271: added Juuso Oikarinen as module author
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D-MSW/Tampere)" <juuso.oikarinen@nokia.com>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>
In-Reply-To: <4A979D06.2000205@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
	 <1251406807-31495-14-git-send-email-luciano.coelho@nokia.com>
	 <1251408741.22482.14.camel@johannes.local>  <4A979D06.2000205@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X6Dt1YiXqWGexxcQOLOX"
Date: Fri, 28 Aug 2009 11:10:04 +0200
Message-Id: <1251450604.3456.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X6Dt1YiXqWGexxcQOLOX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-28 at 12:01 +0300, Luciano Coelho wrote:

> Is that the right way to do it? At least in include/linux/module.h it=20
> says this:
>=20
> /* Author, ideally of form NAME[, NAME]*[ and NAME] */
> #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

Interesting, but I suspect that should just be changed.

If you use multiple MODULE_AUTHOR, they will be shown as such:

$ /sbin/modinfo ar9170usb | grep author
author:         Christian Lamparter <chunkeey@web.de>
author:         Johannes Berg <johannes@sipsolutions.net>


If you use just one, it would be one long author: line with all of them.
I think the multiple line case is much nicer.

johannes

--=-X6Dt1YiXqWGexxcQOLOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKl57oAAoJEODzc/N7+Qma8tMQAKt4keCrwZU7N4g78b+ud6Lb
YlAdgot866Vw6E12BJ95GI/AQyw0lApFfoYR6AtR4voC4hCbZxmlwhBBH0WlfP0J
EtARpJI3W5y+IykpeRL4fJLHqZ6gIgaTmKitqId/t0Qnpd3bUWFacHzcIQAobMzw
Tq2Uugjx4l3NiOEYSqgxNkLQLMo8AQ3e/UXvGUzSs/QhX8LMHVUxB+pzPAhmwrwf
DWjfztvWpcr9V8D4e/wyf5NzU7JM2sN9YqRW7Xn9F8htVMB8D2r+83FzVtZWbj97
5NlnFt5UO8RhvvISsg9v5LvFUGQ2Y4JFpR972J0iXiD3paNmVI50CNZIbnPvLgDK
0yt4rNQxIACkC6AfUCr8K61Pqx4R8WZu4YGa49ZI0d01HVpBGLbL7BmJ4vdJ8Ndg
oICXuyvebuAE3WdXJX9c3om9Im8OUh15L2l2aOGMomrChiBEcCA7gbPGeuvqSpzc
9U/m+9ur+T55is5skmZ1FObDKDTWlsI9pGTHexuGjkd5i2pOHzFhyR8Fc/Js0szR
pwTYIbTxOGkQChTk8IeaVfcQd6XjVW4pbXXFUle77NXgIqBcYj6nrmdfhnCdQd2q
aFQxFNB3G1wwSIcERdSUoDCUCpg7VCVG6TD3I2pJwBs3JeXvnmbz9nlbDExGxijw
WDcIxRStpEeuk49lpvF/
=8Luv
-----END PGP SIGNATURE-----

--=-X6Dt1YiXqWGexxcQOLOX--

