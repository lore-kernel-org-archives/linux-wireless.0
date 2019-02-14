Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7039EC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 422A8222A4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 09:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392992AbfBNJmv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 04:42:51 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:59726 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726106AbfBNJmt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 04:42:49 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1guDXa-0007HO-O5; Thu, 14 Feb 2019 11:42:47 +0200
Message-ID: <948cdfe88dcad399e0acb698542fb97a35609059.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Thu, 14 Feb 2019 11:42:45 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-2oUSU8S12t9WBcVZ9CDc"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-02-14
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-2oUSU8S12t9WBcVZ9CDc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the fourth batch of patches intended for v5.1.  This includes
the last two patchsets I sent.  Usual development work.  More details
about the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 34025a1056a3c82b7e16992da9af54d729dd77fe=
:

  rsi: fix indentation issue with a code block (2019-02-08 17:31:23 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-02-14

for you to fetch changes up to 99944b73069d8bcea573c07df8dc8d4f33e78586:

  iwlwifi: mvm: stop static queues correctly (2019-02-14 11:29:52 +0200)

----------------------------------------------------------------
Fourth batch of iwlwifi patches intended for v5.1

* Work on the new debugging infrastructure continues;
* FTM (Fine Timing Measurement) initiator and responder implementation;
* Support for a new device family started;
* Bump supported FW API to 46;
* General bugfixes;
* Other cleanups;

----------------------------------------------------------------
Avraham Stern (4):
      iwlwifi: mvm: Fix possible NULL pointer dereference
      iwlwifi: mvm: add support for new FTM fw API
      iwlwifi: mvm: add debug prints for FTM
      iwlwifi: mvm: stop static queues correctly

Emmanuel Grumbach (1):
      iwlwifi: mvm: fix the spatial reuse parsing for HE_TRIG PPDUs

Haim Dreyfuss (1):
      iwlwifi: mvm: add support for 32kHz external clock indication

Ido Yariv (1):
      iwlwifi: mvm: don't require WOWLAN images when unified

Ilan Peer (3):
      iwiwifi: mvm: Fix FW scan concurrency support assumptions
      iwlwifi: mvm: Don't warn on command failure during restart
      iwlwifi: mvm: Do not return an error value on HW restart

Johannes Berg (5):
      iwlwifi: mvm: support FTM responder
      iwlwifi: mvm: support FTM initiator
      iwlwifi: mvm: clean up NO_PSDU case
      iwlwifi: bump FW API to 46 for 9000 and 22000 series
      iwlwifi: mvm: fix HE radiotap data4 for HE-TB PPDUs

Luca Coelho (2):
      iwlwifi: bump FW API to 45 for 9000 and 22000 series
      iwlwifi: start using B-step for some 9000 devices

Mordechay Goodstein (1):
      iwlwifi: add FW recovery flow

Sara Sharon (5):
      iwlwifi: pcie: fix emergency path
      iwlwifi: dvm: don't use IWL_DL_FW_ERRORS
      iwlwifi: pcie: add TPT oriented prints
      iwlwifi: mvm: support beacon IE injection
      iwlwifi: pcie: fix TX while flushing

Shahar S Matityahu (9):
      iwlwifi: dbg_ini: implement monitor sram memory dump
      iwlwifi: dbg_ini: implement monitor dram memory dump
      iwlwifi: receive umac and lmac error table addresses from TLVs
      iwlwifi: dbg_ini: rewrite trigger flow and align to FW API changes
      iwlwifi: mvm: add a debug_enable op
      iwlwifi: properly use delay option in dump trigger flow
      iwlwifi: dbg_ini: enable ignore consecutive trigger feature
      iwlwifi: dbg: buffer overflow in non_collect_ts_start array
      iwlwifi: dbg_ini: add early and after alive apply points to unified i=
mages

Shaul Triebitz (5):
      iwlwifi: introduce device family AX210
      iwlwifi: do not fail on large amount of channels
      iwlwifi: dbg: temporarily skip periphery dump for AX210 devices
      iwlwifi: align to new periphery address space for AX210 family
      iwlwifi: add force NMI for AX210 devices

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c           |  93 +++++++++++=
---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c            |  14 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c             |  32 +++++
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h             |  22 +++-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h        |  48 +++++--
 drivers/net/wireless/intel/iwlwifi/fw/api/commands.h     |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h      |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/location.h     | 191 +++++++++++=
++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h        |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h         |   6 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c              | 240 +++++++++++=
++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h              |  76 ++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h       |  16 ++-
 drivers/net/wireless/intel/iwlwifi/fw/file.h             |  17 +++
 drivers/net/wireless/intel/iwlwifi/fw/img.h              |  12 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h          |  19 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h          |  15 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h             |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h           |   5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c             |  55 +++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c              |  11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h              |  43 ++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h            |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h           |  10 ++
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile          |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h       |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c              |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c         | 106 +++++++++++=
++++
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c   | 654 +++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c   | 244 +++++++++++=
++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c              |  92 +++++++++++=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c        |  22 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        | 168 +++++++++++=
++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h             |  43 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c             |  48 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/power.c           |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c            |  33 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c            |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c             |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c           |  12 +-
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c |  16 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c            |  16 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c             |  52 ++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c     |   7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c          | 105 ++++++++++-=
----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c             |  22 +++-
 include/linux/ieee80211.h                                |   2 +
 51 files changed, 2349 insertions(+), 299 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c

--=-2oUSU8S12t9WBcVZ9CDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlxlOBUACgkQoUecoho8
xfrZqxAAuIlFqgs3qfrs0u2dB+IfkNpaxy82s8fC432tJZwclywC54VHc2jVzAe9
yuG9ShahinBlnwFwTecgCXle/m75UA5glEKhTxFhTE6Xxjb48dY+YjchPAlJe5H9
ZYUbOMBuKEGifpD1kFCHAuhJL/ZdktJdX+EEmQUvgxN8MRpL8hZ/oFcH9qXtHEo9
WkbFBt84HuJtT/O0FYpYJxUIyzS0E02GqMdo+bV2KOKb4i+yT7fSd4jI8PMm8rGG
vaS8MFuyZFzpOdl+UimuekmYgBn/dp/jHV64I1cp+YdGCwcREX/gEvj8DFBjzb9v
Pc5JvrheWfwvnoY9sS5FCatLGI37BKh6MsorTy7NfvRg/iU627Eagbjn9AQABKNV
jRSRktuiAVmPnD0tjQcdskjMySZ0Q6tzTGWPCaW4O7ujg5i2hPEdozoR480uMgJN
LgMhA4my/K5WmPKM6xvG5Jl06PsYDfDQLaf+VCADRfT5Krz9PoTZDoA/OjRpnjx/
8T7edCPyF1yqMLvyia66pSRLktDUWWxnMENffGYDCOiLcAxmpGjnk2vX/tiIAVFb
kvXMRoWnHYbyvH76quZKg2E1y7L3GRP1ZJsfQLVT22Jc/HqkpDTW5JB4+XBoHV9f
k/IL5E4lUR0kd6B9PX1L4kx7RBa/DaN4d7ffvMV7NCxS52fA5vo=
=Nnlb
-----END PGP SIGNATURE-----

--=-2oUSU8S12t9WBcVZ9CDc--

