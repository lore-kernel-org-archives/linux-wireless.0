Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46374 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751029AbdKTLC4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 06:02:56 -0500
Message-ID: <1511175768.4011.261.camel@coelho.fi> (sfid-20171120_120300_216820_B57BBC5D)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Mon, 20 Nov 2017 13:02:48 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ovd4MB7Ybxk4+ZlZSGHE"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-11-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ovd4MB7Ybxk4+ZlZSGHE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my first set of fixes for 4.15.  More details in the tag
description.

I have based it on wireless-drivers-next.git, because you didn't update
wireless-drivers.git yet.  Let me know if you want me to rebase once
you update.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit fdd0bd88ceaecf729db103ac8836af5805dd2dc1=
:

  brcmfmac: add CLM download support (2017-11-11 03:04:09 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-11-19

for you to fetch changes up to c2c48ddfc8b03b9ecb51d2832b586497b37531bc:

  iwlwifi: fix firmware names for 9000 and A000 series hw (2017-11-16 10:40=
:15 +0200)

----------------------------------------------------------------
iwlwifi: first set of fixes for 4.15

* Support new FW API version of scan cmd (used in FW version 34);
* Add a bunch of PCI IDs and fix configuration structs for A000
  devices;
* Fix the exported firmware name strings for 9000 and A000 devices;

----------------------------------------------------------------
Luca Coelho (2):
      iwlwifi: mvm: support version 7 of the SCAN_REQ_UMAC FW command
      iwlwifi: fix PCI IDs and configuration mapping for 9000 series

Thomas Backlund (1):
      iwlwifi: fix firmware names for 9000 and A000 series hw

 drivers/net/wireless/intel/iwlwifi/cfg/9000.c    |  73 +++++++++++++++++++=
++++++++++++++++++++++++++++++-------
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c    |  10 ++++----
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h |  59 +++++++++++++++++++=
++++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/fw/file.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h  |   5 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |   6 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c    |  86 +++++++++++++++++++=
+++++++++++++++++++++++++++++++----------------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c    | 132 +++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------=
-------
 8 files changed, 296 insertions(+), 76 deletions(-)
--=-ovd4MB7Ybxk4+ZlZSGHE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAloStlgACgkQoUecoho8
xfomxA//bD28h0faLxaOli5xLH3YeF0Pa16CEJMYQj+qDBVNRGajf495HSfpCD5z
CmStf239NJcxkP1Kleaq1se9BYyeBCrfrfRa+CIHCteM/aDGQ2PUrxf4KlRl6dMJ
1f8E/QUNaeiFpXoMNfG2iN7qn2PQ5uzuDS9LwqBfxuhocyWKYqnkunpM5C+Esw2E
LCflleXSdcT35AsBkLwe9jrGY0zPbIthyTFyOROyhJ956VW/Fv0v+kTq0N27DyJk
19cWcHQSIjZFXAKKiENsXHCVUZuS2VPAlhT3UHtID8IR1VVXQPlxOld/xJlw3D9b
kdb5Hgc08xhVlTGApReKxsL4v5fw84LnVyeVY51kVxEN06QzDf5aYGQV2YV7lJ4q
4G5AGD7dl8LGzbd2AVpKtjwfwVbzN03QiOvwOOO+tGxLdjto4/Vp/NPYXr9g0CMx
fN0do/Bc6uclwEslAQmXmHxmONWZEtnZK2l0r/Zc2k2DK50qFJVL1siUxYz2Uj32
E5lFZDNTDUhihkH5oQ4PIzlzcz+Fd9yOotXJdZlV8a128FejMBmyvGzvPbp0lYCP
Tpm92fGCXnsoDlgW9EM9Kx6ftEBIyWip3hGSRjYotM+bDKFsGBwGxYDKhtv1O9RH
8Mb6ZOGg5p5r914CNfZz766ZzAe51W77PUzSBRRiaGATi/SWIJs=
=7xhI
-----END PGP SIGNATURE-----

--=-ovd4MB7Ybxk4+ZlZSGHE--
