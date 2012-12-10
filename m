Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2LJVrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 16:47:51 -0500
Message-ID: <1355176087.8083.17.camel@jlt4.sipsolutions.net> (sfid-20121210_224800_942676_5168418F)
Subject: pull-request: iwlwifi-next 2012-12-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:48:07 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Pi+FdfD7tLifA8/xTKm5"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pi+FdfD7tLifA8/xTKm5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Since the current release seems to be dragging out, I have a few more
patches for -next. Some are even marked for stable but it's so late that
I didn't want to send them for 3.7 any more.

Please pull to get a few small fixes, some improvements and a bit of
infrastructure work in iwlwifi.

johannes


The following changes since commit eea54c8ec971d4759c541dba351477dafc39ce54=
:

  iwlwifi: remove effectless assignment (2012-11-21 11:30:39 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 25a172655f837bdb032e451f95441bb4acec51bb:

  iwlwifi: don't handle masked interrupt (2012-12-10 22:40:09 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (7):
      iwlwifi: read the Rx write pointer only once
      iwlwifi: clear trans->op_mode pointer when it is leaving
      iwlwifi: return real info in probe failure
      iwlwifi: move prph handling into the transport
      iwlwifi: reset_ict in stop_hw
      iwlwifi: silently ignore fw flaws in Tx path
      iwlwifi: don't handle masked interrupt

Eytan Lifshitz (1):
      iwlwifi: Change define and struct names in iwl-eeprom-parse.h

Johannes Berg (1):
      iwlwifi: change TX code to suppress smatch warning

Tim Gardner (1):
      iwlwifi: iwlagn_request_scan: Fix check for priv->scan_request

 drivers/net/wireless/iwlwifi/dvm/calib.c        | 14 ++---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      | 12 ++--
 drivers/net/wireless/iwlwifi/dvm/dev.h          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c      |  8 +--
 drivers/net/wireless/iwlwifi/dvm/lib.c          |  8 +--
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     | 12 ++--
 drivers/net/wireless/iwlwifi/dvm/main.c         | 57 +++++++++--------
 drivers/net/wireless/iwlwifi/dvm/rs.c           | 44 ++++++-------
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |  4 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c         | 13 ++--
 drivers/net/wireless/iwlwifi/dvm/sta.c          | 12 ++--
 drivers/net/wireless/iwlwifi/dvm/tx.c           | 67 ++++++++------------
 drivers/net/wireless/iwlwifi/dvm/ucode.c        | 12 ++--
 drivers/net/wireless/iwlwifi/iwl-config.h       |  8 +--
 drivers/net/wireless/iwlwifi/iwl-devtrace.h     | 34 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-drv.c          |  6 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 84 ++++++++++++++++-----=
----
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h | 45 ++++++-------
 drivers/net/wireless/iwlwifi/iwl-io.c           | 40 ++++++------
 drivers/net/wireless/iwlwifi/iwl-io.h           | 10 +--
 drivers/net/wireless/iwlwifi/iwl-trans.h        | 22 +++++--
 drivers/net/wireless/iwlwifi/pcie/1000.c        |  8 +--
 drivers/net/wireless/iwlwifi/pcie/2000.c        | 16 ++---
 drivers/net/wireless/iwlwifi/pcie/5000.c        | 12 ++--
 drivers/net/wireless/iwlwifi/pcie/6000.c        | 28 ++++-----
 drivers/net/wireless/iwlwifi/pcie/drv.c         | 11 +++-
 drivers/net/wireless/iwlwifi/pcie/rx.c          | 14 ++++-
 drivers/net/wireless/iwlwifi/pcie/trans.c       | 18 ++++++
 28 files changed, 358 insertions(+), 263 deletions(-)


--=-Pi+FdfD7tLifA8/xTKm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQxliXAAoJEDBSmw7B7bqrsHsQAKb4mVY4Oq4BsIeSTVPPaWnu
rwIv0IsHZI+30sgGjukztAmtIf65dPG9OpZgujD51qfqMabaANJcNzFLDkgmTsSz
pZ+pV3YlxH2qknIy8L1J7oabA2OCRkJwRtk2QzbUCm77YtUagW12Pk4i6PVOvjko
c1sLggI3b/q6t9z4RQwZ4e9OOGdtTOZ06WOshkl8bAfxjzkKxuHLnbQfpHZ7B0K8
eqgEzWLTmoX4t3facV7jWFXwJ6jV8tJZdoxGI8XobiKkjFK4jzoYN7Txrr+Xm2tT
jvV654f5hqHzR9sC4D1Y17SG5GSSUiRVkWXqWqOn80EFISUcmq7acJ1i80TlM6dF
QOeoKg/EigpBq36DZfGL7LW41pGhfhGURQSeAZ9iBOIN+F9SMUkD5kLo94nnqOjq
o628sCWmqcvCJFT4b+jsVSFmOG5+cZ0nhcp39DcrkT4cJa/YHIUnVxfG60Fpc6ER
cl+eM87nneiTTeCuQQV9Z4DjsO6FC98UaRmmwlukmP+LT5A5yXpZoRtsLITaEZT+
txUu1trzELVk2pNoLIr2+xX6IG5ldvFSrhdCL1pDiue6fEGXUlAYM4Cq1IfH8EtZ
2My4DGJz+iNfbeHG9M/4xq1JOnG540s8msgN0hQsYV+wtAY0e/hrhfXJbHb724qi
eCHjhXSMKPdJF819qERg
=kvOo
-----END PGP SIGNATURE-----

--=-Pi+FdfD7tLifA8/xTKm5--

