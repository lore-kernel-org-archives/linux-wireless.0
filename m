Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:32887 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830Ab3CYPTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:19:31 -0400
Message-ID: <1364224677.23210.22.camel@cumari.coelho.fi> (sfid-20130325_161935_370265_6EFED1B9)
Subject: pull request: TI wireless drivers 2013-03-25 (for 3.10)
From: Luciano Coelho <coelho@ti.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <balbi@ti.com>
Date: Mon, 25 Mar 2013 17:17:57 +0200
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-wbYRxqA6AwHdXri4Wkb9"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-wbYRxqA6AwHdXri4Wkb9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Some patches intended for 3.10.  Mostly bug fixes and other small
improvements.

Please let me know if you have any problems with it!

The following changes since commit 0d4e67174b03e3dcfe75ce7ec488770a5d443bf4=
:

  ath6kl: fix size_t printf warnings (2013-03-20 08:55:26 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to a373c3cec0394756f130183551214a4bd38b4103:

  Merge branch 'wl12xx-next' into for-linville (2013-03-25 17:06:37 +0200)

----------------------------------------------------------------

Arik Nemtsov (8):
      wlcore: fix link count in single-link-PSM optimization
      wlcore: don't risk using stale HLID during .sta_state callback
      wlcore: consolidate tx_seq handling on recovery
      wlcore: change warn on missing lock in wlcore_queue_xx funcs
      wlcore: free AP global links properly on recovery
      wlcore: AP-mode - recover security seq num for stations
      wlcore: correctly check state before regdomain conf
      wlcore: consider dummy packets when tx queues are empty

Eyal Shapira (1):
      wlcore: don't attempt to roam in case of p2p

Igal Chernobelsky (2):
      wlcore: enter elp in force ps mode in 5ms
      wlcore: set max num of Rx BA sessions per chip

Li Fei (1):
      wl1251: call pm_runtime_put_sync in pm_runtime_get_sync failed case

Luciano Coelho (3):
      wlcore: use print_hex_dump_debug()
      wlcore: move handling from hardirq to the irq thread function
      Merge branch 'wl12xx-next' into for-linville

Nadim Zubidat (1):
      wlcore: report rssi from roaming statistics

Victor Goldenshtein (1):
      wl18xx: print chip info during boot

 drivers/net/wireless/ti/wl1251/sdio.c     |    4 +-
 drivers/net/wireless/ti/wl12xx/main.c     |    1 +
 drivers/net/wireless/ti/wl12xx/wl12xx.h   |    2 +
 drivers/net/wireless/ti/wl18xx/main.c     |   25 +++-
 drivers/net/wireless/ti/wl18xx/reg.h      |   29 +++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |    4 +-
 drivers/net/wireless/ti/wlcore/acx.c      |   29 +++++
 drivers/net/wireless/ti/wlcore/acx.h      |   16 ++-
 drivers/net/wireless/ti/wlcore/cmd.c      |   32 +++++
 drivers/net/wireless/ti/wlcore/debug.h    |   33 +++--
 drivers/net/wireless/ti/wlcore/debugfs.c  |    3 +-
 drivers/net/wireless/ti/wlcore/event.c    |    9 +-
 drivers/net/wireless/ti/wlcore/main.c     |  198 +++++++++++++++++++------=
----
 drivers/net/wireless/ti/wlcore/ps.c       |    4 +-
 drivers/net/wireless/ti/wlcore/tx.c       |   39 ++----
 drivers/net/wireless/ti/wlcore/wlcore.h   |    3 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   29 +++--
 17 files changed, 330 insertions(+), 130 deletions(-)


--=20
Cheers,
Luca.

--=-wbYRxqA6AwHdXri4Wkb9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJRUGqlAAoJEKFHnKIaPMX6xJIP/A/alZpOE97PfHQTTvD4cD7E
o3U71sxJ2Qs4Meqm30UrGC1WDjqJuil922mPIThfXXQ23cq/kPBnOAMcBO1MRf2A
Yps4d75YvCZ+1B9pcAUu7HvKH6ox8+tzpykFvlMZehTqlSNCxBfZf/xJnR8X3tK9
zneHaQH+cGDa83uDYzjBV00ghCqOHl4MWJUHLJVJeRWdL1J8grUrCag0Dc2CyDHs
jtcF706g13rWDOxbgSG2JhQCOT/4On+PFdPXU7MFTHUsOOA9/eqdy5Pe3DpBlQsb
ur0buHpjI9nE/JJyw/yzPOBHr1n3EYZT2uDFmk2ZSo2R5hXcq8TiIaduk3FcEPdM
UIHF2JxrUIFGKJOI+w3KraZ0vQKLnezlgTEuoIR5vQ/IQC+uT6RvSLsy7jJkSfnV
yJV/lK2Ypt3id7x1JZGV2pZGsFN5B7wDWUpU46RvmSSD6XUVPBKlxSAuALbD1vHd
l1860af4nVLjCDCZvSXkaaiCO9z6lsUZw2eWCXRw3dfgD0kQXrhcaJeOzpPuH05q
ZA9+cP8Q9j2TptcRRv656ZtnMR/fpIqlXuh5l3//FK3T8zyEC2VLK8iLD/y/AjB/
V6aDd3JjHUNL/5Xh4xhRvTg10hiTFpZpd2z0fV83OHHqVyibywMdlYKklkRdKG4K
QccFaT6Qp7yr+pJ1lsjl
=vhvJ
-----END PGP SIGNATURE-----

--=-wbYRxqA6AwHdXri4Wkb9--
