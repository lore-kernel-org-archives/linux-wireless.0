Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47054 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751591AbeE3NdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 09:33:13 -0400
Message-ID: <259624aff894846a91f47a5fd3758dc97566a1e3.camel@coelho.fi> (sfid-20180530_153318_415211_EE24E6F5)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date: Wed, 30 May 2018 16:33:09 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-mNu9gnbbKgzuhtcw3oem"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2018-05-30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mNu9gnbbKgzuhtcw3oem
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the final batch of patches intended for v4.18.  As discussed,
it is focused on bugfixes.  More details about the contents in the tag
description.

I have sent this out before and kbuildbot this morning, but I didn't
get any replies from it yet.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 06895b1627fe36f0bea49d4c9fd0e27f0f7498b1=
:

  rtlwifi: remove duplicate code (2018-05-29 10:28:24 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2018-05-30

for you to fetch changes up to 506247825c5e877741f33a2c657d351e5c7943ba:

  iwlwifi: fix non_shared_ant for 9000 devices (2018-05-30 10:05:12 +0300)

----------------------------------------------------------------
Final batch of iwlwifi patches for 4.18

* Some bugzilla fixes;
* Some kernel warning fixes;
* Fix for an (ETSI) WMM limits bug;
* Fix for a Bluetooth coexistence problem on 9000 devices;
* Fix for an interoperability bug related to block-ack sessions;

----------------------------------------------------------------
Aviya Erenfeld (1):
      iwlmvm: tdls: Check TDLS channel switch support

Colin Ian King (1):
      iwlwifi: mvm: remove division by size of sizeof(struct ieee80211_wmm_=
rule)

Emmanuel Grumbach (2):
      iwlwifi: mvm: fix TSO with highly fragmented SKBs
      iwlwifi: mvm: honor the max_amsdu_subframes limit

Erel Geron (1):
      iwlwifi: fix non_shared_ant for 9000 devices

Golan Ben Ami (1):
      iwlwifi: add csr configuration for 6300 devices

Gregory Greenman (1):
      iwlwifi: mvm: open BA session only when sta is authorized

Johannes Berg (1):
      iwlwifi: mvm: fix race in queue notification wait

Sara Sharon (1):
      iwlwifi: mvm: drop UNKNOWN security type frames

Shaul Triebitz (1):
      iwlwifi: pcie: fix race in Rx buffer allocator

 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |  1 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  8 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 38 ++++++++++++++++++=
+-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |  7 ++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 36 ++++++++++++++++++=
++++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       | 10 ++++------
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      | 16 +++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 16 ++++++++++------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  2 ++
 14 files changed, 83 insertions(+), 62 deletions(-)
--=-mNu9gnbbKgzuhtcw3oem
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlsOqBUACgkQoUecoho8
xfqVlQ//WEfVaDtKQN2oJhssa4veuL69jlqyXVHuDnGE4+KcBGUlxwY7j0nAWCnT
OpGGBQGTAHnqhRKjFTyAmsb7J1I4Re47+mMqKbKsTGzqKvzo+2DFWxH1rxkUhD3S
Y1wJ2jYFtCqOkON2oJ6oTIPicEfRTWsWt9PfTW2unrRf90jbJ2P30qxKvk11ryj6
+a7ZlyPDYWONuWuNDql6Pjt4/XauBwVjD1n+nx7TtLGL1Hlop8lP5x6aJrFJOHPI
0tF1vF6pv60fTtzG6A+xSuVEYLJFKrIgyIP1XQvXn6iWvfADgX5RA6OemSA3FxaN
8B8RoFHEfJNZVy6t5zi2Wqgm8q9s3l9Ov4B/GyusVJbxtAZ81chnX40LMBJxj5BK
3a0jeTybjor1xvZGBWTO0Jppb8DHKz/aBkjrZxdSnOQtzI5ysW/LJJzy2qzNmu6E
HlVCuUYi7zrHFyVjS7HrdvmjfMBnCQyh/R6kV4jexM7bzB5ZFgAEhdNAw/p7kHo7
oZTnSTFlXCNMVp8bYT/fYNpmrPbGHAKCy7pOmGF9tu1jsIniNwt/Sbr3O+EzZ73Y
4p41TNSLOLZCNnEhzrVGqS6FrG2KoVNvw4t4WgxTtyDRvnuDYRPI1k35y7srNpXF
a38Dypnw/+bc7dXWDv5prLjKLsi3Rjulzkfq+EHjAdzRNuuXZrY=
=QBDH
-----END PGP SIGNATURE-----

--=-mNu9gnbbKgzuhtcw3oem--
