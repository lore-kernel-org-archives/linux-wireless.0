Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3GVL6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 07:58:54 -0400
Message-ID: <1374494325.14517.4.camel@jlt4.sipsolutions.net> (sfid-20130722_135858_034624_52BA3388)
Subject: pull-request: 2013-07-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Jul 2013 13:58:45 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Vl5v5Id5/n4HIpq02bIV"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Vl5v5Id5/n4HIpq02bIV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's a pull request for 3.11 (and some fixes with cc stable), sorry
for the delay - I was travelling.

Here I have a fix for RSSI thresholds in mesh, two minstrel fixes from
Felix, an nl80211 fix from Michal and four various fixes I did myself.

Let me know if there's any problem.

johannes



The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092=
:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 5c9fc93bc9bc417418fc1b6366833ae6a07b804d:

  mac80211/minstrel: fix NULL pointer dereference issue (2013-07-16 17:48:1=
4 +0300)

----------------------------------------------------------------
Chun-Yeow Yeoh (1):
      nl80211: fix the setting of RSSI threshold value for mesh

Felix Fietkau (2):
      mac80211/minstrel_ht: fix cck rate sampling
      mac80211/minstrel: fix NULL pointer dereference issue

Johannes Berg (4):
      cfg80211: fix bugs in new SME implementation
      regulatory: add missing rtnl locking
      mac80211: fix ethtool stats for non-station interfaces
      mac80211: fix duplicate retransmission detection

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

 net/mac80211/cfg.c                 |  2 ++
 net/mac80211/rc80211_minstrel.c    |  3 ++-
 net/mac80211/rc80211_minstrel_ht.c | 10 +++++++++-
 net/mac80211/rx.c                  | 10 ++++++++--
 net/wireless/nl80211.c             | 11 +++++++----
 net/wireless/reg.c                 |  2 ++
 net/wireless/sme.c                 | 29 ++++++++++++++++++++++++++---
 7 files changed, 56 insertions(+), 11 deletions(-)


--=-Vl5v5Id5/n4HIpq02bIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR7R51AAoJEDBSmw7B7bqrIYAQAMslpnGBYD46ZiLsfbVt6REK
To/sWKScL2nJesHSomO5AlIJ7mqufJf8QcQ16eQA7X+OGOnhQNfdCDxdMUk0+e2Z
f59GYNKZzbUmkFETHhWlndRowS+TjZzrFDO/u3NAy2UB9Fs4c44kD/OlkczApxmS
YrTWdU5T1aPaTv1v894ePpEshXyFg8WDceFzh7UvJb2c9vw6tM2l0wWcUI/fo4Xx
RspSSqQIWlUvo7Mh0rG16mdRwaWWfdinX+XP1SxQXuc/7V0tfix6obieRC2vHN79
z6lE7SfmBGk7ZeVdsSJ1QyaC+r+NjygvolFAAa4kmaiuCVAzpN+3Z4TM5PpXX5B3
Zl7fmX2otnxS0ieCqVzL7XsabgHGPKTgr1rkMZNg33b/8snR2DrHRwl6JwVNgDPj
NDmJlwiBI2V2DXx2vUkhFZNmlgI8o5LGe5YMo8KUVltlr+dH0HJnFKTaVltjSutg
RbC2BYRKZvaBbs6nb6ELFvmP4TQbbBFKHDQNQZ8Oud70CrkEm6NFRIC0EHt/cPpG
mH7TGeezHL9bcml871ABvHnbaATY1/iH4ZqCoIf62tX5/MhuIVo/NlRa2nczNWtm
ZFYMPR6j9Q/35dQoqlu6lPk0V5ToEvvCkXWjDcsoOVz6NQ2ytib6AgW1sgIDPYj8
mBHCOnV1J9aUujonAgBR
=8dYU
-----END PGP SIGNATURE-----

--=-Vl5v5Id5/n4HIpq02bIV--

