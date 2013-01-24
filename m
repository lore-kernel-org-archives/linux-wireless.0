Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3AXQkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 11:40:21 -0500
Message-ID: <1359045642.21908.14.camel@jlt4.sipsolutions.net> (sfid-20130124_174025_344664_B6A03BF0)
Subject: pull-request: iwlwifi-next 2012-01-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 17:40:42 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-45wz/P8Z0Cas4qStUDG1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-45wz/P8Z0Cas4qStUDG1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Two small changes for iwlwifi-next, one to update all our Copyright
notices and one to provide the RX page order.

Please pull.

My next pull request will have the new driver I've been promising :-)

Thanks,
johannes

The following changes since commit 1c3fea82d6ebf33edadefed2d9ce3efa1a654338=
:

  iwlwifi: improve the reports in TX path (2013-01-16 14:23:57 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to d13f1862c0ad892eded4cdf633ab32bc993cc1d9:

  iwlwifi: provide RX page order (2013-01-24 13:36:32 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: provide RX page order

Johannes Berg (1):
      iwlwifi: update copyright

 drivers/net/wireless/iwlwifi/dvm/agn.h          |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/calib.c        |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/calib.h        |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/commands.h     |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      |  2 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c      |  2 +-
 drivers/net/wireless/iwlwifi/dvm/led.c          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/led.h          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |  2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c         |  2 +-
 drivers/net/wireless/iwlwifi/dvm/power.c        |  2 +-
 drivers/net/wireless/iwlwifi/dvm/power.h        |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c           |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h           |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c           |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  2 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c         |  2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c     |  4 ++--
 drivers/net/wireless/iwlwifi/dvm/tt.c           |  2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.h           |  2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c           |  2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c        |  2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h       |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-config.h       |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-csr.h          |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h        |  2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h     |  2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c          |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-drv.h          |  6 +++---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c  |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h  |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h           |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-fw.h           |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.c           |  2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h           |  2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h    |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c   |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h   |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-prph.h         |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-test.c         |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-test.h         |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-testmode.h     |  4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h        | 10 ++++++++--
 drivers/net/wireless/iwlwifi/pcie/1000.c        |  2 +-
 drivers/net/wireless/iwlwifi/pcie/2000.c        |  2 +-
 drivers/net/wireless/iwlwifi/pcie/5000.c        |  2 +-
 drivers/net/wireless/iwlwifi/pcie/6000.c        |  2 +-
 drivers/net/wireless/iwlwifi/pcie/cfg.h         |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/drv.c         |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/internal.h    |  2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c          |  3 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  4 ++--
 drivers/net/wireless/iwlwifi/pcie/tx.c          |  2 +-
 61 files changed, 98 insertions(+), 91 deletions(-)


--=-45wz/P8Z0Cas4qStUDG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRAWQKAAoJEDBSmw7B7bqrgm0P/2xEOThI/5BslR9pibiXJ1wP
4z3l4tAYmrtpf0MMNu4BW7DEkkBongsfGR6nuibgV4SKcNMsipnbl4j+13/BQ2sr
kKwMJhdUJjfZMGb1cTj2JWpXaE5fZzEiBSRPa4M3g0nMTLjkCwXZkSpa2jgK4umj
H2VlnGkhqZqRPxoxdEQHRkpsZN6/hbZZ64fBfQNz4af3T/1UzNBbxWbXMzM5mwXI
hJcOgRC0XCU+S9jJw0bUzJY5egD66TETszwnih5gpYruWcIgMWRqEHwLijolRYSJ
MS+cZvnR3oOH3wI7s6vtRBdsPA5YjlIFKJooZtRkNF+kX1yMAmKQY10jtCq9pAm1
eX7bTewElxQpgIQ8A7gxGkbaA81vRnYSwP6gim423kHxJpG0IQhRzquk4gdMRej3
05E6Nf3XfpH50AKeUD0D6Qr44rXIos7GStTl3qPgnpl+kgosDWU7Bku41lqlJG2b
86HngSZdDbonmG8OIj9DX1piMMKx/HtwlwgVybOGKXDXNAtpg4fMaQhOUZI+/3Zf
4i1j9vJGjv3R4RjgaGoenvAshV99p+Bjf52VMZqA4JLaJfMQBz05IjOLxf4pnU0K
yTtf+rBLko7Gk9HwDdjrbdYcY7z7bVOQylvb/A2KBUE5pBr98KcqKhf6Z5NQNrv5
BI0Bfm31kkWhSq7c6ujb
=dL12
-----END PGP SIGNATURE-----

--=-45wz/P8Z0Cas4qStUDG1--

