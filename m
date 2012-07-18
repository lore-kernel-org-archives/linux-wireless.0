Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:60368 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281Ab2GRRHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 13:07:39 -0400
Received: by lbok6 with SMTP id k6so2993458lbo.32
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 10:07:36 -0700 (PDT)
Message-ID: <1342631118.5363.57.camel@cumari.coelho.fi> (sfid-20120718_190742_946686_941FD2B5)
Subject: pull request: TI wireless drivers 2012-07-18 (for 3.6)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, assaf@ti.com
Date: Wed, 18 Jul 2012 20:05:18 +0300
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-nMfxOpSLSViMY36tI3HO"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nMfxOpSLSViMY36tI3HO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Some patches with bugfixes and small improvements in our drivers.
Probably my last pull-request before the 3.6 merge window.

Please let me know if there are any problems with this.

The following changes since commit 097b0e1bf18a00195cd89bb13565ddbc9b0df942=
:

  b43: fix crash with OpenFWWF (2012-07-17 15:34:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git for-linvill=
e

for you to fetch changes up to e8c7b335faca2cbce715da3b0e1663d75d422f5b:

  wlcore: increase command completion timeout (2012-07-18 15:08:45 +0300)

----------------------------------------------------------------
Arik Nemtsov (4):
      wl18xx: alloc conf.phy memory to ensure alignemnt
      wl18xx: fix bogus compile warning on cc config option
      wlcore: don't issue SLEEP_AUTH command during recovery
      wl18xx: enable MIMO rates when connected as a MIMO STA

Eliad Peller (1):
      wlcore: use basic rates for non-data packets

Eyal Shapira (1):
      wlcore: don't re-configure wakeup conditions if not needed

Igal Chernobelsky (1):
      wlcore: send EAPOLs using minimum basic rate for all roles

Luciano Coelho (2):
      wlcore: wait for command completion event when sending CMD_ROLE_STOP
      wlcore: increase command completion timeout

Yair Shapira (5):
      wl18xx: add support for ht_mode in conf.h
      wlcore: add plt_mode including new PLT_FEM_DETECT
      wl18xx: disable calibrator based fem detect
      wlcore/wl12xx: calibrator fem detect implementation
      wlcore: make usage of nla_put clearer

 drivers/net/wireless/ti/wl12xx/cmd.c      |   34 +++++++++++++++---
 drivers/net/wireless/ti/wl12xx/main.c     |   23 ++++++++++++
 drivers/net/wireless/ti/wl18xx/conf.h     |   21 ++++++++++-
 drivers/net/wireless/ti/wl18xx/io.c       |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c     |  117 +++++++++++++++++++++++++=
++++++++++++++++++-----------------
 drivers/net/wireless/ti/wlcore/cmd.c      |   12 +++++++
 drivers/net/wireless/ti/wlcore/cmd.h      |    2 +-
 drivers/net/wireless/ti/wlcore/main.c     |   44 ++++++++++++++++++++---
 drivers/net/wireless/ti/wlcore/testmode.c |   85 +++++++++++++++++++++++++=
+++++-------------
 drivers/net/wireless/ti/wlcore/tx.c       |   14 ++++----
 drivers/net/wireless/ti/wlcore/wlcore.h   |    2 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    8 ++++-
 12 files changed, 290 insertions(+), 74 deletions(-)

--=20
Cheers,
Luca.

--=-nMfxOpSLSViMY36tI3HO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBuzOAAoJEKFHnKIaPMX6pyYP/ilFJgN5bv55c+weqVZ58Vd4
0jDM0Hq6lZhj0KfUMJl5glWXJQ5DhPdnerofJfakwPqX5xe0uzY+98fvDrFVrLR3
Utntb1V1Onrzz6JPdxR5ufM9Fo5NSSPV4KmxvKfWaEOyWu4ew0I7Kmvtx/EFFlYb
eDur7F9jACduqYYRVNUYudxrPAvc1MZyk0/Eif4lKxJDXoV4TibuxMDF33czkwKT
3IpVjx+If/j2Ct+C9Ph7ZMGOddmjsWCbfb4lBTmggvJm3b5H2LRJoP999LR+XU1F
OkhL+hIQkBKnooRhj/W31NR/fZKUYdbLjJa+djZAgBMF1zTK49buiQnBi75lELlA
EdYEee6jXezGKfHZjJ3qpmg9pY6+bGpSpv0yMomfS5lLF9MK1zxnimiODZYBFf2A
HUSZtLmeKcu5ObnXblEEmc+v2QP5x5rsSgNhQLHOOr+qJMVHc0kIrfsHH8IJMUz6
MK4IR3r4ZSgseFeAqOb11aHKYQcpIF9stXsk1j/a5Fz9Jj/Q99G2CNShnPEryaci
ycpan+QI5rJ3LX65SdtNcIxK0dM9X4txO3I7WIVJmxiEDOxYcNxw/0Tb+7dkXgV2
pIA+rxWik5OqDORzTSiwGV0trhjAMvVnP+ZCVcpUpiG+pUueUyg7lnCDsHb/XXqn
KIvSj/JR/nEE8DmNJd74
=4q+j
-----END PGP SIGNATURE-----

--=-nMfxOpSLSViMY36tI3HO--

