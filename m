Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33366 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1423277AbeCBI5d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 03:57:33 -0500
Message-ID: <1519981045.6017.4.camel@coelho.fi> (sfid-20180302_114109_408880_9CD4A41B)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 02 Mar 2018 10:57:25 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-74BOxxMNL55ejlhsDy4W"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2018-03-02
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-74BOxxMNL55ejlhsDy4W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my second set of fixes for 4.16.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 78dc897b7ee67205423dbbc6b56be49fb18d15b5=
:

  rtlwifi: rtl8723be: Fix loss of signal (2018-02-25 09:47:15 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2018-03-02

for you to fetch changes up to de655fa8fb237d0eaf838e8833b464c1dec90070:

  iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default (2018-03-02 10:20=
:03 +0200)

----------------------------------------------------------------
Second batch of iwlwifi fixes intended for 4.16:

* Fix CSA issues with count 0 and 1;
* Some firmware debugging fixes;
* Removed a wrong error message when removing keys;
* Fix a firmware sysassert most usually triggered in IBSS;
* A couple of fixes on multicast queues;
* A fix with CCMP 256;

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Fix channel switch for count 0 and 1

Haim Dreyfuss (1):
      iwlwifi: Cancel and set MARKER_CMD timer during suspend-resume

Ilan Peer (2):
      iwlwifi: mvm: Direct multicast frames to the correct station
      iwlwifi: mvm: Correctly set the tid for mcast queue

Sara Sharon (3):
      iwlwifi: mvm: fix TX of CCMP 256
      iwlwifi: mvm: fix assert 0x2B00 on older FWs
      iwlwifi: mvm: fix "failed to remove key" message

Shaul Triebitz (1):
      iwlwifi: avoid collecting firmware dump if not loaded

Ulf Magnusson (1):
      iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default

 drivers/net/wireless/intel/iwlwifi/Kconfig             |  1 -
 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c            | 13 +++++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h            |  3 +++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h        | 18 ++++++++++++++=
++++
 drivers/net/wireless/intel/iwlwifi/fw/init.c           | 12 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h        |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c            |  8 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c       |  5 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      | 45 ++++++++++++++=
+++++++++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c           |  8 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           |  9 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c    |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c            | 13 ++++++++++---
 14 files changed, 125 insertions(+), 27 deletions(-)
--=-74BOxxMNL55ejlhsDy4W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlqZEfUACgkQoUecoho8
xfoUQQ//aK4r3rhYshMwwiDFGU/B9lfaKBMrwItZbxdi+psqtsaNlCAyF+T/P1ei
4BPfJvpbuFfvvoHbI5WtQ1lhDgslltA+6w0bb8oUc93h11vhOzOx1/v43XYD8HYT
WEQ2BVaAT+4Xt6t9bbt7zgU2qoqi5APOl6YiG3QMvqG+SUbsyfWRsgs43NG1C5yx
0rLDDaVZ77/4y1RFEbwzPuaZaOZ7FTv/lCwbZ1n7ri5spvDfweRs+sNvRfj8r22l
mJHyM4I+GhAPW/TIFjL2AsRVFZijfnamNXzWR8L6QxDtbvlcfEXY28CJv96HqdCI
30xjFeSy7nWuFvIUPK2yUkcnIPyttzSIe4Y1+apWJQLOhXPSWpp7nYeOU2jdDhP4
lzn5O0buT7kjRR5czVIknsjTiEppQpw5859Ikmo+cOTzGhOuEfWUTjMcYPuD+IEP
u2F90m4aZncgDb6EcbDXjK0RJUVPG0JzfPS76ZHCAsDDqWt0pfCjY71ca/8aCX2X
n+UDUnuBAdGtN/87qFCcrIDBBN/hQq8oeDKMQl2zG5N6aplmE+4+tL4mGg8+dpsd
PSHzPFBOhlrDpiOpHq1agIqX9q/h6iIfr0ueiiAZTmDqzRi0imqDiQSEyFhnMDO/
Wck6kPlz1psrNuZw9XPBcGEyQnBwd+HGaQOP1Y66Jc01YESoh+Y=
=3ydg
-----END PGP SIGNATURE-----

--=-74BOxxMNL55ejlhsDy4W--
