Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab2LJV6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:58:30 -0500
Message-ID: <1355176729.8083.22.camel@jlt4.sipsolutions.net> (sfid-20121210_225833_746338_E962EA8C)
Subject: pull-request: mac80211-next 2012-12-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:58:49 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-3eHJiuBk0szhntDJTm9e"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3eHJiuBk0szhntDJTm9e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull my mac80211-next tree to get a few updates: I mostly have
fixes for code that's currently in the -next trees, but there are still
a few improvements as well.

johannes


The following changes since commit da29d2a5780d80857773d7776b7603a449b0b6e0=
:

  cfg80211: fix channel error on mesh join (2012-12-03 11:24:49 +0100)

are available in the git repository at:

  git://git.sipsolutions.net/mac80211-next.git for-john

for you to fetch changes up to 8acbcddb5fb3a1dc081defe51b6ac42a7ab0b398:

  minstrel: update stats after processing status (2012-12-10 22:51:50 +0100=
)

----------------------------------------------------------------
Chaitanya (1):
      mac80211: warn only once if ampdu_action isn't assigned

Helmut Schaa (1):
      mac80211: skip radiotap space calculation if no monitor exists

Johannes Berg (6):
      cfg80211: check no-OFDM flag for channels wider than 20 MHz
      wireless: fix VHT max AMPDU exponent definition
      mac80211: cancel work instead of waiting for it to do nothing
      wext: explicitly cast -110 to u8
      mac80211: a few whitespace fixes
      minstrel: update stats after processing status

Marco Porsch (1):
      mac80211: don't drop mesh peering frames from unknown STA

Saravana (1):
      mac80211: add debug file for mic failure

Simon Wunderlich (1):
      mac80211: adapt slot time in IBSS mode

Stanislaw Gruszka (2):
      mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
      Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe=
 fails"

 drivers/net/wireless/mac80211_hwsim.c   |  2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |  3 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |  7 ++---
 include/linux/ieee80211.h               | 54 +++++++++++++++++------------=
----
 include/net/mac80211.h                  |  5 +++
 net/mac80211/agg-tx.c                   |  2 +-
 net/mac80211/debugfs_key.c              | 17 +++++++++++
 net/mac80211/ibss.c                     | 14 +++++++++
 net/mac80211/iface.c                    |  2 +-
 net/mac80211/key.h                      |  3 ++
 net/mac80211/mlme.c                     |  4 +--
 net/mac80211/rc80211_minstrel.c         |  9 +++---
 net/mac80211/rx.c                       |  9 +++---
 net/mac80211/scan.c                     |  2 +-
 net/mac80211/status.c                   |  6 +++-
 net/mac80211/wpa.c                      |  5 ++-
 net/wireless/chan.c                     |  3 ++
 net/wireless/wext-compat.c              |  2 +-
 18 files changed, 101 insertions(+), 48 deletions(-)


--=-3eHJiuBk0szhntDJTm9e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQxlsZAAoJEDBSmw7B7bqrszEQAKoqrVwzfQDS9U7eIQ0wyrMW
9lK/Rw71Sl9ZrZCIwLLSrhGzQ77iEE5VMiiDSwYUd7ehBiOhKIMlNNP780x7O2D1
EOyh5F3MBkSn8NXh1RbQ3R6O1Uq0kM/xSv3HiWIi0pd/bk9nr1jvVzO3sYeCbJem
Tt7VA1vgbjuuL83MzjeW6bsg1MgcArC7b3iLfCohuzvd9JIzIfEHR0y6gPf5nLz3
Pz9Pg3+CCMPVln3cyVwDgF7fVL2hH5uY8HS8kyXbzNyS4Fs9RzXOPO/p8hGS7Qn0
Smo0acfea1YomsYRlkKqX2g35NovWcaemlzWlMprWp+jdG6UHWVTuYFoI2ufz+Ud
JZgTm4vazJPzxOluGHiwDMweof4aFj6tgH4LGfrWSatqw5rBQywCWo5vSVfkBF10
R0KM9+lKcXcQv8cDzkF/aUUKAZWE4piK4jyTx/TP6ewSVicdE1nDj6YStsqICSIj
oCONB8boDTSGP6t4U/LW6RNaZg7LC5w26cstreQb6biHhraXL1IC+RIanpRLfqPL
O5wYDJ3DG3haqAQWVoaiCqgyj2ORwncfXkS0gY8GoYZ6sHeJMS2ILktjo49A+Exe
qCdfI/zlEfHxG1MhxCqWG8iZdJN0Yj2DTubgChFuJdoUYZd3vg0cP68bgQZ52TFP
2uVzEGxX5MCGEcTpFVPv
=5b1y
-----END PGP SIGNATURE-----

--=-3eHJiuBk0szhntDJTm9e--

