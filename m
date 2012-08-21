Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2HURBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 13:01:00 -0400
Message-ID: <1345568455.10280.11.camel@jlt3.sipsolutions.net> (sfid-20120821_190103_862898_7F152300)
Subject: pull-request: iwlwifi-next 2012-08-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 21 Aug 2012 19:00:55 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1uhuYWSLGapOwsiSgLar"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1uhuYWSLGapOwsiSgLar
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Please pull (per below) to get a few iwlwifi updates. Nothing much
interesting as we're continuing work on a new driver piece, just a few
misc fixes that didn't seem important enough for 3.6 and very minor code
cleanups.

I'll follow up with the patches themselves for comments.

johannes


The following changes since commit 36eb22e97a2b621fb707eead58ef915ab0f46e9e=
:

  libertas: firmware.c: remove duplicated include (2012-07-19 12:36:34 -040=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 40503f7b48260a91ab65a4f8b00a2c6f004fa807:

  iwlwifi: fix FW restart on init FW (2012-08-21 18:32:09 +0200)

----------------------------------------------------------------
Amit Beka (1):
      iwlwifi: fix FW restart on init FW

Emmanuel Grumbach (3):
      iwlwifi: s/iwl_ucode_callback/iwl_req_fw_callback
      iwlwifi: get the correct HCMD in the response handler
      iwlwifi: fix the preparation of the card

Johannes Berg (2):
      iwlwifi: fix aggregation check indentation
      iwlwifi: reduce max remain-on-channel duration

Meenakshi Venkataraman (2):
      iwlwifi: clean up properly when registration with mac80211 fails
      iwlwifi: rework the iwlwifi debugfs structure

 drivers/net/wireless/iwlwifi/dvm/agn.h       |    9 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c   |   56 +++++-----
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c      |   24 +++--
 drivers/net/wireless/iwlwifi/dvm/sta.c       |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c       |  141 ++++++++++++++++++++++=
----
 drivers/net/wireless/iwlwifi/iwl-drv.h       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   12 ++-
 drivers/net/wireless/iwlwifi/pcie/drv.c      |    6 ++
 drivers/net/wireless/iwlwifi/pcie/internal.h |    1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c       |   16 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   28 ++---
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   26 ++++-
 15 files changed, 241 insertions(+), 93 deletions(-)


--=-1uhuYWSLGapOwsiSgLar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQM77HAAoJEDBSmw7B7bqr+mgQAIIJT5f8bRxMW2+LtLk6kWPS
mQZIZ/lgpmCtfjML7/pJQbQVw6zMF8d6/6LqvHNuKRrl6kLl/KrqDQHhoQuLfEWV
ZivchlsWzF9Iaori5/henhvkxx2UW2r0sZIRHCq5jaS/TlvYlw5v3U0C7GXYx8RG
5ggBhy3BNTzfslg2WxSpRy31EAXzH/0oL2/BcDGFX6iV4kYf76z3tN4CNuJTXc45
ed51RYKDJjCnji5LrsCr4GYHzrHrkZpN1VCEP/qfu1cWib/qpmTWWFH5FSH1ZFr2
aWGgX75DZ/91aEaDans254JTBrhBRD2LW4znkO6byI6VhsYK7dNQD6DNYw6IG4gG
e+hSej2tRXJGE8KVw01/m6Ar++6P7mImwN8dNEa4xcEqeZA7/0guW3ryZItHNWSj
MRxAOVlz37+MpQD/i03Yayk9pLeNoQfEdMaLmu9WAJBiqS8tCsjO9gyzMpBqNY3q
GKUEL23ZimoPu2mHeiBgG3QRjZ8dyAuLjqxQWeYYtOZGpsWHHpTz+PxryRTRus8Z
tyDW27Fn2rXgPBer61ZLowDVUWUXG8fzgTVtnq96zO9NMEJfsF5xwaCY25FDGLhl
vKIb94ftvQutQk4coI22YnSnYOXeNc2RacgvU9yw1eWV4T676MGGPaPlmtoE08Nd
pBRGXcLqFWnW47jWtiJM
=baej
-----END PGP SIGNATURE-----

--=-1uhuYWSLGapOwsiSgLar--

