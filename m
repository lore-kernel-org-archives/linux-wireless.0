Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYIIKZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 06:25:41 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com> (sfid-20080909_122153_370566_DF11DC5F)
References: <1220883730.31304.60.camel@johannes.berg>
	 <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 <1220954146.31304.127.camel@johannes.berg>
	 <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com>
	 (sfid-20080909_122153_370566_DF11DC5F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qWyuDv7tEf8V8NWHoEFr"
Date: Tue, 09 Sep 2008 12:25:34 +0200
Message-Id: <1220955934.31304.133.camel@johannes.berg> (sfid-20080909_122544_763886_3E25910C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qWyuDv7tEf8V8NWHoEFr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 13:21 +0300, Tomas Winkler wrote:

> > Right. And if mac80211 is the AP, then I don't see how the STA can star=
t
> > aggregation since I couldn't find where the relevant action frames are
> > handled. But you said it's not part of the code now, so I couldn't find
> > it anyway.
>=20
> That's probably the current situation.

So back to square one, where should it be handled? Does it really make
sense to let hostapd have influence over the decision, or should we just
move the code that we have a bit and handle it in the kernel? After all,
we do have all the code necessary to handle it, but it's currently
restricted to STA mode, and I don't see a fundamental reason for that.

johannes

--=-qWyuDv7tEf8V8NWHoEFr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxk8aAAoJEKVg1VMiehFYMsEP/2bKJ9Tvr+IS8k8lB6dF90Er
6T9iTe9icjMqqBETMROmneROx+X4hx4VWiUz12M9rL9ShORASVwcYYiIIcx9pANr
vWmOBeUwunPJ/nNB9dunLADbYA0yPOeSuqPArB/28cAD4GNnT4eFq30AoyLIFYiY
mntqlyTzTvRTqA2m0m1xlheuLlU6YdPbjIrFmpBv6KZUpoZ46j0mdeMJ2l/GRS2v
G83g4Jj//4bohJNJMuebE4BvzmovRIV8klcwZ7oBhlW6pYzAgi9V7m26UP+EmBpT
j9XiP+G3z59S53ve79Fv/hhvXtbhjynyjkXONoKThfj5S8tkoTf9iljC2iH6Pu+g
QbpXuTSwEFQmiDnveSnRCM8rCmYOGZiyN2H6DQWxcC2vK3s1WiDhSqcUevG0s6G+
9Ugv21g1qpWwRIdXV0DYRMo9WguwOUVDHFdQ9kaP1uO35poRwL6PyZr6CGvacGy/
P+ZdTTlLUyO3URFRS7StD7vbye4vhoChHfov7m2ToKSBB9gl1/+86NFfpjfuMwz2
Hl6y7skz7+yow8cMJTGoKKZrIg1qk2In2bUcTBZ0UlTjwpU9Y0XIs2kPgftBSjhp
2ElVmCcq6TA+Kyb/kTRwZSnZ/g0HtZUD84LbtSp+XYAjb7ty3pHVXYLS1tYRFJIk
BLA/kOMiI++4HB+kjE5B
=YLz+
-----END PGP SIGNATURE-----

--=-qWyuDv7tEf8V8NWHoEFr--

