Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BA5C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 08:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F19582084C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 08:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDCIY4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:24:56 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49660 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726048AbfDCIYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 04:24:55 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBbCW-0007YW-NV; Wed, 03 Apr 2019 11:24:53 +0300
Message-ID: <713ec14872e6f0b9ced02d2d523286d522e0eab1.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Wed, 03 Apr 2019 11:24:51 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-i1ByNOOhfIuLf8mxDJSR"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-next 2019-04-03
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-i1ByNOOhfIuLf8mxDJSR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the second batch of patches intended for v5.2.  This includes
the last patchset I sent.  Usual development work.  More details about
the contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 8db32fa400916333c20184793d1400bd74e1f740=
:

  Merge tag 'iwlwifi-next-for-kalle-2019-03-22' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-03-30 08:37:38 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2019-04-03

for you to fetch changes up to ef8a913766cd5e341da68c011b4a0ff5e2c0f5d1:

  iwlwifi: remove misconfigured pci ids from 22260 series (2019-04-03 11:20=
:05 +0300)

----------------------------------------------------------------
Second batch of patches intended for v5.2

* Work on the new debugging infra continues;
* Fixes for the 22000 series;
* Support for some new FW API changes;
* Work on new hardware continues;
* Some debugfs cleanups by Greg-KH;
* General bugfixes;
* Other cleanups;

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: use correct GP2 register address for 22000 family

Greg Kroah-Hartman (2):
      iwlwifi: mvm: no need to check return value of debugfs_create functio=
ns
      iwlwifi: pcie: no need to check return value of debugfs_create functi=
ons

Ihab Zhaika (1):
      iwlwifi: remove misconfigured pci ids from 22260 series

Johannes Berg (2):
      iwlwifi: mvm: IBSS: use BE FIFO for multicast
      iwlwifi: mvm: remove buggy and unnecessary hw_queue initialization

Liad Kaufman (1):
      iwlwifi: mvm: fix pointer reference when setting HE QAM thres

Sara Sharon (1):
      iwlwifi: mvm: support HE context cmd API change

Shahar S Matityahu (14):
      iwlwifi: dbg_ini: support HW error trigger
      iwlwifi: dbg_ini: enforce always on domain checking
      iwlwifi: dbg_ini: fix iwl_dump_ini_dev_mem_iter memory base address
      iwlwifi: dbg_ini: add memory offset to the base address of a memory r=
egion
      iwlwifi: dbg_ini: add version to dump header
      iwlwifi: dbg_ini: add region id to the region dump
      iwlwifi: dbg_ini: add registers addresses in fifo dump
      iwlwifi: dbg_ini: change memory range base address to u64
      iwlwifi: dbg_ini: fix the dram monitor header size
      iwlwifi: dbg_ini: add monitor header to smem monitor
      iwlwifi: dbg_ini: remove redundant curly brackets from trigger collec=
tion flow
      iwlwifi: dbg_ini: remove redundant type argument from iwl_dump_ini_me=
m
      iwlwifi: dbg_ini: apply rx fifo offset after reading the region regis=
ters
      iwlwifi: dbg: fill radio registers data regardless of fifos data dump=
ing

Shaul Triebitz (2):
      iwlwifi: trust calling function
      iwlwifi: set 512 TX queue slots for AX210 devices

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |  13 ++++--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |  10 +++--
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h      |  77 +++++++++++++++=
++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c          | 237 +++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------=
-------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |  10 +++++
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h   |  33 +++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/file.h         |   3 ++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h      |   8 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   |   7 +--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h       |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  17 +------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c     |  89 +++++++++++++--=
----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c    |  40 ++-------------=
--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  26 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   8 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |  19 ++------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c          |   8 +---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c        |   7 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |  12 ++++-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c        |  11 +----
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   |   7 +--
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c         |   1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      |  12 ++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   6 ++-
 25 files changed, 403 insertions(+), 263 deletions(-)

--=-i1ByNOOhfIuLf8mxDJSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlykbdMACgkQoUecoho8
xfrORhAAmNaDDpiNqCBmOGup/Xs83nqIfqN3N0t81pMC0biAg1RoBYDcnCxrndcQ
Wtr1WH3oYwQtlEbmBZE2rndNUZHYkGU/dy+d4ejeToHGTWC/PmNZ5MHDWDPylCBW
FAtZKO3pJ7hcvGaa90yMxKeHP+SbwTor8WWyzQ1Yp+6lRBXPW7R7B8nldLIwtj/5
gtR9TBqnIz+LSR5JS5mHTtKITtc0e1WvPK0+ysOXHYeZRyo8uI/EP0N7sYy12z3K
bEBn8TDM/ZUu+VBbMk8iqT3TlUhPaFU5Ex1br5Msp1zYFwtL808lU9GCJdDeLzlT
ovQlKmDFi7/Bo19WBLNt+H0mgLYlMzVAbzlWSyIAphpOJo4/etUqW2wVv5vPVrzx
4ZPmiAH9wFb8+DQUmnPhNXvrxoBgV7Ho6wh1U16JNeyK3sGgg5StenGObBXfkTxH
JzMLGz/J/tUb0eHm5mcGW4QW2Gqg1jdrYSS2dmptoV/hiUJCYzpd/q3cGWb/lUmz
Yfkt+W+ScL53GuhrLBvregubnkN8CnSh232FHJBdZzVj+Z/Rts32P9ZkLpCuUldJ
xOPUez1KywQt3uiPtcicVc9bNuKrvvaAz9uYS1uWLj2R//IIBroxh8DwCySo5DGB
7suFmy1JWZ9mSkkgN/bLw479G5dRAF/gH5UHoW8NVp6Hf9byEgM=
=2Fev
-----END PGP SIGNATURE-----

--=-i1ByNOOhfIuLf8mxDJSR--

