Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47328 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754013AbcJZINy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 04:13:54 -0400
Message-ID: <1477469629.27792.8.camel@coelho.fi> (sfid-20161026_101359_225122_77E998F9)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Wed, 26 Oct 2016 11:13:49 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-utUVR5m/PWFe2AFKpL84"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-10-25-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-utUVR5m/PWFe2AFKpL84
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's an updated pull-request, replacing 2016-10-25, with one commit
message reworded, as you requested.

I sent v2 of that patch to the linux-wireless mailing list.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 15b95a15950238eff4d7f24be1716086eea67835=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2016-09-28 16:37:33 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2016-10-25-2

for you to fetch changes up to 7e62a699aafbd97928f19a8356d719b71b0e151c:

  iwlwifi: mvm: use dev_coredumpsg() (2016-10-26 11:04:15 +0300)

----------------------------------------------------------------
* Finalize and enable dynamic queue allocation;
* Use dev_coredumpmsg() to prevent locking the driver;
* Small fix to pass the AID to the FW;
* Use FW PS decisions with multi-queue;

----------------------------------------------------------------
Aviya Erenfeld (1):
      iwlwifi: mvm: use dev_coredumpsg()

Emmanuel Grumbach (1):
      iwlwifi: mvm: tell the firmware about the AID of the peer

Johannes Berg (1):
      iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS

Liad Kaufman (5):
      iwlwifi: mvm: update txq metadata to current owner
      iwlwifi: mvm: fix reserved txq freeing
      iwlwifi: mvm: support MONITOR vif in DQA mode
      iwlwifi: mvm: fix dqa deferred frames marking
      iwlwifi: mvm: enable dynamic queue allocation mode

Sara Sharon (1):
      iwlwifi: mvm: assign cab queue to the correct station

Sharon Dvir (1):
      iwlwifi: pcie: give a meaningful name to interrupt request

 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h    |   2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h  |  26 ++++++++++++++++=
++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h |   9 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c     | 100 ++++++++++++++++=
+++++++++++++++++++++++++----------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c   |  24 +++++++++-------=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  86 ++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |   6 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c        |   3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        |  37 ++++++++++++++++=
++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h        |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c     |  29 ++++++++++++++++=
+++++-
 12 files changed, 249 insertions(+), 75 deletions(-)
--=-utUVR5m/PWFe2AFKpL84
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYEGW9AAoJEKFHnKIaPMX6u8YQAJMcOIpXQmvrnqAH2k+qHEyN
6Ow4tDdAnYYc9vnuxDuLVPEL+9lw6XKsfb6FlwA8EE8shKkNl/vTDcgaov13Ej3x
xHKX6AWHr63qb5A2/pU7inam3TCA/uxBzIvs5XdLGP6TFdadiEhRjDldh84Sq5LS
PP36piOql0tmDumQVgHv3Qn58yu1Nyioo54J0NRzD62pOF9EOuaMlT9jinxUEd2Y
bauzhM2lBRI6p4G2B4/UOBrbo/AVHu1ByFnnuKd07FKcyuDlTlFyHx94A3G+x6nb
5eIdk92xkKbo3fC2+JW/aHwiAwwUbnugImWUQdjFHbkZ1oBOGCiAz/OTF/1exwf5
Zbq/L0AJzAbEgeMQWOO0dehV5FoAAve9FVrWCsn0XilX7Ob+8e9akBc7S5cbFmcj
lqeeJJ0OmnihokGSDyG0vzGUUCjeC4R9Pt7kLk01eD7QbwHzPeh4AnCNmyKGxNaR
7j8/tBAO/fd4JVz5Shi9+VLByUQrNgGDrYEL1zZAwZbaQTeSDwhuA3rCGjuHyJQH
CqQufyK1HfDiIQNaG127k1MK8lcTZwg3VCOLq/RRrZods43/eUmXEslyJEn3ISDF
RcyOY6FcTVd40+Eg91HNMV32Pc2QPO/yshlpE6vA86Dq+AYtPTRLJZ3jexw7s+gn
WIgkvJeSJR3oaTg8ZgNI
=cz6f
-----END PGP SIGNATURE-----

--=-utUVR5m/PWFe2AFKpL84--
