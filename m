Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934522Ab3DHLgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 07:36:54 -0400
Message-ID: <1365421010.25475.5.camel@jlt4.sipsolutions.net> (sfid-20130408_133658_219987_0F77F12D)
Subject: pull-request: mac80211 2013-04-08
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Apr 2013 13:36:50 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-t0wMYlVc0kYpC5o8k/kq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t0wMYlVc0kYpC5o8k/kq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

(resend with list CC'ed, oops)

John,

Sadly, I have another pull request -- the idle handling fix broke LED
handling in some cases.

johannes


The following changes since commit 90e0970f8788cef2c8f5183af5a98f4f94600faf=
:

  cfg80211: sched_scan_mtx lock in cfg80211_conn_work() (2013-03-30 22:33:1=
9 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 62a40a15554d6924a58b3e9f8756e0d683dc9c0c:

  mac80211: fix LED in idle handling (2013-04-08 13:12:05 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: fix LED in idle handling

 net/mac80211/iface.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)



--=-t0wMYlVc0kYpC5o8k/kq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRYqvSAAoJEDBSmw7B7bqr/lkP/1gi6p8GFVK7BZ0Oz+4dYncW
z0HgSEDQR7GRCVpXQ19sUFqXq5U/W/xt70qUamAM9hFiiHHx9lNAAhTYbenqYq7g
ztgF08bUmcT3FSKxiQ3iZJ9+ky06VObmEf7Xwi/1o2IX3asNglsGCFCfO+CuC7cn
85BqEc0zHDwTw7nqMK2PG/iaZ55I5BHfVgYuQnQEiQwUxdkeSTX6l49qSSXW5Bg5
5IvCG6BU9xLbEuIXObms9C5EuQS6E+Xq3ttzTMUM9Bd/OuxJarf2xijSEO4xGPjW
XYji5Aoh7Hg7pqNGsQG43aVdthdODSv0MCA7anJj2w9XH4x3DF5YDgvmYm9rk4pK
Kouh9Q87npyBlX+zyA1qItWxFDBiufnRw1Qvb/KZ6p1pa4weJoEKc396kAixdEbE
0LNDgR5OZTpG5D8TzFm4JTZ9xeMnyrK7F28EsVfnj9kmP076DP+TwyTD6g7gwsfa
CO0YTP3L7B9byZsyx8vyc2WKXGJPJBOiE2cmT94Gy6ShMBjk6pK9u1+kgto7UJz1
dw/JQucOpjDnA9osQcbKWPgc78b1fsvBL4lgJlUqdGyZZ1uFLkDq43LaQDAoIPRN
kDvGnjGMSV6DOSoSNCemo/BRPJz62yNOYrwsRnYqTSzH9Ztcz/y68T1ere/1e2d3
wVEol9Co/sNMHs2hFQ6o
=JiUl
-----END PGP SIGNATURE-----

--=-t0wMYlVc0kYpC5o8k/kq--

