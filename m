Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbZEBVO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 17:14:56 -0400
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Alf <alf@mypals.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200905021218.23747.alf@mypals.org>
References: <200905021218.23747.alf@mypals.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PJlf3cXrZh75GemfnaRS"
Date: Sat, 02 May 2009 23:14:54 +0200
Message-Id: <1241298894.13562.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PJlf3cXrZh75GemfnaRS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-02 at 12:18 -0600, Alf wrote:

> It seems I am able to associate with an AP (not just my AP) sporadically.=
 =20
> It seems that when it works, it works reliably, but that's only 10% of th=
e=20
> time, if that.  I have turned on debugging on ath5 and on mac80211 but th=
e=20
> debug messages don't offer anything useful.  The only thing I get is this=
:
>=20
> May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
> May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
> May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
> May  2 12:08:20 wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out
> May  2 12:08:28 wlan0 direct probe responded

What kernel are you using?

johannes

--=-PJlf3cXrZh75GemfnaRS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/LfMAAoJEKVg1VMiehFYbnAP/Rt1//ZI0bpRKluzGIHGvsKI
luEMSXCrrwSgJn56PYzMZ47DJrAkWV15ZOBOGTTaHpP8ZM7bhEkUrpBU5/2ptyXm
tv+Ix1OeWqFr2xvEfhmJSgVLgjJ4SrBnll1RVFWZYPK6IuuZJPH2lT2zxDAwCBV1
EYcAn/ZOcvhS6+0X0bJEajcqZiY1sJoJ0G8UXEZI6ueKOiWBYN9+7Y/m6/6cUUad
k9ZadvH0RFdqtQ6iIdsLUSLroUzsBbhBAYH17UhRlONf/R3NQEAJ/Lw+anHNhMHA
fHHHgnYSWJaQF6Vz6/SilQdlL2SKEQpyOBPdMnZ0t5AV4fhY2b2kjJMY3mraLLYo
roiV0t1gUgQHdSk1E3tu2YzFS7QLRH0nzsCa9M9cyauNQwVDSeI94+P+HESji9QS
+2A0vgA3T3/1KT1oCg7ejJtdoV623BfemiHhtsYWl1x7Ahf6Bfqmo+IilCV/XHF3
X6Ph7edBv1xn1Y+e9OQ58onbRKRiIzSzw04EFc/JWJ5mnDX3b76RFwqtCEmSeq/4
TzEFPBndGgwq0yZfWd1oiOhAKtvOuar4yPslKQSxWIDFyF75WpPtiPlgvxfouIiX
JfmH8aTpZ0TUrtuwyy93cqY0ilqe1emeRh0oNwLM85bcDcAkcd09Lkr0RxcOvB4c
JWLcQeg+1TvwcwQjxzPL
=jpuH
-----END PGP SIGNATURE-----

--=-PJlf3cXrZh75GemfnaRS--

