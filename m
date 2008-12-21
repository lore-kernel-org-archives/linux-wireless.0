Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYLUK2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 05:28:21 -0500
Subject: new sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Tomas Winkler <tomasw@gmail.com>, Kalle Valo <kalle.valo@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-faQCRTGQFQGYI06NZubb"
Date: Sun, 21 Dec 2008 11:28:15 +0100
Message-Id: <1229855295.4953.0.camel@johannes> (sfid-20081221_112833_601503_A49B0E45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-faQCRTGQFQGYI06NZubb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

These showed up in the nightly pull from yesterday:

> +drivers/net/wireless/iwlwifi/iwl3945-base.c:7436:5: warning: symbol 'iwl=
3945_init_drv' was not declared. Should it be static?
> +drivers/net/wireless/iwlwifi/iwl-3945.c:1325:5: warning: symbol 'iwl3945=
_apm_reset' was not declared. Should it be static?
> +net/mac80211/util.c:355:6: warning: symbol 'ieee80211_wake_queue_by_reas=
on' was not declared. Should it be static?
> +net/mac80211/util.c:385:6: warning: symbol 'ieee80211_stop_queue_by_reas=
on' was not declared. Should it be static?
>=20

--=-faQCRTGQFQGYI06NZubb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJTho8AAoJEKVg1VMiehFYCGwP/24AfUuNxJRtI7drHS+dXAqK
zgDwx82v+77lhimhfAGo7Z7m7IWP7GgfqMf755xpr9KK2Dz36JfsdzeXmRKRUOqT
AkNfQojRedXcV+cpgI5+/6y8w0H+em58IgqgIE0ZvGmkB/J6XPjc7xK3pxlsib5m
KNLWtC8mBZHNiZDMT0pJBmUUwXLiCPoe0Mp0DmmahhPi5TmNXLh3GU5IFzhgE/+L
OySk6aVW+9S4QgIApj7bQjzulVuoXSlOiviai3BG0TBvtJgaGeas1L9m6Drf+BUy
Te0IKG7uumeAV8FQlARS1SpDngNPrr5in8u0M/Xlif5laownekWvef61/I//d4X6
d/ODrvbbngsZ8qYaKoVuqSl8JfaV4izzlp9Y9i9m2h3B3RG/dJj+JhxUcK7sNQRX
B5ZxhbhZ84b/4L7qSOlBeSXmqVz/hvXThlr7BG5joDrxDD0dCL7648jNf2yHXzKZ
c0fOR/owD0Lj44ZOlof+h7zHbZt8LtGBfHBGCYsbrzGHSSkkSXePwEQtnXL5Tj4R
o5vgcX2bVcb4IgZVBahPrgk2PbJX065d35N6JyUqoglEZGex+7yz9TUD3wxRmHOl
WJG89co5DWcse0ui/+OkN6xD3QO4HMfk5Ureb6V7wZyzBL5Xo/mFa6iZEbsqHCtA
0oXinOrtFrf5aQ3fmRp5
=qE9w
-----END PGP SIGNATURE-----

--=-faQCRTGQFQGYI06NZubb--

