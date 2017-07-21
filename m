Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39682 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751065AbdGUJg2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 05:36:28 -0400
Message-ID: <1500629777.22048.324.camel@coelho.fi> (sfid-20170721_113636_207056_CBDEBB1A)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 21 Jul 2017 12:36:17 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YvDVRCXHrQaqWiLbLB0D"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-07-21
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YvDVRCXHrQaqWiLbLB0D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are some fixes for 4.13.  More details in the tag description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 271612d72da5b46715447bc18add4a1cf7d87687=
:

  Revert "rtlwifi: btcoex: rtl8723be: fix ant_sel not work" (2017-07-21 10:=
41:43 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-07-21

for you to fetch changes up to bf8b286f86fcc66d138fd992acfa37839340218d:

  iwlwifi: mvm: defer setting IWL_MVM_STATUS_IN_HW_RESTART (2017-07-21 12:2=
6:39 +0300)

----------------------------------------------------------------
Some iwlwifi fixes for 4.13:

* A few NULL pointer dereferences in the recovery flow;
* A small but important fix for IBSS;
* A one-liner fix for tracing, which was including too much data;
* Some of these are bugzilla bug fixes;

----------------------------------------------------------------
Dan Carpenter (1):
      iwlwifi: missing error code in iwl_trans_pcie_alloc()

Emmanuel Grumbach (3):
      iwlwifi: dvm: prevent an out of bounds access
      iwlwifi: mvm: fix a NULL pointer dereference of error in recovery
      iwlwifi: fix tracing when tx only is enabled

Johannes Berg (1):
      iwlwifi: mvm: defer setting IWL_MVM_STATUS_IN_HW_RESTART

Luca Coelho (1):
      iwlwifi: mvm: handle IBSS probe_queue in a few missing places

Mordechai Goodstein (1):
      iwlwifi: pcie: fix unused txq NULL pointer dereference

 drivers/net/wireless/intel/iwlwifi/dvm/tx.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  8 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 15 ++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  3 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  3 +++
 8 files changed, 34 insertions(+), 9 deletions(-)

--=-YvDVRCXHrQaqWiLbLB0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAllxyxEACgkQoUecoho8
xfqOBg/7BzE5XsVMca1igoWisSmgeMzdFt9rdx+XfnC10wRXO6gBUpgGlZq/mmct
iO8Z5lJRnPCFqhJ3DtHIH7NlnnX7Qhepo/9iGJ2adMrjqsZ3Er0d1ilqd2wfYZwP
Z9gyYQKYBuqbFgqpkMR/z5thOST0yoMQPhTg8MrZFD8AK19CMFxuAO02y4GlRWxJ
/Ond20WO21Tcw6zUS78LhT+RNgBd4hJTTAw9zNaIOOXDdkcwjMC7BmaBWcyNObte
C8Y91TzgDI5SO0QCDHmSKxlFnqAuW7KTgo/AHN1kZ5ynZ/mDH9P/mhr95MRKpkah
Vx+dOZenauWdZT19r+e60fNGuCCWyCQFN2IT40oDFjWofZuM/u3iXQ2cZUcqlgWf
INcOHiyzR1b/woGZO1pcMMcAljTOpSb/3FoESOtq+oLn3vvgXDIgkFzcSOiVcFpH
yURcFVWMMY10TJNiMSWoWyeuSjIqiw7cecmdIp3RgpyGNvTJ+eh954jjhVf34O2f
yxh/2v38HpEBtssKzl6/TvCXfyB0oJhiKoM6tNOZ5MOvSOGfvGy0dLix9+n0JNUn
E3Bq5ecizi4qs6H0UUCLaK2aX41e0E4UdjLy32hUS4Yt1zf7jp7CebvDODbZOh7J
m4FKKQt3o6jau/w9DdPmYcPBb0eUIFPVa271NJTJhC4mFzq8mK0=
=G4Wg
-----END PGP SIGNATURE-----

--=-YvDVRCXHrQaqWiLbLB0D--
