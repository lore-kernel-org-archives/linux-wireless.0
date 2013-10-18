Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3JROMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 10:12:18 -0400
Message-ID: <1382105527.14393.3.camel@jlt4.sipsolutions.net> (sfid-20131018_161223_398133_32FFD005)
Subject: pull-request: iwlwifi-fixes 2013-10-18
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 Oct 2013 16:12:07 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XVc1o6CR0SJstjs+vknP"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XVc1o6CR0SJstjs+vknP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Before you travel to Edinburgh, I hope to get in another pull request.
Or maybe when you are there? :-)

I have a few fixes for warnings/issues: one from Alex, fixing scan
timings, one from Emmanuel fixing a WARN_ON in the DVM driver, one from
Stanislaw removing a trigger-happy WARN_ON in the MVM driver and a
change from myself to try to recover when the device isn't processing
commands quickly.

Please let me know if there's any issue.

johannes


The following changes since commit 5a3e9f7f8c8768b5f7df81100c684e4cd00a6eb5=
:

  iwlwifi: mvm: call ieee80211_scan_completed when needed (2013-10-02 11:25=
:50 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to f6b129527ca15bae29ffb9417ddaa1c9d99ffc5d:

  iwlwifi: dvm: don't override mac80211's queue setting (2013-10-18 16:03:1=
4 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: fix scan request's suspend time parameter

Emmanuel Grumbach (1):
      iwlwifi: dvm: don't override mac80211's queue setting

Johannes Berg (1):
      iwlwifi: pcie: poke device when commands don't complete quickly

Stanislaw Gruszka (1):
      iwlwifi: don't WARN on bad firmware state

 drivers/net/wireless/iwlwifi/dvm/tx.c    | 14 +++-----------
 drivers/net/wireless/iwlwifi/iwl-trans.h | 22 +++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/scan.c  |  6 +++---
 drivers/net/wireless/iwlwifi/pcie/tx.c   | 31 ++++++++++++++++++++++++++--=
---
 4 files changed, 43 insertions(+), 30 deletions(-)


--=-XVc1o6CR0SJstjs+vknP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSYUG3AAoJEDBSmw7B7bqrV7wP/iGVDDLSUxv9nVXA3FLSfGrH
tkI8Adb6c5VuH0/D5KtbGMoNvJFCBBARH4VHjGWr0p2sY/XwgCCrnzq/q23y6E1o
PVanUa7kzVoPC7VBjJpnUgG6a4TzjzSSLJna4aLB1kgEDQ8vOracBjvw0bsgtmWM
Hc7K+ObTNuwiFZZ/g24nKBqJLWyiLU4JRMphW19/hMYJNPrEulWLd6ZEaatfy5XM
O8ck7O0wyvMQ0Dt2FRku4gn24+tfUawkol6/Jdozu6wKRcZAIGq2pCD7A7XcWFxX
g3ufOibcLMlCUSwfdECYM1MO+VV9z4PUeVrCN30f+ODvI0vf6oykWXgQjYQ0HX3R
KVcKFUyXPby6ypD1y/fretKgYtLRttebrxJ/mtA83N/AXSws8X484aXqGT5azOwd
jZBGbfrPEsJ462vhK+anU8XrfsHQ53i0j+69li1JmjTlEezVVJTeD2S0tyojAQK0
I8sXES4H9VRQYOIRB7Wbh1tLjNEhnOl+BhrNCKRAsUJAiQcYz3A72LupyK/29t2W
bTETrvoc5ITxE3abGw1ZjjBj3JF1CXl8A8qZ7qrHIs0I5L21xtgz6mhVV2YtMxPx
YIeQrRg3fhY/x+sf2tAha6fg7QBrJ85Qiff/HpVjkkWY8uRll/K+1NgGw6+EvSIp
76Bur+PK329TExUu6j1T
=8MpU
-----END PGP SIGNATURE-----

--=-XVc1o6CR0SJstjs+vknP--

