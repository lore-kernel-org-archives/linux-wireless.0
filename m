Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3BLQBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:01:39 -0500
Message-ID: <1360684891.29913.4.camel@jlt4.sipsolutions.net> (sfid-20130212_170142_851445_CFD724AD)
Subject: pull-request: iwlwifi-next 2012-02-12
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 12 Feb 2013 17:01:31 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-K1uorIM/wMhIAWL2UhHZ"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-K1uorIM/wMhIAWL2UhHZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

We continue work on our new driver, but I also have a WoWLAN and AP mode
improvement for the previous driver and a change to use threaded
interrupts to prepare us for working with non-PCIe devices.

Please pull.

Thanks,
johannes



The following changes since commit 8457703f1e86aaf0f134402dd1e09e1f13e65222=
:

  ath6kl: provide 64-bit per-station byte counters (2013-02-11 15:34:58 -05=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to 36eed56a8f7e1bd7fb5014ea0e702708e1702f30:

  iwlwifi: mvm: beautify code in rx_handlers (2013-02-12 16:52:26 +0100)

----------------------------------------------------------------
Beni Lev (1):
      iwlwifi: mvm: fix TKIP key updating

Emmanuel Grumbach (5):
      iwlwifi: don't ack the card state notification
      iwlwifi: mvm: fix the keyidx assignment
      iwlwifi: mvm: fix locking in iwl_mvm_ipv6_addr_change
      iwlwifi: mvm: use atomic interface iteration to avoid deadlock
      iwlwifi: mvm: beautify code in rx_handlers

Ilan Peer (2):
      iwlwifi: mvm: Update quota settings for all bindings
      iwlwifi: mvm: Change the Time Event type used for ROC

Johannes Berg (8):
      iwlwifi: use threaded interrupt handler
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: dvm: query and report WoWLAN wakeup reason
      iwlwifi: mvm: report wakeup reasons
      iwlwifi: dvm: apply beacon changes immediately
      iwlwifi: mvm: don't delay the association until after beacon
      iwlwifi: mvm: don't wait for session protection to start
      iwlwifi: mvm: update station when marked associated

 drivers/net/wireless/iwlwifi/dvm/commands.h   |  18 ++
 drivers/net/wireless/iwlwifi/dvm/mac80211.c   | 161 ++++++++++++++----
 drivers/net/wireless/iwlwifi/dvm/rx.c         |   2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c       |   5 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c        |   4 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c         |  16 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h    |  10 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |  29 +++-
 drivers/net/wireless/iwlwifi/mvm/d3.c         | 174 +++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |   3 +
 drivers/net/wireless/iwlwifi/mvm/fw.c         |   4 -
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |   6 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  18 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c        |  41 ++---
 drivers/net/wireless/iwlwifi/mvm/power.c      |   2 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c      |  29 +++-
 drivers/net/wireless/iwlwifi/mvm/rx.c         |   2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c        |  40 ++++-
 drivers/net/wireless/iwlwifi/mvm/sta.h        |   6 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 232 ++++++++++------------=
----
 drivers/net/wireless/iwlwifi/mvm/tx.c         |  12 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h  |   3 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c        |  40 +++--
 drivers/net/wireless/iwlwifi/pcie/trans.c     |  11 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c        |   8 +-
 25 files changed, 572 insertions(+), 304 deletions(-)


--=-K1uorIM/wMhIAWL2UhHZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIbBAABCAAGBQJRGmdbAAoJEDBSmw7B7bqrjckP9j29NGBJuYTIla4emeClK5m8
0QGx7bUvMI38cVELRdqIIs56g4+Scuvhq0M6nmGqIIWA7NP7E5kcbIPB79Duusd+
h5KxFUO+x7NC/+v5gztBJlQDWWLxoJ6jjuzZfz7DnUmyVPLXmWCFNejUHYshX28N
PYijIXzsjechkioCafyA0UBpTiwGyntZku9I0Z7PncfobI/3zKtb2N8tIYBEWITW
65bwdKr0k7v8ubI7aB572MUcbcLjBrmxTkd9lSEK53LENTaU3AbDb+frxISZaDxy
ffLbl2OGMKqCWbhPMfVEeFqUeEsUEsEJkwyKcQ2Icojurb4toViWsKZ1PdF1MeV6
2whzNmlMe4WVUto48swGoSHcEkN0eZACf9cGpiZ5wx/sTiwl1ch1BnYG+Swnf66R
VURVXg3QEDitHwNyJt5ErlJ82lUaS4ZQdEmZ4STaXdmzcT6skK3XIMO1m1CWHrXo
PRciiSUHCkM294rmjqjzxQdV+37q2iZGKzVoKGIXGQqAinaTDlyyx8cJCLhh1f32
mu7zVLsrh+nl6xhKSzcHfPfUEQYg+qC1qDsQHUGykPJtaEGQ0rSdtPi54Kndb/y3
UBeXRiWTrs3RSkBTBwZJ1/kJcl+bqVW3xBnz2l8HbirxqD+8o/JpVbcIZmjvEgql
sDGBGt/nTjLGGTai4Mc=
=rzYO
-----END PGP SIGNATURE-----

--=-K1uorIM/wMhIAWL2UhHZ--

