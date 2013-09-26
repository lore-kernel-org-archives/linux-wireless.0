Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3IZSNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 14:13:49 -0400
Message-ID: <1380219220.4592.17.camel@jlt4.sipsolutions.net> (sfid-20130926_201352_821633_CDB53198)
Subject: pull-request: mac80211 2013-09-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 20:13:40 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XGD9Q+i157o9/Sl2RX6j"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XGD9Q+i157o9/Sl2RX6j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here's a pull request for fixes. I've gotten a bit (more) sick and won't
be preparing a -next pull request this week, most likely, I have a bunch
of things to merge for that first.

This time I have two fixes for IBSS (including one for wext, hah), a fix
for extended rates IEs, an active monitor checking fix and a sysfs
registration race fix.

johannes

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f=
:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to aa5f66d5a1df1c2b04bccdcb19711675c765d7c4:

  cfg80211: fix sysfs registration race (2013-09-26 20:03:45 +0200)

----------------------------------------------------------------
Bruno Randolf (1):
      cfg80211: fix warning when using WEXT for IBSS

Chun-Yeow Yeoh (1):
      mac80211: fix the setting of extended supported rate IE

Felix Fietkau (1):
      mac80211: drop spoofed packets in ad-hoc mode

Johannes Berg (1):
      cfg80211: fix sysfs registration race

Luciano Coelho (1):
      cfg80211: use the correct macro to check for active monitor support

 net/mac80211/rx.c      |  3 +++
 net/mac80211/util.c    |  5 +----
 net/wireless/core.c    | 21 +++++++++++++--------
 net/wireless/ibss.c    |  3 +++
 net/wireless/nl80211.c |  4 ++--
 5 files changed, 22 insertions(+), 14 deletions(-)


--=-XGD9Q+i157o9/Sl2RX6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSRHlUAAoJEDBSmw7B7bqrm6QQANOJNH8NHb9uPYxFOZ950FrO
gJjjyLToiqaBG2ap3/TdX0wWLduhbRHSz+oRZkmua73lSws0efiFIwrxKucERWRh
cmhUceim2NlEchG6UEq/cFsZchsdMc1cUiTvBE6ctLTFDCD6isH1nEbxOMjxjxAk
vwfcArgmipRc/FoFMjxSBqCGFa3ARq01kJix1QRSlCo26VGhwR5jrSzEcbJp6qRU
cSMcKSn9ppf7P6hzRwQ+Q/EX1ph93Ksjj22wKIiwNHdvG4DpfStJHPZLMlM2ePGe
cBwZs4lEehoEodZKAI9luZRzH63pAO0KetuCfjfm4a2DLve8gdYPJpwfL+PPOMwN
6sKDbkfbXemx1uCB980HmCy1fuuSG7L1SXRVNJfnGN2Kxw1lkytICNb4B83uy8PM
Or8FxlCyhdvVT9g5HvWZOfYSUd97++fFDCyYHJUlQUhPNWq287e/M2TC9EPy9G6a
FqydfndSFvze3AVNLnFvrV6Iex77/eJZOArom9ZLcuBF87uC/wbL7nqdB0mA6Vat
6X7YxvXPMhHtjTIZJCFG8RsltcKjDDjLEMEZ3YIf8huaPBDjBxfisTnEDrbVXtQa
C6KMq6g2itKWnSxO3POBHghDzmx5XKj4bBOZHCnKeL/AAfl7XNqLlJM4pnhCMAiI
P4C14ZImA3HD+HedYeBV
=lmIE
-----END PGP SIGNATURE-----

--=-XGD9Q+i157o9/Sl2RX6j--

