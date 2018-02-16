Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58984 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1032341AbeBPNtG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 08:49:06 -0500
Message-ID: <1518788935.7832.46.camel@coelho.fi> (sfid-20180216_145111_113829_EADC3DA9)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 16 Feb 2018 15:48:55 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-7oVXh7CH1axH8fsle6YE"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2018-02-16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7oVXh7CH1axH8fsle6YE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my first set of fixes for 4.16.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 7ac8ff95f48cbfa609a060fd6a1e361dd62feeb3=
:

  mvpp2: fix multicast address filter (2018-02-11 22:37:04 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2018-02-16

for you to fetch changes up to e1233ae4095b77a966af457ed7ebc3053c5821c8:

  iwlwifi: mvm: always init rs with 20mhz bandwidth rates (2018-02-16 15:34=
:33 +0200)

----------------------------------------------------------------
First batch of iwlwifi fixes intended for 4.16:

* A couple of bugzilla fixes
  - Fix a bogus warning when freeing a TFD;
  - Fix severe throughput problem with 9000 series;
* Fix for a bug that caused queue hangs in certain situations;
* Fix for an issue with IBSS;
* Fix an issue with rate-scalingin AP-mode.

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: pcie: don't warn if we use all the transmit pointers

Naftali Goldstein (1):
      iwlwifi: mvm: always init rs with 20mhz bandwidth rates

Sara Sharon (2):
      iwlwifi: mvm: fix security bug in PN checking
      iwlwifi: mvm: fix IBSS for devices that support station type API

Shaul Triebitz (1):
      iwlwifi: align timestamp cancel with timestamp start

 drivers/net/wireless/intel/iwlwifi/fw/init.c      |  6 ------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 28 +++++++++++++++++++=
+--------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 39 +++++++++++++++++++=
+-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 24 ++++++++++++-------=
-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  2 +-
 10 files changed, 61 insertions(+), 50 deletions(-)
--=-7oVXh7CH1axH8fsle6YE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlqG4UcACgkQoUecoho8
xfrEqQ/8C95+NH5p1TeFDzKE4gNU/6alhMEleP//aNSxaoRXHArulgLW8Ut3JfNH
mSn5VVAI4Gw+CdHAzqKZn1TYtit76tQ84+h5udpZDAKXGgp2uXwlzCJ47VOxtETt
7+gtMhBaCfHCoqBFiwBxx5JbwFP/PTft3jt73BpBd8hlZ2FPdMSdgSsEnTSKqZB2
aWE4erq1rQHTI9pYf7tgQ7mt+ivAxPGTUMirrrgNs/dzzqTwHIhEuCQ+sCKpATcu
dLjm9d1jnO/p5XT4fmu+S4vDvA8BSiVcz17weyE08ZpZrKVEtFKar08DjXKZbs9U
sxCn7/idAbaUN8ltC2GlHjbdGlZzwdVEdkfZtoeEcfT1+4C5XkUicpLpF6HDhXUz
HW814RjHYnpzDM3bxngan1cLfRkVSDkz29mEH2D3ELEFmTKuzuQjCneOhmktJggy
Eg/WBZ/M5icpsx0hEty9lj3G3FvBo+yZRy/zNfXbd3Nc5Z+thUCuPRL97F47l65+
nHA3ElRcW/5CBCwF2Urs/m64hKOXH26dJG8nrDbwt5ScwBKwlJG22o+XJ4Zj4VwG
3DQKo2g2wuf5MuKnUvZ3RR5yc7SVXvyq75HeAHfwvpK7mqgrAeEZtfz1SP3sfZ9L
HO95dxa04BbJNpCJg9kfmN0shBG83XlDOyCnLjXQizM3CaiH9fQ=
=5wwg
-----END PGP SIGNATURE-----

--=-7oVXh7CH1axH8fsle6YE--
