Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53789 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbaGVVgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 17:36:42 -0400
Message-ID: <1406064989.32255.39.camel@jlt4.sipsolutions.net> (sfid-20140722_233645_414326_F45F64C7)
Subject: pull-request: mac80211 2014-07-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 22 Jul 2014 23:36:29 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-BYV6dY/gu/3MaM5BQojv"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BYV6dY/gu/3MaM5BQojv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

One more fix - for a bug in the newly introduced code that obtains rate
control information for stations.

It would be good to get this in, otherwise we'd probably have to send it
to stable.

johannes

The following changes since commit 8c26d458394be44e135d1c6bd4557e1c4e1a0535=
:

  cfg80211: fix mic_failure tracing (2014-07-18 09:53:56 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to fa8f136fe9a8fbdcb11a1db94f30146cae6d8777:

  mac80211: fix crash on getting sta info with uninitialized rate control (=
2014-07-22 22:17:17 +0200)

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: fix crash on getting sta info with uninitialized rate contr=
ol

 net/mac80211/cfg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


--=-BYV6dY/gu/3MaM5BQojv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTztldAAoJEDBSmw7B7bqr4/4P/A+UwMaSTtAtXKWEDc1VQjRT
EWm6x5jVGsEZzU4KLCSXrFhKPBwnJFJ3v3OHrc6uJlYMFb94WYbsg4yIA5Yl7Yok
60eR54Q4xYFDUlHNyJsD9KDYwovx2yu0qrhC+Ce6rWXOmX6GgfYwT8Rk+PnAoazY
PNFOr7X4dixJLXdhQHU9rmlBJNE0DkR8NGcXjbUUnkERU2WKazCGaALRUw+4d+EZ
/o1w0YUv/QRvGFzvYpf+W3RP3I54WTVvQrBt2lBAioZ8I8FyRmuy1qR+Y01D+y3N
XpJ1P8Dd/OXfsoZfSq5eNKk99RTbKX8t1y2V+Mq4se0hPWaAqgbY3C095gb2Rtmr
bxyIZcmydkK8iCUKNpjiGjWAE0tm0V2LDtcPCp6Xw/dc/YOSfoDV29y8SEAuATBt
kTQIGx9uXpVfYbrL1IRqgJdUJi1v0T0TDEeTe3ZGWOwiX0Ponek4vUvRbDLCM9ws
7O1Gflih5p5e0GIzStqzKyD9k4USCshp1fJDl+DyX24fYHWaQApZ+qTHIZsTWJOB
Zp0F4p5BmRvOCBP2G5qeE99JclFscY20pgfENvp/Dbo9muUFpIwHsythn/9lM7uT
r6Dj2rXHUBJhAM+cgFS52eQW77M+iJ3Mlt0RBvUPtDriXUYe0gtLzNEYr640gC5T
a6kaWNretbAI199AKTns
=Jojy
-----END PGP SIGNATURE-----

--=-BYV6dY/gu/3MaM5BQojv--

