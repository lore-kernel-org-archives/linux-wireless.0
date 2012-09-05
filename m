Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 11:39:14 -0400
Message-ID: <1346859588.4364.31.camel@jlt4.sipsolutions.net> (sfid-20120905_173917_628860_2DC5FDEE)
Subject: pull-request: iwlwifi-next 2012-09-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Sep 2012 17:39:48 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ZTRHkqS4ZQLYisR9ZOvi"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZTRHkqS4ZQLYisR9ZOvi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull these iwlwifi driver changes. DavidS removes an unused
struct member, and I have a patch fixing the antenna information
reported to radiotap, another one to report A-MPDU information there and
finally one change to reduce overhead if tracing is compiled in but not
enabled (which will probably let use remove the conditional compilation
entirely soon.)

Thanks,
johannes



The following changes since commit a4881cc45a3fab4488e16c4934e149cfa620f1a9=
:

  Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/=
jberg/mac80211-next (2012-08-23 09:49:42 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to c5d472212024543e32cf3eea4381ab91b9f6b812:

  iwlwifi: remove radio_config from eeprom_data (2012-09-05 16:18:01 +0200)

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: remove radio_config from eeprom_data

Johannes Berg (4):
      iwlwifi: fix antenna bitmask
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: report A-MPDU status
      iwlwifi: reduce overhead if tracing disabled

 drivers/net/wireless/iwlwifi/dvm/commands.h     |    3 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h          |    1 +
 drivers/net/wireless/iwlwifi/dvm/rx.c           |   11 ++++++++
 drivers/net/wireless/iwlwifi/iwl-devtrace.h     |   34 ++++++++++++++-----=
----
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h |    2 --
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   25 ++---------------
 6 files changed, 37 insertions(+), 39 deletions(-)


--=-ZTRHkqS4ZQLYisR9ZOvi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQR3JEAAoJEDBSmw7B7bqr+RQP/2wGy7XNBNNJLcHRFObs7Mpf
EvUiiFTGumUYTZjX861zBLLj5A05irxmbmwH4HfRAsndCf9Em9DVgnUvebQ7Gwj0
w/zZOJh5PlLJF96SXfpO+R6bVcZkBgmV29iwUQi7j6lXzxgdtpiGeVBDprBgUcOw
ItImv4RthMyMByzLr+SumZyiWqpcV31dFlVr2Yx3Knre08U8XLwRQQg4FgoVrFr0
juTT3YsJtR6wjXd/vyYv5vWW3usUvJIwT7/Qo5F/6eBsppewT4/MTWbDa55RuDJg
kPiChniXSGM9JpBNmAf9fOwFSsOW52fQNRXC3X8lIAKG0i1Kz+IZJop9vR2crhGR
2vWHUT9xT8nelKq5dPEereHmyQHa1Uyw/V22SxrQvF68AsGenLlDe2CsixzoAsFr
SEFrWJZe230x1UzfBVY+3h8qSlPAvlaJNG9AsQLMBtVTUDVFyohYTyDu+Tdlz0FF
WqMGe84KlDZa3m+VU+QAQBt+qOwqGBuzmtToYsNElOQqFuMRdOdqOZacZfMPKn6i
RJMo1iF1D6Aak43Ih1UFOuMVw1/46+TqKkexGp1l8ICGy2ys8wefeH2bdnQ3dU5c
Ks8zr9f4tsifNhbRq7dJP9bWNyGjtB8QQpsqjk07ORTAxDALNm7kAeUB1Be2hYiW
IX+Y5dXTigDXxLQcME3x
=QRxn
-----END PGP SIGNATURE-----

--=-ZTRHkqS4ZQLYisR9ZOvi--

