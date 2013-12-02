Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39596 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3LBQI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 11:08:57 -0500
Message-ID: <1386000525.20277.8.camel@jlt4.sipsolutions.net> (sfid-20131202_170910_262302_6BD9B5CD)
Subject: pull-request: mac80211 2013-12-01
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 02 Dec 2013 17:08:45 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-73NQRqTmBIImJYnFwQ7k"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-73NQRqTmBIImJYnFwQ7k
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Another pull request for 3.13.

These are just two patches disabling the broken CSA code. Once this goes
into your tree I'll merge it into mac80211-next and revert there (since
we fixed the bugs there)

johannes

The following changes since commit 24d47300d118c5909a51b7270276d749cce150a2=
:

  mac80211: set hw initial idle state (2013-11-25 16:56:54 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 0834ae3c3af44480834cce128b6fef83006e537f:

  mac80211: check csa wiphy flag in ibss before switching (2013-12-02 11:54=
:13 +0100)

----------------------------------------------------------------
Simon Wunderlich (2):
      cfg80211: disable CSA for all drivers
      mac80211: check csa wiphy flag in ibss before switching

 net/mac80211/ibss.c | 4 ++++
 net/wireless/core.c | 6 ++++++
 2 files changed, 10 insertions(+)


--=-73NQRqTmBIImJYnFwQ7k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSnLCNAAoJEDBSmw7B7bqrb/gP/1kXTVKoSL8IKfeG6orzhN3Y
xg5KoHyY25+V7/zVayRib/ehjN8eQDLQHlqjEkz62ptMy8qNjUVEyE5BOtQbizyk
+bXJNkRCHGxNnoy20TdV+G63ZosylGdk//9dgMpZIkjkDoGSwWXebPwGBQcFi2JV
5gXi3hH2ulea6Lnvsajhnq2q7LyBqMf3J9XYybIe7WNpogfdppkHVqIK+nI/5cp0
gvAjLiejMQxudF9T8FcU/k/Lof5F0MeCGP8/tvgqAfd2kfK7/Hv7j6wwMjIayjRW
ZLmhNw+UXTw4JDjKSaX8uwzeC4WVh4QeKVNuV3WYmyWmbGFtbkQeRnCkE9Nw59dq
kMXXO1iWnHLIg19PYDaYVas2Ka5krrz92lYsEZ+LGsn/PRUXf8jOvhvgssnGO7H9
6aj3JiCO8IsXv0fNqgc4hYkgP+N+CpBGwfhKxQQaHbSPpWzRVBdfwYQzDbxYxfBN
yWOx8+WKoK46y7FVn0ns1cPMXXvOtCm9fTMsI8R7i+YTxvsYKD2bN4cvqlGrtFbi
r+HXS0+3l/RDCZsnlcig31ShQvKi+aEImRNHPGuqIGL3Q9MJnmSAVISPnOHSbiJz
xB0f8CH+Eq6tD9kW+CnmrSO82pFwJ6AL5mII98gKcYuz0T3joBk+pSge/vZn+fBT
NlCtR0N5ijiEuIp3qS7N
=cwx6
-----END PGP SIGNATURE-----

--=-73NQRqTmBIImJYnFwQ7k--

