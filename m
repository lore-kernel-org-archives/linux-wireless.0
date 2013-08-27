Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3H0I4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:56:35 -0400
Message-ID: <1377593792.20012.4.camel@jlt4.sipsolutions.net> (sfid-20130827_105639_403115_2B6FE771)
Subject: pull-request: mac80211-next 2013-08-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 10:56:32 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4Bs9kzxabKr9GgaIPLyx"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4Bs9kzxabKr9GgaIPLyx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And I also have some more changes for -next, just a few small fixes and
improvements, nothing really stands out.

johannes



The following changes since commit 27b3eb9c06a7193bdc9800cd00764a130343bc8a=
:

  mac80211: add APIs to allow keeping connections after WoWLAN (2013-08-16 =
12:58:43 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to a98655387762394371b88cdfb8215884757978ab:

  mac80211: fix change_interface queue assignments (2013-08-26 09:52:58 +02=
00)

----------------------------------------------------------------
Bob Copeland (1):
      mac80211: assign seqnums for group QoS frames

Chun-Yeow Yeoh (1):
      mac80211: only respond to probe request with mesh ID

Johannes Berg (3):
      mac80211: minstrel_ht: don't use control.flags in TX status path
      mac80211: move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN into drivers
      mac80211: fix change_interface queue assignments

Vladimir Kondratiev (1):
      cfg80211: add flags to cfg80211_rx_mgmt()

Wei Yongjun (1):
      mac80211_hwsim: fix error return code in init_mac80211_hwsim()

 drivers/net/wireless/ath/ath6kl/wmi.c         |  7 +++----
 drivers/net/wireless/ath/wil6210/wmi.c        |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |  4 ++--
 drivers/net/wireless/mac80211_hwsim.c         |  4 +++-
 drivers/net/wireless/mwifiex/util.c           |  4 ++--
 drivers/net/wireless/ti/wlcore/main.c         |  3 ++-
 include/net/cfg80211.h                        |  3 ++-
 include/uapi/linux/nl80211.h                  | 16 ++++++++++++++++
 net/mac80211/iface.c                          | 19 +++++++++++--------
 net/mac80211/main.c                           |  3 ---
 net/mac80211/mesh.c                           |  3 +++
 net/mac80211/rc80211_minstrel_ht.c            |  3 +--
 net/mac80211/rx.c                             |  3 +--
 net/mac80211/tx.c                             |  6 ++++--
 net/wireless/mlme.c                           |  4 ++--
 net/wireless/nl80211.c                        |  6 ++++--
 net/wireless/nl80211.h                        |  2 +-
 17 files changed, 58 insertions(+), 34 deletions(-)


--=-4Bs9kzxabKr9GgaIPLyx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSHGnAAAoJEDBSmw7B7bqr4EMQALtc1nFyzFe2n9oQEGGAiRmO
FvXBgVANh0hCqyijdFka/Ob3SVYJ1YgT10YBNRCjzoK6pGtmaICyrr92oGB2YezA
We5aa+Ghf+M6tfK+3L1hvYQY7pGQaXd6uJ3UqwZZHEIHeGlDSP1cOz7XyLmHP/12
C7g5pXCoztNuGtlwBpN8cO0QynhYmSJrDlfRcYLbb3JOBpdmAycOfopEFS9voOgr
Afqup3qX2dac28dt4YuNYi5EQrL4BMaQfKLZtW4kt9/aQbvl+/K+f4gv6/DSC7DY
+MR1yRWNJPU6SrpuNz/WEEEWu74Tee2WJ8YtG6lN3dQk3CpOXxvkJF0Yb2wKwJBm
IE5XBz88H3IP3ZF1z8oWwY0dCWuvNB8eh3FPe4fP8g2No5oXZT6nodclf6u0wjY4
5XMrS/2b/9/0rGOCFa3sOxCm+1hv6k7mstGLDg3PNRWlSH1MxYi1+kpDuhdjGbG2
DMMduhtjWWKE+qpyfH2KbYUsEkQR8W9aGHSEj1Bfmf5fVQiEF6fLOcvdMEpxNW3k
FyNCh7iJTHte2htOu8Q0tMweCLRXgQiFA2TAFvT8GFDnGfkcvRhwebjYN6y3ssa/
ar1JnkMxKeXCjh1VqBptyweDDm+sihNlZHIrJfaIAhwWjXpOA+PKeY6PsHnJSiXa
iUV4kjdG67RnVxxWeKj2
=x6n1
-----END PGP SIGNATURE-----

--=-4Bs9kzxabKr9GgaIPLyx--

