Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3JBQEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 12:04:42 -0400
Message-ID: <1380729859.13329.23.camel@jlt4.sipsolutions.net> (sfid-20131002_180445_977217_C37DB6F5)
Subject: pull-request: iwlwifi-fixes 2013-10-02
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 02 Oct 2013 18:04:19 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-+KeJduFYQjU7wPdOSkfv"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+KeJduFYQjU7wPdOSkfv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Here are a few fixes for iwlwifi.

I have a fix for WoWLAN/D3, a PCIe device fix, we're removing a warning,
there's a fix for RF-kill while scanning (which goes together with a
mac80211 fix) and last but not least we have many new PCI IDs.

Let me know if there's any problem.

johannes


The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f=
:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 5a3e9f7f8c8768b5f7df81100c684e4cd00a6eb5:

  iwlwifi: mvm: call ieee80211_scan_completed when needed (2013-10-02 11:25=
:50 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: Disable uAPSD for D3 image

Emmanuel Grumbach (4):
      iwlwifi: pcie: don't reset the TX queue counter
      iwlwifi: don't WARN on host commands sent when firmware is dead
      iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series
      iwlwifi: mvm: call ieee80211_scan_completed when needed

Matti Gottlieb (1):
      iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC series

 drivers/net/wireless/iwlwifi/iwl-6000.c   |  6 +++++
 drivers/net/wireless/iwlwifi/iwl-config.h |  1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h  |  6 +++--
 drivers/net/wireless/iwlwifi/mvm/power.c  |  5 +++-
 drivers/net/wireless/iwlwifi/mvm/scan.c   | 12 ++++++++-
 drivers/net/wireless/iwlwifi/pcie/drv.c   | 42 +++++++++++++++++++++++++++=
++++
 drivers/net/wireless/iwlwifi/pcie/tx.c    |  2 ++
 7 files changed, 70 insertions(+), 4 deletions(-)


--=-+KeJduFYQjU7wPdOSkfv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSTEQDAAoJEDBSmw7B7bqrQRcP/iPRFRM29R2rmnhYm1Fg5omF
/CZw2OUTL8KYwOTZSzXqNo8ie6zGuKMEoXfUkq+WxYlTeWg/dXCTid/E0GxXJ9CS
ujSOSlrDpdFx3KYX3yXBoKSrBX9GIkU1nXvqsJiSDxcb4k2tkFwLL3123dMmcCvl
laQP8FHAZDeE+kFr8b6u/ymhU2x+OFEHE8RTzHXJru8zht6+6nVy1DRdAGroLMsd
nhmMXvONqyMpNe/al2QAoYw+FbUEP/SYkzN9VrRqOHnMNEJvhpuN2++OGq0Gp3tB
2e/LzJpfRyqAb0eIT6TrpxG+kLAeJqR1G/jFuKtJUgsSEGjkr2JT2tHagLwpRAZw
5tbPT2J3Ghinbaqbwtg2zAko5FBo7EiS54TExnFfWGsl4Tk4t10OqwCXhrGZ91pj
Sjzk3YojvRHd9bjMAaA7xQ1rJ55kz7OIebHtwmiPqI/hewOviiIexGJspskxE3dI
ApbRPfnqwOkB+B3/jOB8pxHYmn2Q7rsaUnAGUDaA85OH7KzywziHsv4RJBB4J05o
8tf61AaZAa+udr9+FBSSrZHEvVKQRN9K9fQL8XEtBhVTnJCGRSaxv8qp2LTl0PvP
NOYLUdEjtGqOR924IBz/RdtEd+IBbv+pQdqzcAWdbYUNf/8NIL5W0GLgpZUxs6C1
v2CWcKiSLbQNf6+0kOCN
=1fvj
-----END PGP SIGNATURE-----

--=-+KeJduFYQjU7wPdOSkfv--

