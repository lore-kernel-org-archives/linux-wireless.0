Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZCUPJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 11:09:23 -0400
Subject: Re: [RFC][RFT][PATCH 0/5 v5] ar9170: ar9170 driver (aka mac80211's
 otus)
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org,
	otus-devel@lists.madwifi-project.org, greg@kroah.com,
	linville@tuxdriver.com, lrodriguez@atheros.com
In-Reply-To: <20090321145933.102650@gmx.net> (sfid-20090321_160004_602859_A9B03B14)
References: <200903170408.12626.chunkeey@web.de>
	 <200903202036.09255.chunkeey@web.de> <20090320200736.261050@gmx.net>
	 <200903202159.41613.chunkeey@web.de> <20090320230448.261020@gmx.net>
	 <20090321145933.102650@gmx.net> (sfid-20090321_160004_602859_A9B03B14)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VvfXVw5xSgb659gCxVHu"
Date: Sat, 21 Mar 2009 16:09:19 +0100
Message-Id: <1237648159.5100.218.camel@johannes.local> (sfid-20090321_160926_983137_C6877A5A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VvfXVw5xSgb659gCxVHu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 15:59 +0100, Alina Friedrichsen wrote:
> Hello Christian,
>=20
> your new code is not compatible with compat-wireless. The function
> usb_poison_anchored_urbs() is missing in the 2.6.27 kernel.

That's something compat has to fix then -- we don't impose any backward
compatibility rules for the kernel code.

johannes

--=-VvfXVw5xSgb659gCxVHu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxQMYAAoJEKVg1VMiehFY/f4QAIiENMf66M+vVApPulOrP9SN
sZUTHJ+xDe73rUc+Y7f4YN9AYrrP+bfZgU4+NhzfIlyhl3GlzY8kqfXTSVba0mAX
qfm+QLYBr0iz7936IL9z+DdqSvDS3Aten0k6ATS1kiWJ+cQsxBrshhpnbdKch6bW
gpFwWZ4xU7vFhmdKujhJNDjwn3nj/YNY7ciwV6xglQ115pgVFnHvqra470+8p0Vm
ZQSoi9+sPN7ORd2/dBVTUVqVC1+CSrdh5yk3pTQsNxKua+Z/BBHW5/CM+9BhwMjg
hpxUlvF7MpoL4zYfzPzSYBXybsKZRaXLS2sbkuikxO1zsRdIvKbOMniO6yqIHs1c
exR2NxIpvehWsOMkMiEzj0EVXgVkzhA2d9syDuEiOHlUlgQUel+mTkCw2qtffEnh
aEbhq/O7OPUjVa3DNlO5gqT4FcCMhQZ5FFji4im5JW90BLKSsbXMzQxKHKlwgZZe
+P3GzGit2P7FIUVOLmQCavmbiUZ6nc4/AbM2uuqbEo1Rz9Hw2PgX1IHuFI5jWDRO
lo1+cHvrE8XaMzA1GwvCVEI4vQDGm/g9xTEFBtHwfrGDdGwR+38sPBeC2huFJ0Xn
BoaY/jyf6liUbFMkc/qD7rJk9Vn36nLA38E5PW3Bo7h7twNPFnAt9HIwklAH637q
8EyJbNlXdp0cJgt84t1u
=aRiJ
-----END PGP SIGNATURE-----

--=-VvfXVw5xSgb659gCxVHu--

