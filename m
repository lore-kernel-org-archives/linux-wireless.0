Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZFCHA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 03:00:59 -0400
Subject: Re: [PATCH] mac80211: check for existance sta before adding it
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890906021401r2200bad9n1ffbe2c56c3a2c22@mail.gmail.com>
References: <1243974603-15058-1-git-send-email-lrodriguez@atheros.com>
	 <1243974947.7176.9.camel@johannes.local>
	 <43e72e890906021401r2200bad9n1ffbe2c56c3a2c22@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-na+46HdUFU4jSI6dozMC"
Date: Wed, 03 Jun 2009 09:00:50 +0200
Message-Id: <1244012450.7176.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-na+46HdUFU4jSI6dozMC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 14:01 -0700, Luis R. Rodriguez wrote:

> Thanks, yeah I see where I was making an incorrect assumption here.
>=20
> There still is a case here where userpsace can try to add a sta twice
> and the second parameters passed would be ignored.

Don't we show that -EEXIST to userspace then? I thought we did.

johannes

--=-na+46HdUFU4jSI6dozMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJh+eAAoJEODzc/N7+QmaYIAQAJr18VB/D/Awc2QgCvr4mhbb
5pQwxbfawmyHkF2k8hxi17s679xY7dY/GikZnmuOaPGgYDeOzgtkZnYL+pSJrLM+
ChVccBJYCzk0/D+DWS1dzk08zP68AVXFX0XLvOOl+Iq59stQuMfL8VPRqexUb4rr
yCYINqvI8FezbaQbnj9QgErWruVIDiyLfovTTkb9Kh6IFPvNkDGuqFTac2Lt/nv1
DuR+EEdrtX7HFuWbNH1NqB5NQtJgAe0roFxzu2qBBcz+8PAWO5GGQrzMCAM+FW6P
N54oSp/+HDtM0t4C/y53DxyAzoA4CYhOM+E8Rx8BOuUvGp6L0yCoeH5V4p2PmSRZ
ygqxTUEL+7ULEvjlKguPia8b1lLTRUKG6eF184H6D9OdrurwOcUXPU1fwjKQMBlV
klvQG2pT6yIdh2tua0icQLv+cQ0/+Mq2ZCshSYK1xSRD1ru4wYv31DyXrhkoa2UH
wFKlOkivo0gzQiAJuhsaWF9M6Xtnk7uS1pPEsk80BRr4nHAs3eB/pgWsM1AdNPpT
YsLNmj7vFccPHCK1x55rlziZ1rhx6zN8gynGPu/Ecshrb4oId9J/YUCKV0/KUssR
GhyVhz3mueRTx01lH68MPlFWYVkhuaW/UehR7b0vMvcnbvdO4TZsHTH4cgkUnQLl
nw+lPTPpRYUaoxl3K9ah
=96dM
-----END PGP SIGNATURE-----

--=-na+46HdUFU4jSI6dozMC--

