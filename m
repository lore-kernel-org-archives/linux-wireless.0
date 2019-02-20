Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F65BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 18:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DEDF2146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 18:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfBTS4p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:56:45 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34796 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbfBTS4o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 13:56:44 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwX2w-0004mQ-6Z; Wed, 20 Feb 2019 20:56:43 +0200
Message-ID: <8bf655adcf1e58a5e2fd25404a3ae3693cd9e154.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Wed, 20 Feb 2019 20:56:40 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-AZtJjYd7fW6VBi3MqVdS"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-02-20
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-AZtJjYd7fW6VBi3MqVdS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the fifth and last batch of patches intended for v5.1.  This
includes the last two patchsets I sent.  Usual development work.  More
details about the contents in the tag description.

As agreed, I'm sending this before kbuildbot finished its tests, but we
can fix any problems that may arise.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 6c88e0ce5ebcbac8ac930c0149c217c6aa7ab0a3=
:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2019-02-20 20:01:27 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-02-20

for you to fetch changes up to 085486de833e383705bce61dbde8d31077f5b8ca:

  iwlwifi: add new cards for 22000 and killer series and change the market =
name (2019-02-20 20:48:01 +0200)

----------------------------------------------------------------
Fifth batch of iwlwifi patches intended for v5.1

* Some small fixes and continued work on the new debugging
  infrastructure;
* Greg's debugfs clean-ups;
* Some janitorial patches from the community;
* Fix to one false-positive compiler warning;
* VHT extended NSS support;
* New PCI IDs for 9260 and 22000 series;
* Other general bugfixes and cleanups;

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Set TX_CMD_FLG_PROT_REQUIRE correctly

Arnd Bergmann (1):
      iwlwifi: fix false-positive maybe-uninitialized warning

Greg Kroah-Hartman (3):
      iwlwifi: dvm: no need to check return value of debugfs_create functio=
ns
      iwlwifi: fw: no need to check return value of debugfs_create function=
s
      iwlwifi: iwl-drv: no need to check return value of debugfs_create fun=
ctions

Gustavo A. R. Silva (2):
      iwlwifi: eeprom-parse: use struct_size() in kzalloc()
      iwlwifi: nvm-parse: use struct_size() in kzalloc()

Ihab Zhaika (2):
      iwlwifi: add new card for 9260 series
      iwlwifi: add new cards for 22000 and killer series and change the mar=
ket name

Ilan Peer (2):
      iwlwifi: mvm: Don't request HW restart if already requested
      iwlwifi: mvm: Allow retries for probe responses

Johannes Berg (4):
      iwlwifi: mvm: fix error path in iwl_mvm_mac_setup_register()
      iwlwifi: nvm-parse: advertise IEEE80211_VHT_EXT_NSS_BW_CAPABLE in VHT
      iwlwifi: mvm: remove IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE
      iwlwifi: mvm: implement VHT extended NSS support in rs.c

Liad Kaufman (1):
      iwlwifi: mvm: add read debugfs for he_sniffer_params

Sara Sharon (3):
      iwlwifi: mvm: reject new beacons when in inject mode
      iwlwifi: mvm: support non-transmitting AP
      iwlwifi: mvm: add some debug data to TX path

Shahar S Matityahu (8):
      iwlwifi: remove redundant condition from prior alive dump flow
      iwlwifi: dbg_ini: fix infinite time ignore consecutive dumps
      iwlwifi: dbg_ini: add print to iwl_dump_ini_mem in case of invalid ra=
nge
      iwlwifi: dbg_ini: make memory dump get_size handler include headers
      iwlwifi: dbg_ini: make fill_range handler accept generic range pointe=
r
      iwlwifi: dbg_ini: add region to fill_header handler
      iwlwifi: dbg_ini: implement Tx fifos dump
      iwlwifi: dbg_ini: implement Rx fifos dump

Triebitz (1):
      iwlwifi: pcie: allocate rb_stts's for all queues in one place

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c        |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h          |   9 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c      |  44 +--------
 drivers/net/wireless/intel/iwlwifi/dvm/main.c         |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  13 +--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c           | 508 ++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c       |  11 +--
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h       |   9 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h    |  32 +++++-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c          |  22 -----
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c    |  25 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h    |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c      |  32 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c           |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c     |   8 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     |  18 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h          |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c           |  23 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c           |  27 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c         |  99 +++++++++++---=
-----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h    |   9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c          |  66 ++++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c       |   4 +-
 27 files changed, 690 insertions(+), 308 deletions(-)

--=-AZtJjYd7fW6VBi3MqVdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlxtougACgkQoUecoho8
xfpQHRAAlh2buTxPiQG4f7UNHIuBpBA+U5AJzH/Q4qN8i54Jo82r/eZyytwYdYUv
yemPgz2RKfxHPljrg8PHXKZy5DVVQaq8NGBZrQLzpUz5ltdX7vw6RdjRPoJMCxre
km6gvhB0sEOySealq8X0qNN/BtaC2CriXpCVhSPNEvX+GvGwe/qRX7tFI8gJ7pee
mrMmuYfHOBgybhCHDtXLYsgRtzcqVoeje8TnzU1HAeY/Uenh8GZBDJ4c3pMvq1Rh
f4c5meRH90WVb1K/Oo4QibXK1KrMoGnentfoVsZIqOpuGSl4B9eHrfLMJgXTgDGJ
BbJ2NM1H0CIvtcwrKRsek6wCnd3lWzoI1jB+iqUbycSOhS5BGHox2nMpniKgqDzv
YFJNZ2NhV030TNmQym1Ve2bKCBhMtqzUAjCy5fDw1iB9x2xDCJyUY6/waouEGZNQ
MLGu3QPf0BHJLQZ9OpVEv8sZRhypDCu63OOAhSY5T5xoLD4+gcRILphTLXXJHG4S
sUs1wwI3uTXHLawZ8VIPyxw9BJafukY1jElGVTden0S7z7LSq769izin10uOBZY6
t6HwfFsQb86ZejtQWUOeso6ir0NDcvANzlftukjMSWLg3/lhMhM680vrotKtbAqY
R8vpnGc7qSRKLRv4kUMinrDImpMEWvAP3i47F8WZWrn1n8bp8D8=
=uidj
-----END PGP SIGNATURE-----

--=-AZtJjYd7fW6VBi3MqVdS--

