Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34173C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 14:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 053C720870
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 14:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfA2OTG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 09:19:06 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52414 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725808AbfA2OTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 09:19:06 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1goUEA-0003Qz-RM; Tue, 29 Jan 2019 16:19:03 +0200
Message-ID: <7e68c48a5c59b164a28d434765b03cba6243c12f.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Tue, 29 Jan 2019 16:19:01 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-D36C4A/SFDSLg078S62B"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-01-29
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-D36C4A/SFDSLg078S62B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the second batch of patches intended for v5.1.  This includes
the last two patchsets I sent.  Usual development work.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 64e2330580fbbfa7077ef2f608555f07e0bb4956=
:

  Merge tag 'iwlwifi-next-for-kalle-2019-01-25' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-01-29 14:56:05 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-01-29

for you to fetch changes up to 01f377dc927da6e42cbffb00fc8d431c8341da3f:

  iwiwifi: fix bad monitor buffer register addresses (2019-01-29 16:10:33 +=
0200)

----------------------------------------------------------------
Second batch of iwlwifi patches intended for v5.1

* A bunch of fixes for issues found with static analyzers;
* Relicense the pcie submodule to dual GPL/BSD;
* Reworked the TOF/CSI implementation;
* Work on new debugging infra continues;
* Some product name updates in the human-readable strings
* Some more cleanups for the device configuration refactoring;
* General bugfixes;
* Other cleanups and small fixes;

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Disconnect on large beacon loss

David Spinadel (1):
      iwlwifi: mvm: Change FW channel info API

Emmanuel Grumbach (1):
      iwlwifi: mvm: freeze management TXQ timer when station goes to sleep

Ihab Zhaika (1):
      iwlwifi: update product name for 9260 and 9560

Johannes Berg (13):
      iwlwifi: mvm: fix %16 to %016 print format
      iwlwifi: mvm: read IWL_RX_MPDU_PHY_SHORT_PREAMBLE only for CCK
      iwlwifi: pcie: align licensing to dual GPL/BSD
      iwlwifi: mvm: clean up LDBG config command usage
      iwlwifi: move iwl_enable_{rx,tx}_ampdu to iwl-modparams.h
      iwlwifi: mvm: fix A-MPDU reference assignment
      iwlwifi: remove TOF implementation
      iwlwifi: dvm: remove useless condition
      iwlwifi: pcie: use u32* argument to iwl_trans_get_fw_monitor_len()
      iwlwifi: mvm: add location APIs
      iwlwifi: mvm: implement CSI reporting
      iwlwifi: mvm: document monitor mode reorder buffer bypass
      iwlwifi: mvm: include configured sniffer AID in radiotap

Liad Kaufman (1):
      iwlwifi: mvm: remove sta key on wep ap

Luca Coelho (5):
      iwlwifi: mvm: save and export regdb blob from the NVM
      iwlwifi: make iwl_fw_dbg_start_stop_hcmd() inline
      iwlwifi: mvm: pre-initialize alive_data in wait_alive()
      iwlwifi: calculate pointers from out_cmd instead of out_cmd->hdr
      iwlwifi: make sure cur_fw_img is valid before accessing img

Mordechay Goodstein (1):
      iwlwifi: mvm: disable completely low latency mode with debugfs

Sara Sharon (4):
      iwlwifi: pcie: fix the use of a wrong define
      iwlwifi: pcie: add prints to track virtual ID
      iwlwifi: mvm: add an option to dereference vif by id
      iwlwifi: mvm: get rid of tx_path_lock

Shahar S Matityahu (7):
      iwlwifi: monitor dumping flow cleanup
      iwlwifi: trigger dump on assert prior to setting the device up
      iwlwifi: dbg_ini: allocate dram buffer with proper flags
      iwlwifi: dbg_ini: properly handle ini user trigger
      iwlwifi: dbg_ini: retrieve dump_delay value properly
      iwlwifi: dbg_ini: set dump mask BIT(n) instead of n
      iwiwifi: fix bad monitor buffer register addresses

Shaul Triebitz (3):
      iwlwifi: iwlmvm: ignore HE PPDU type regarding EOF
      iwlwifi: iwlmvm: in monitor NDP notif take the NSS from rx_vec
      iwlwifi: mvm: update firmware when MU EDCA params change

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c         |   6 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c          |  29 ++++
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c      |  23 +--
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c            |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h   |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h   |  55 +++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h      |  33 ++--
 drivers/net/wireless/intel/iwlwifi/fw/api/location.h   | 711 +++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |  51 ++++--
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h         |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h       |  19 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h |  34 ++--
 drivers/net/wireless/intel/iwlwifi/fw/api/tof.h        | 393 -------------=
---------------------------------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c            |  28 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h            |  17 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h           |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h        |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-io.c            |  41 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h            |  38 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h     |  18 +++
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h          |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile        |   1 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 813 ++++++-------=
---------------------------------------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c       |  91 +++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c      | 104 ++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      | 124 +++++++++----=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h           | 150 +++++++++++++=
+++--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c           |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c           |  29 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c      |  24 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c          | 101 ++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c          |  33 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c           | 305 -------------=
-----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h           |  89 -----------
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c         |  24 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c          | 188 +++++++++++--=
---------
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h     |  44 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c           |  52 ++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c        |  20 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |  44 +++++-
 45 files changed, 1759 insertions(+), 2046 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/location.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/tof.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.h

--=-D36C4A/SFDSLg078S62B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlxQYNUACgkQoUecoho8
xfqfwA/8CGefu39SJ3PzCLpiJXOas/4a25M/z8ShLF2mkgFT0c4AG5d1drSgbPxA
yerLiU+mGhwQD3bFU3dPrMHxWwgA7v7KgO0uFpLpYlrvp+rGCYWPvoLxaAP5Cmh/
KO+4/u5kVOCAcmEKHJdjQ84LtgDVvhnnqh+ppO4gjLDPf3Za7FRVuFz1wHScqxU9
cppyXQDDUMkDkCTuMhjSvc7RYu6EX5JjFnhW3VcvTMK3HuQ+fagPtfJaqtVGVbWA
AWD++ua1tu8JWLatuiweqX7emvOuIslfAKxy+AFKNbSipCJ/oCYYurGqcuk0O6DM
eR03TSJBmOSX2U57OzxuuxDeflubKXhZXs750anaMmU4EM66HW/xuD2XnsNGm+LR
YgzF3BEVJHlwilJmITQekEyUo8STOHGkxtSofWjFBm7ZvD21FAXLZlrcXvW7eTdN
z/KNtRQ1zrZ7xvHYTB5vAKGxG5RkTPdjN0QHaAMGzhsVTcsDoLqbNPeUwAGIFj5R
7r9Lbx5s8akBZFDYOb81q0UBTGKXXL8ya+0LgPB0KjIN+4dbw88/LoV517S1viAr
VZbe2jw8s1d2N23MQX79jWT34NMKwjE6FRYjagHzIIJpGCJEo9oukZzrdKW8pMCk
SqU7uX7tlkNccETOgPJk4Ky8ox8zwvb1ZydepHqGKC/X0f6Njck=
=TrzR
-----END PGP SIGNATURE-----

--=-D36C4A/SFDSLg078S62B--

