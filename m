Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934837Ab3FSQfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 12:35:09 -0400
Message-ID: <1371659691.8349.24.camel@jlt4.sipsolutions.net> (sfid-20130619_183519_304352_89CDE6A9)
Subject: pull-request: mac80211 2013-06-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 18:34:51 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-M/wBIF8bFvaJfaqt5p+2"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M/wBIF8bFvaJfaqt5p+2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

One more ...

This is just the fix for the nl80211_fam.attrbuf race Linus ran into and
analysed.

johannes

The following changes since commit 795d855d56c6d172f50a974f603ba923ac93ee76=
:

  mac80211: Fix rate control mask matching call (2013-06-12 09:12:43 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 3a5a423bb958ad22eeccca66c533e85bf69ba10e:

  nl80211: fix attrbuf access race by allocating a separate one (2013-06-19=
 18:31:20 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      nl80211: fix attrbuf access race by allocating a separate one

 net/wireless/nl80211.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


--=-M/wBIF8bFvaJfaqt5p+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRwd2rAAoJEDBSmw7B7bqr9gAP/0FC9/vWL2QoBYIlFEBvZPkb
yERsG98Qt+8F03NGyg+w4LwA0GJ7JHLvbQ9cXYHeOYGo6C5tpLMXRchoT8iArcgP
bgOEKS1BaStnNG3HBOg+g3G+Z2RBj7VThI4LTj64BPqDwTU0C3eE0t8CSWSNPfD+
n7feht0r96flSkvUzgWfbSk1yby1ljXiGdMZnR1mGHPYUv5teKzm/g2rqFH8tOVN
NGExbfrM0oZCorjaVbHCxaqjPU29rdNVWZr4FpYm4fxo1xalP1N80qOcUpXhSp3M
/mwAOohBIEocAhFU7XWNKfKR8tvlaFGVyFVd58YRLNtgGzOP6x3BgJJr9PNepqm3
6YTBZZjcu8Q1ZVpgL/oHU37Hncyb6lV/cbzItNDX3Ov4FBmGpFwggpu/V6PDK4Gs
+rICotg0bbeoo2/hfJlinFi1Vj+WPKyDL6Qr+zzMKL+L1jx0VJ7AhuZT74E6bUgL
SpY9A9I938TeBki0DlzcPf/jWWM3k7yHRJcW6fgTkYBeDNJv4cnppHwmePzuFPZE
9zWDmHtYaLYKLMLq2Qlvl6VwKtklV2AV/t3fryMEHgGBZ08LdCqwgKuKQMtYIygA
FQxXW1N9cPKAzioUgtPJfgDShEbyEQbkOjqXTSIZ+ZH0w5xVFhksCtoKr23yqGkY
YwpXgp40FNSMig/vYvhF
=7fP9
-----END PGP SIGNATURE-----

--=-M/wBIF8bFvaJfaqt5p+2--

