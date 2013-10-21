Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3JUNKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 09:10:38 -0400
Message-ID: <1382361031.14310.51.camel@jlt4.sipsolutions.net> (sfid-20131021_151040_383778_47BBD146)
Subject: pull-request: mac80211 2013-10-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Oct 2013 15:10:31 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YoDWc5/cqgrFUAGEeCHn"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YoDWc5/cqgrFUAGEeCHn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Unfortunately we have yet more fixes for mac80211.

I have two DFS fixes (ath9k already supports DFS) and a fix for a
pointer race.

Let me know if there's any problem.

johannes

The following changes since commit 095d81cee742fc31e1218077ca6ca8f0df07c613=
:

  mac80211: disable WMM with invalid parameters (2013-10-17 15:38:22 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to bbe09bbcf4454e826e3fb08e87d81f32c0030658:

  cfg80211: update dfs_state_entered upon dfs_state change (2013-10-21 14:5=
0:27 +0200)

----------------------------------------------------------------
Johannes Berg (1):
      cfg80211: fix scheduled scan pointer access

Michal Kazior (2):
      cfg80211: fix DFS channel recovery timeout
      cfg80211: update dfs_state_entered upon dfs_state change

 net/wireless/mlme.c | 6 ++++--
 net/wireless/scan.c | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)


--=-YoDWc5/cqgrFUAGEeCHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSZSfHAAoJEDBSmw7B7bqrLuYP/0VTSJK+YZY2wqX6OXvTaXZd
tHaXYENv0glI/ruZnrvbCqHasvdGNV5rFeLR680b21jyxZfur5QjZQr3cg9UdTG+
qwTUONUmKWP3ZxaOPwXE9HTNziVC3bgubIhl5A8Ip/g5FLv88Xo5LbEqdGJbaoS7
sHqbayyc8uj8J2uIe5bKkC+9E/Dulm0YBu3H0UHfPYBbEW2nO/o7maA1chEKW30e
xHmig5ZtlTUdG64qwvqlib+pYadXar9jikyuL5bRtmb0vmqcCJgoPO78clnqqolT
XcFTAweCNwBM8UR5IBgAwmRZbj80tio32X+T0bX8eSDn4tXcNhFojk2W6dk8GdKn
4i4dP2n++beIx+yM+jbICQrharAaQ+LqLqyfv2mLtf5bmRfr53aDF4CTOpTfSfj0
EYzjD0xQ0j/HIDo+gCsFlmilWOtyy/s3LOOGdyONU6HNm2aDQjeJIzYah+52o7CK
rXXPh2nUd7rOyXdx24ZgemruP9OsD8oWM9BHwOIt9GU8wOhv9XNGlg7aO7y5LzUC
smTWU7384GouT4OZzjMUVbe54S+1ZEF3fSVngqCMhaKUVjIGMC5wy/BuKI+9uRB9
kUo47DMLHEcYolTfBTVJkZwHmsO5R61zJ/FAtDQyC9JWHpTYjnK50Ncv09atpe9f
McFQexY5TQa8DxwGNX0a
=kUVk
-----END PGP SIGNATURE-----

--=-YoDWc5/cqgrFUAGEeCHn--

