Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54632 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750867AbcIOSAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:00:36 -0400
Message-ID: <1473962425.5664.41.camel@coelho.fi> (sfid-20160915_200039_469484_4DD49834)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Thu, 15 Sep 2016 21:00:25 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ArFQ/+Lh0+6J9JTbYi+9"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2016-09-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ArFQ/+Lh0+6J9JTbYi+9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

One more pull request intended for 4.9. =C2=A0There are changes all over,
mostly new hardware support, DQA, multiqueue MSIx work, and a bunch of
cleanups and improvements. =C2=A0More details in the tag description.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 76f8c0e17edc6eba43f84952e5a87c7f50f69370=
:

=C2=A0 iwlwifi: pcie: remove dead code (2016-08-30 14:16:43 +0300)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.g=
it tags/iwlwifi-next-for-kalle-2016-09-15

for you to fetch changes up to ace403cf409d68c61ae75e71fd8a681263d73e20:

=C2=A0 iwlwifi: mvm: tighten BAID range check (2016-09-15 20:43:47 +0300)

----------------------------------------------------------------
* work for new hardware support continues
* dynamic queue allocation stabilization
* improvements in the MSIx code
* multiqueue support work continues
* new firmware version support
* general cleanups and improvements

----------------------------------------------------------------
Emmanuel Grumbach (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: bump max API to 26

Haim Dreyfuss (3):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: Configure shared interru=
pt vector in MSIX mode
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: Set affinity mask for rx=
 interrupt vectors per cpu
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: replace possible_cpus() =
with online_cpus() in MSIX mode

Johannes Berg (3):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: make RSS RX more robust
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: remove pointless _bh from=
 spinlock in timer
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: tighten BAID range check

Liad Kaufman (3):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: don't free queue after de=
lba in dqa
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: fix pending frames tracki=
ng on tx resp
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: free reserved queue on ST=
A removal

Oren Givon (2):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add the new 9560 series
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: add the new 8275 series

Sara Sharon (10):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: call a different txq_enab=
le function
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: introduce new tfd and tb=
 formats
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: remove dump of locked reg=
isters
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support new shared memory=
 config API
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: introduce trans API to get byt=
e count table
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: assign and access a000 T=
FD & TBs
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: change byte count table for a0=
00 devices
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: merge iwl_queue and iwl_=
txq
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: support new BA notificati=
on response
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: pcie: change indentation of iw=
l_pcie_set_interrupt_capa()

Sharon Dvir (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: unify iwl_get_ucode_image() im=
plementations

Wei Yongjun (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: use setup_timer instead o=
f init_timer and data fields

kbuild test robot (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: fix semicolon.cocci warnings

=C2=A0drivers/net/wireless/intel/iwlwifi/dvm/ucode.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A011 +--
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-7000.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A04 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-8000.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A015 ++-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-9000.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A013 ++-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-a000.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-config.h=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A02 +
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-csr.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-fh.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A057 +++++++++---
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-fw.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A09 ++
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-io.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-trans.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A0=C2=A01 +
=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-trans.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A014 ++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |=C2=A0=C2=A079 ++=
++++++++++++++
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A022 ++++-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A0=C2=A04 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/fw.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 109 ++++++++++++----------
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/mvm.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A09 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/ops.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A02 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A08 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A036 ++++++--
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/tx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0| 175 +++++++++++++++++++++++------------
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/drv.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0=C2=A05 +
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 127 ++++++++++++=
+++----------
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/rx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A016 +++-
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/trans.c=C2=A0=C2=A0=C2=A0=C2=
=A0| 247 +++++++++++++++++++++++++++++++++----------------
=C2=A0drivers/net/wireless/intel/iwlwifi/pcie/tx.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0| 384 +++++++++++++++++++++++++++++++++++++++++++++------=
-------------------------
=C2=A026 files changed, 896 insertions(+), 459 deletions(-)
--=-ArFQ/+Lh0+6J9JTbYi+9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJX2uG5AAoJEKFHnKIaPMX6XqEP/02bVrARreCYYAwDFZ0EkCO3
81WUNosXMq80VFBy7vCduffXXbEyQsuHGSZRT04+4oS6YYYQYfyOlrGDnf44i6H5
xD25aEacQwHyytutU6gGO4jsWSz8P+gWBFZ9g6rf3vhyIfabbgSyeRar4TYR134V
J6oND89b25+7Rd0IkEIsVP4zGyG7Y0GrKtP9StTEeCzTL4YmIJk/GA5m44hcUN1x
54BT63qe02neQjWispmY3eGQSffyiB1WQKshJAhX3ibKrYyG5KJQIIfuYvJaHTQf
5k+Iiz2Y3F4+mkfBakiLUG0TtlrHXao2TL3l/kxUymvSJGWII7knuB+W2I4BboAk
WZi5GYa4RyICJBEMgBREItrnLZqqcWTTNQSCVNQ093Y5WW+F9N/WvbNxuPYs5EZR
KWJkdLqZvnFDmNgORFZ7nJY8Pvla2NdpAH5ZYJvl9nyeV/sbg9wIBGmWv4lmboTb
hDVjPfwjqmzX6wf/UM95wjlefo7fokaVF5esG58i78ezlsTHqOxzuL7LkqzS9nJ8
DRsWs5vFggI1zxr7XWCgL9bMA0jkvbBTixqzFEbWIyxxupWX6OfYnSnJL66F03PU
thFq54RxU5dsczs2oB0J1XpeZV45d/rY1Qz+kaSPuoNOG+pgSrAFSnkxwuncTPIB
ForoKNe05KqSPqXpwujz
=N/Mh
-----END PGP SIGNATURE-----

--=-ArFQ/+Lh0+6J9JTbYi+9--
