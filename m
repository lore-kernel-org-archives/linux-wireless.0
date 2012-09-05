Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2IEPhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 11:37:11 -0400
Message-ID: <1346859465.4364.29.camel@jlt4.sipsolutions.net> (sfid-20120905_173716_032247_F4D2661E)
Subject: pull-request: mac80211-next 2012-09-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Sep 2012 17:37:45 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-AVA3jvYefaD2bzBKc97M"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AVA3jvYefaD2bzBKc97M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull these changes to fix a few kerneldoc issues, improve wext
debugging (even if we all want to get rid of it), a fix to the HW queue
work in mac80211 and a code simplification.

Thanks,
johannes



The following changes since commit aba4e6fff8de0c92e53f0e7ef077231e75f7d760=
:

  mac80211: Fix AP mode regression (2012-08-22 10:55:04 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 768be59f30f2ee8958ba3718101162c694efab12:

  cfg80211: fix indentation (2012-09-05 16:54:05 +0200)

----------------------------------------------------------------
Arend van Spriel (1):
      wext: include wireless event id when it has a size problem

Hila Gonen (1):
      cfg80211: fix indentation

Ilan Peer (1):
      mac80211: Do not check for valid hw_queues for P2P_DEVICE

Johannes Berg (1):
      mac80211: don't use kerneldoc for ieee80211_add_rx_radiotap_header

Robert P. J. Day (1):
      cfg80211: add kerneldoc entry for "vht_cap"

Wei Yongjun (1):
      cfg80211: use list_move_tail instead of list_del/list_add_tail

 include/net/cfg80211.h   |    1 +
 net/mac80211/iface.c     |   16 +++++++++-------
 net/mac80211/rx.c        |    2 +-
 net/wireless/reg.c       |    6 ++----
 net/wireless/scan.c      |    2 +-
 net/wireless/wext-core.c |    8 ++++----
 6 files changed, 18 insertions(+), 17 deletions(-)


--=-AVA3jvYefaD2bzBKc97M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQR3HJAAoJEDBSmw7B7bqrRNsP/RWfGiDNl/k49A705xkU7JRN
HqmaI4d7xj4pI5L5ZubBQwHj0udnrzw6rAVxLL3ES+9RJcaTyCopmMdB0ovybYOy
tnPJxf3fbIqtJYz/Mbmi/bOm55Lqnr75l3PykG979NyOrj6y2QiGsG1kuXKPZtBE
vFUwc99zmeBLN/O92LwBMzKWpakuSgO9p4KYAp4cv8ctCh/juo7z3yr95ErF1BMC
UzhU0xoRSlIAPNjygsPNw0hE5RQm4BjdNx1ABuK8tJjycWNqszQmBIbsBSd4zVBh
oJT6QJU1mDpETnuaDXmt91mafrMtD8dO6YpFihEdfL3C805JuWwB+zqboFFR7Mnt
UYbNcwpe3Zaz1WzjNfBcuGy+bbEScz9Gz2TIKDb0sgXNhY9cvK9R1OUd2X7N9nPW
AglMVHGbGHmJXEehsj+nfM7DtkFG7UG0FK10vN/b3GYkQTP5nHrubKeqS0KJftnI
o3PydOXkz1V3FnlNssZHq88wrBlfvHVWFm2duK/VOUuFRis9qXxEoeTFjA7tBG9F
/LZwgCFuaixdmX60tPqoLMqQZJPVRK+ndaX6nQ0x7KxC34RcVZ3Y29AP51A/gEdK
jXvlvRShF7c1haDTIwoDYOuxQuIBdYVbJjrUGhmvAqkat8L9IK8DczWwsG2v+Pyk
ORRwVL8kPIXJm9ps4EuJ
=2NxT
-----END PGP SIGNATURE-----

--=-AVA3jvYefaD2bzBKc97M--

