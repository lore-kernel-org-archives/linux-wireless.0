Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53996 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759106AbdJRKaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 06:30:07 -0400
Message-ID: <1508322604.5497.156.camel@coelho.fi> (sfid-20171018_123010_535596_2BAC968E)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Wed, 18 Oct 2017 13:30:04 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-2fuVNpcuIrESSbC9o8jD"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-10-18
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2fuVNpcuIrESSbC9o8jD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's the second batch of patches intended for v4.15.  It contains the
last patch set I send out with v2 of the lq_color patch.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 66cc044249603e12e1dbba347f03bdbc9f171fdf=
:

  bcma: use bcma_debug and pr_cont in MIPS driver (2017-10-17 17:22:07 +030=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-10-18

for you to fetch changes up to 3c798a45318e098e9937b0fee1e0cf986174fbbe:

  iwlwifi: pcie: remove set but not used variable tcph (2017-10-18 13:02:01=
 +0300)

----------------------------------------------------------------
Second batch of iwlwifi patches for 4.15

* Allocate reorder buffer dynamically to save memory;
* Fix a FW dump problem in the A000 family;
* Fix for a statistics gathering issue (v2);
* Sort the list of 9000 devices to make it easier to find entries;
* A couple of cleanups in the FW dump code;
* Remove some unnecessary variables and fields and calculations;

----------------------------------------------------------------
Beni Lev (1):
      iwlwifi: mvm: allow reading UMAC error data from SMEM in A000 devices

Johannes Berg (3):
      iwlwifi: mvm: allocate reorder buffer according to need
      iwlwifi: mvm: pass baid_data to iwl_mvm_release_frames()
      iwlwifi: pcie: remove set but not used variable tcph

Liad Kaufman (1):
      iwlwifi: mvm: add missing lq_color

Luca Coelho (3):
      iwlwifi: mvm: move umac_error_event_table validity check to where it'=
s set
      iwlwifi: define minimum valid address for umac_error_event_table in c=
fg
      iwlwifi: pcie: sort IDs for the 9000 series for easier comparisons

Sara Sharon (1):
      iwlwifi: mvm: remove duplicated fields in mvm reorder buffer

 drivers/net/wireless/intel/iwlwifi/cfg/8000.c     |  3 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c     |  3 ++-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c     |  3 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 20 +++++++++++++++++--=
-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 43 +++++++++++++++++++=
+++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 49 +++++++++++++++++++=
++++++++++++------------------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 44 +++++++++++++++++++=
+++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 10 ++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 17 ++++-------------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 84 +++++++++++++++++++=
+++++++++++++++++++++++------------------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  5 +----
 13 files changed, 184 insertions(+), 102 deletions(-)
--=-2fuVNpcuIrESSbC9o8jD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlnnLSwACgkQoUecoho8
xfq1Kw//be4RA5BBR+YVNH1KfuSqjjdnbzY14cr97pZBXmTKPnaX/58IV2IlMLP0
PK3EGLxGB0470SqjQNExRtGK2QjLpvGRBJ0l0sMH7roJsS9y0Rj7T2Pj3z4y30S0
LT2+a9jCLZbeCFuJLGyAvK5+P/Y94IP9X2SpEa1ol42Aw73mIi/aR8x8NZ8lhOQJ
onk+Enh/nZLEdVkWjXAILi+LG6zo4C8vjIZhfVShAHUSXG92+I11SJKTNTFVblhV
EOEJVyZm17gTzFyp0hYfXr0ZaIFe4UCRtPdTMHqR0UyCld5+f2NHiKsf2j/+aGpY
QeqcK9ipjexqp4ZmS88c0lHZNC0j2tXoTi4eTZl1G418NLggAAN8c3eC9lT9cX7Q
3gCU0KaQxTbFWELpUtYxx6k9EiXG6I2aPheiyf1P/hzX+VLHVzhdEZ8s+decda0/
rckzGVKkcZe9mxsXuoKZx4y2qv1IaCMl/8AemCr5UhsRYmDI8RhL/28C4hzryY1E
E5zmdfYuOUBu/J24TYFYc6R3nf2BXekcIdcqrNTK5xrbEG7d1Byn8E10XErTVMTi
Vk7pAc0Ab3Gm2E7fcK6SSlM7lsm902FhqNC4x/ArjFCWEwr22zjCo/I3IgBGrJk5
zhG84qRya78u5adJGDK8Rtz3VF904Z2icrfIV6kMBN/LXK4LKAY=
=K66S
-----END PGP SIGNATURE-----

--=-2fuVNpcuIrESSbC9o8jD--
