Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43262 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752498AbdHIHjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:39:41 -0400
Message-ID: <1502264372.15969.167.camel@coelho.fi> (sfid-20170809_093944_126125_213EF244)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Wed, 09 Aug 2017 10:39:32 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-hUl5+axkPYHkfOFU+8Tr"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-08-09
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hUl5+axkPYHkfOFU+8Tr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is the third set of fixes for 4.13.  More details in the tag
description.

This includes both series I sent out, the first one, with v2 of the
second patch, with an improved commit message, and the second one, which
contains the mac80211 patch as well.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 368bd88ebb64cabe4a1ec727659214bb8d693707=
:

  Merge tag 'iwlwifi-for-kalle-2017-08-02' of git://git.kernel.org/pub/scm/=
linux/kernel/git/iwlwifi/iwlwifi-fixes (2017-08-03 11:01:11 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2018-08-09

for you to fetch changes up to 20fc690f38d17b8f961101a477a9aa0841fb6e20:

  iwlwifi: mvm: send delba upon rx ba session timeout (2017-08-09 10:05:01 =
+0300)

----------------------------------------------------------------
Some more fixes for 4.13

* Fix a memory leak in the SAR code;
* Fix a stuck queue case in AP mode;
* Convert a WARN to a simple debug in a legitimate race case (from
  which we can recover);
* Fix a severe throughput aggregation on 9000-family devices due to
  aggregation issues.

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: start mac queues when deferred tx frames are purged

Christophe Jaillet (1):
      iwlwifi: mvm: Fix a memory leak in an error handling path in 'iwl_mvm=
_sar_get_wgds_table()'

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't WARN when a legit race happens in A-MPDU

Naftali Goldstein (2):
      mac80211: add api to start ba session timer expired flow
      iwlwifi: mvm: send delba upon rx ba session timeout

 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 10 ++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  4 ++--
 include/net/mac80211.h                            | 15 +++++++++++++++
 net/mac80211/agg-rx.c                             | 22 +++++++++++++++++++=
++-
 6 files changed, 59 insertions(+), 10 deletions(-)
--=-hUl5+axkPYHkfOFU+8Tr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlmKvDQACgkQoUecoho8
xfovxxAAhmSkBkah2k1c9vOLuwxDYXs7u4TyLmelw7fkRzRkFOX0KXUXCS+OnoB+
PhxB+sIsqb9iysrY6hr5kARcX2o+5mO3CcYrUce7yDzcEgy4aoOSLpEr7qLfcaHM
vHVWl22scYs7MR3NfhHOeBvNNXqcCW/Dg4+9yiah2v1z1GE/QBVlLi+xXDg/7aIs
mtNWdAmzwWm7ieG8EaQ31guzv0D601HyqDukJS+ywA723kF+8kUYgoCAHlAgcETz
LGPhLnyK1KaFWjLrFLMA1FWqYWE4080YpTTWW1KFR1H7w/KVZQx0teKwc74BhEjI
8MdIgp5Ndc10a5hqu0WB9SXWT3QAt4BKG1AYZEmdbcT5z5lwJp8pTZWAkhtWYLXf
edYo/qYZtSn43jkpogYUgC211SJchY8ZzB6bOqyHV+hL9rKOXT3TfuxNbae0/rnS
P9Je3M9IxsdQ4AT9fBLN6bRwlNt+7DOI4SVrdtZ4+wiQ7JmjxXzkjZXSVh81lMTq
PnglECq7HLnM86RI/yWkvrgjM0ONNf5O6MKFqIxTrIFZzS6rBcISkKavEWQJfy0Z
5MUABeRYUCvTZvwH+O9kSbNokzOSz1+S0gMESkhUIDwl7YZvJ1lJ5ePT8s/a4TbS
CYqBqI4eJWZG64s7VfMdutYHxIW3WZeKs9ob3D5BwWTs+ddS0S4=
=XFn9
-----END PGP SIGNATURE-----

--=-hUl5+axkPYHkfOFU+8Tr--
