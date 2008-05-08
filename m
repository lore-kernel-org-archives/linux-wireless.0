Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbYEHOu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 10:50:27 -0400
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805081657.27976.IvDoorn@gmail.com> (sfid-20080508_164750_779668_AD4AA865)
References: <200805081503.41025.IvDoorn@gmail.com>
	 <1210257820.3547.50.camel@johannes.berg>
	 <200805081657.27976.IvDoorn@gmail.com>
	 (sfid-20080508_164750_779668_AD4AA865)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NL0Nj2cdUj7ZUuAz/yfC"
Date: Thu, 08 May 2008 16:50:16 +0200
Message-Id: <1210258216.3547.56.camel@johannes.berg> (sfid-20080508_164925_816325_F5276A53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NL0Nj2cdUj7ZUuAz/yfC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> No I haven't, I had been compiling mac80211 with VERBOSE_DEBUG on ever
> since I added the patches from your tree to rt2x00.git so I never noticed=
 this
> bug. I just received the bugreport from somebody at the rt2x00 forum. :)

Then somebody else told me. Or I found it in your tree :)

> Since rt2x00.git contains your patches from a week ago, I did check if th=
e
> bug was still present in your latest version.
> Anyway the important thing is that you have the fix. ;)

Right :) I'm pretty much done with the skb->cb conversion too except for
ath5k (nick) and rt2x00 (you)

johannes

--=-NL0Nj2cdUj7ZUuAz/yfC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCMTJ6Vg1VMiehFYAQKEIQ/+MPkzLlEglvKyoD2hECt+XXP6k9PUEgNR
tYwUPxx5kp/bhzIHRqWXWKHAPpGkSfRO0NDbjeIcV71lgjnqCg5rGiuG6ohuzWIa
wYabOnbLq+kdBPDTbMP0xhrdeZtmnfwDULR5jZE6oVO5ebP9eLIN985jwvJ1ZdYu
4hoKq98bpY7DOKLZ4sgtvSAUsn+2BvZdWnMtDtD4dUZ6UD56JiW9EWzGIfLDzCzQ
UwwlyAV3q+KM6OkYDx0nAUbzwPXjitqLEEuxXYloJmiKHt2HlTbru/G1emeFRRB6
KGxga/ivkwvS5Rhzcadf+XGJoo/ViXagJ1Nx7NwqRleTFmOBYTugNrSt+4AnSyzp
lKo1jyMUbSfzGvRZGzVMd/bTJuOCrsfWM5p//Z9F8RVYnFepQbIqY9LGWZSj3LUS
bTVgxxD/BQ6d8isxwK7eWaqt7KV3jYLf5lKw3ck3eESy4AYkGTPQyD52Bd7HOY1U
aNmU11u7zpu0t7nwoi+swjKXAe57VNL24QrTSiQMItL2H9+IE69/7K3+WxiE/2KC
Ytw50X5iE4uWJrwgk9N7umonpAOlHQyz7lsbvC9Xm/y1qb05gcD2LrN4N0ZbRqan
hEH0yrjz6gOLsLHodyqNr1nfc3qAZN3rp7deDzMHVJMK+A9payhCkrB3ptqJR2lL
WhlzpJbavqU=
=K4fn
-----END PGP SIGNATURE-----

--=-NL0Nj2cdUj7ZUuAz/yfC--

