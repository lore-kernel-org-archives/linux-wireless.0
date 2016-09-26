Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46182 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S966265AbcIZUYZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 16:24:25 -0400
Message-ID: <1474921450.8149.57.camel@coelho.fi> (sfid-20160926_222429_217088_5E77D4A9)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Mon, 26 Sep 2016 23:24:10 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QMbnl8INnDnsFLx8DeVP"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-09-26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QMbnl8INnDnsFLx8DeVP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

One more small pull-request intended for 4.9. =C2=A0It seems that I'm
actually catching up with our internal tree! :) Nothing major here,
mostly clean-ups and small bug fixes and improvements.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 0979a913f879ea39504200d83fb9f275a555a58d=
:

  iwlwifi: pcie: use LIST_HEAD() macro (2016-09-19 11:29:35 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2016-09-26

for you to fetch changes up to 9cd70e80f7f0df1d6d13d8aeb50a16bf40e2962c:

  iwlwifi: mvm: initialise ADD_STA before sending it to the firmware (2016-=
09-26 23:15:26 +0300)

----------------------------------------------------------------
* Some new HW IDs;
* Small fix in CTDP error handling;
* Remove support for older firmwares;
* Clean-ups and a few simple fixes here and there.

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: mvm: fix typo in TC_CMD_SEC_KEY_FROM_TABLE
      iwlwifi: mvm: initialise ADD_STA before sending it to the firmware

Johannes Berg (2):
      iwlwifi: pcie: avoid variable shadowing in TFD helpers
      iwlwifi: mvm: correct rate_idx bounds-check

Luca Coelho (2):
      iwlwifi: mvm: bail out if CTDP start operation fails
      iwlwifi: remove support for fw older than -17 and -22

Oren Givon (1):
      iwlwifi: add two new 9560 series PCI IDs

Sara Sharon (3):
      iwlwifi: mvm: cleanup redundant no_power_up_nic_in_init config
      iwlwifi: mvm: cleanup usage of init_dbg parameter
      iwlwifi: allow error table address new range

 drivers/net/wireless/intel/iwlwifi/iwl-7000.c         |  6 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h      | 24 +--------------=
---------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c  |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h | 21 ++++++---------=
------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h    |  6 ++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c           | 43 +++++++++++++++=
++++------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     | 24 +++++++++------=
---------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          |  2 --
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          | 52 +++++++++++++++=
++-----------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/power.c        | 15 +++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c         | 27 ++++-----------=
------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c          |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c           | 10 ++--------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c           |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c        |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    | 19 ++++++++-------=
----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c          | 47 +++++++++++++++=
++++++++++----------------------
 21 files changed, 110 insertions(+), 204 deletions(-)
--=-QMbnl8INnDnsFLx8DeVP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJX6YPqAAoJEKFHnKIaPMX6wEIP/RPHzTxwNbU+39BG/l+ZahjQ
bTx82BJcKsNKDJgE4+O7W/kiK6x51KCOhYJy6G9iX9jXa3KQZ5bjM2KEHJtTE3Lx
xkY9h9tolpAnQtxE6ZdyDUdWiRsjTuAvw5XG50/+V9FioTnoRjfMVW4DJEKs6kaX
cgo4DdQjQZLGPSyHLShzeV5fasWKuBXftKVZfCkQzqXwIN0RD3CXvD1yeZMq4ByM
zo5BY/ccL9lvUy0SeO/X0I86hKhZ/tDBnFzK3mUgCk8shYVJ+uKzNboe4aozVysu
viFw+s795/W3p1yB6KSzK24P1y8E7DXp0oZiS8gGHQhOM592e7gWOUXUwGIAHaDD
/Wl7D3B0fswevmWPamxzmqcOlYpUJZfsVtOH2EYqh0mJrgy1q1CX4xWcLmR+8+52
3rdMwoqZzccOyJUDdFnGoephsKw8AaJws8aEuYhsoX/tZV8ChRApIjAiixyWvb0o
zzBQKXXwi4fGdUJI/KqNeKr9GLXXcQwReGrDoD5n4RBTy9tIQ0x5Fvhd/FXU0qB/
VOS3CBE2E1P8GfsX2jPR6dC1vw5/kQX46Nl+8r/SvP9BAW4Nn+hcK12Zbudbo+10
QqS7p6c8IdNoTc4p8ABz3gdo2CxLt0vXfw4Nr9bRBsotJp09vB7xsBAscQYVKIcH
PzskVGWhDpXnpfu6oWLz
=8Sn7
-----END PGP SIGNATURE-----

--=-QMbnl8INnDnsFLx8DeVP--
