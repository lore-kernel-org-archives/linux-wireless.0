Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYEJQWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 12:22:50 -0400
Subject: Re: [PATCH 2/5] mac80211: Initialize sta pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805101350.43435.IvDoorn@gmail.com> (sfid-20080510_141037_403869_ADA86AE6)
References: <200805101349.19481.IvDoorn@gmail.com>
	 <200805101350.43435.IvDoorn@gmail.com>
	 (sfid-20080510_141037_403869_ADA86AE6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X6cNpQ8ZRIEHkNqfHSBP"
Date: Sat, 10 May 2008 18:22:39 +0200
Message-Id: <1210436559.12837.7.camel@johannes.berg> (sfid-20080510_182253_009349_B67E9F9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X6cNpQ8ZRIEHkNqfHSBP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-05-10 at 13:50 +0200, Ivo van Doorn wrote:
> patch: mac80211: rewrite fragmentation code
> introduced the following compile warning:
>=20
> net/mac80211/tx.c: In function 'ieee80211_master_start_xmit':
> net/mac80211/tx.c:1244: warning: 'sta' may be used uninitialized in this =
function
>=20
> sta is allowed to be NULL throughout the rest of the function,
> so we best initialize it to NULL.

Thanks. Not sure what's wrong with my compiler :) I'm still working on
this patch and it probably won't go into the tree in it's current form
since Herbert Xu had reservations.

johannes

--=-X6cNpQ8ZRIEHkNqfHSBP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCXLzqVg1VMiehFYAQI31RAAp58rg27KS71ElepczFyR2BYdQhe49ScD
oCPwi+iO9WeKTgy0vQP+O2V13yZGt0WndZ/J4N2XD8GqVaxqJLMrUhvGbYFD7LON
z98+X/3xUO1ZjtBRJxzU7J67Z93kUPgQiypvpFB8W7hdh8Vemk/NE2E7uW3GuyeF
oLWIppd0/DioqY4uQ2O/dEABb90c3uJKmDcfCB0wMkGll7vIfpzPM3KazLrfBRoc
nY9o7ezvql0sgkrC7Y+UUqKz1epGoB2DJFIsZ6mRRssNI/A0GYZobRzbMmRnl7ig
uOzh5r6TFWj0CsyUyIhjucYLfx39V2j/hg/x7A0J9SJ/XVJDcVHyCzevd9XQJR2j
0pxtYsR5locOMY99Qi1KVu/9bLVc+N3M294JmZAQop1J0/eWs/GTUT9d537u5m1f
eKHnni6X540BWFuxx7V6xG8sB5loVngPrx7igSQSDpeafuElnIampSkPjIaTbWuv
mMW+LquNziU233EOSbocCj1rtItUzWA2ywKecdeXNYPpxDz/UTfS5PKsjmVv4KjI
XKSW8yHqhCSlbqQuptpB+cfFgK6vT1wNVrev3609T+1lfXE0pCLgQB+P4sy+JSQG
qsMC4FrvYEf3LJGrwfu9LuoOcDqaXfFeEsfC3s/EUTw231LEE8/5XuyPPcOHnHk/
TDqCsCGLpsw=
=8o83
-----END PGP SIGNATURE-----

--=-X6cNpQ8ZRIEHkNqfHSBP--

