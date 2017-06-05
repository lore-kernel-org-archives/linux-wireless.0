Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59186 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751170AbdFETAl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 15:00:41 -0400
Message-ID: <1496689233.9478.71.camel@coelho.fi> (sfid-20170605_210046_359721_D4A744DE)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 Jun 2017 22:00:33 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-1bwwqH0Je4dzaYyFHyZv"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-06-05
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1bwwqH0Je4dzaYyFHyZv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are some fixes for 4.12.  More details in the tag description. =C2=A0A=
s
we agreed, I updated the commit messages on the first two patches.

I have sent this out before and kbuildbot didn't find any issues.

Cheers,
Luca.


The following changes since commit 6d18c732b95c0a9d35e9f978b4438bba15412284=
:

  bridge: start hello_timer when enabling KERNEL_STP in br_stp_start (2017-=
05-21 13:33:28 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-06-05

for you to fetch changes up to dc1cd1d5ac22dbcd158c3de62b76ebb80e55d46b:

  iwlwifi: fix host command memory leaks (2017-06-05 21:47:10 +0300)

----------------------------------------------------------------
Fixes for 4.12:

* Some memory leaks;
* IBSS support;
* Some bugzilla bugs;
* Some runtime PM fixes;
* Rate-scaling issues;
* Some locking problems;

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: fix firmware debug restart recording

Gregory Greenman (1):
      iwlwifi: mvm: rs: start using LQ command color

Haim Dreyfuss (1):
      iwlwifi: mvm: Fix command queue number on d0i3 flow

Johannes Berg (2):
      iwlwifi: tt: move ucode_loaded check under mutex
      iwlwifi: mvm: clear new beacon command template struct

Liad Kaufman (1):
      iwlwifi: mvm: support ibss in dqa mode

Luca Coelho (3):
      iwlwifi: pcie: only use d0i3 in suspend/resume if system_pm is set to=
 d0i3
      iwlwifi: mvm: don't fail when removing a key from an inexisting sta
      iwlwifi: fix min API version for 7265D, 3168, 8000 and 8265

Shahar S Matityahu (1):
      iwlwifi: fix host command memory leaks

 drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    | 12 +-----------
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 32 ++++++++++++++++++=
++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 46 +++++++++++-------=
----------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        | 15 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 26 +++++++++++++++++-=
--------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |  8 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 12 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  6 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  9 ++++++---
 17 files changed, 115 insertions(+), 78 deletions(-)
--=-1bwwqH0Je4dzaYyFHyZv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlk1qlEACgkQoUecoho8
xfoDuw/+JFYfjSrDLhR3VLW59xj1rjS4XMATA26+YtrI9gsVtw27WHRJpmMWU3Ub
0PEtD9STPgTlCI8u4sfykNQC0NJgybtycAwP7anYwiOWGK+YxJk/5MQNVvJSLsG/
Pq/26KUmY1IUNiCtQ8w2KyH55AaE4T0fgpXnJGa90h2/XB5UYVZ+j0p9G2F4iZIo
7TEh1icOJKh2dPu7EKUdRFbhBxCsFNUcHobjoaUIX1fO+bueyRGp8NDHVYIb9L7Z
QmGsCp5GVTa1Oi3cAskJCjopv8KYvOxzjjRv/VD5cFinSKPpP3zAuTQMyd/PwZmS
7avz97RuUsVZ0wOhVeE7mbl4ayvfja+O3y7OzjZIBnxzzAqiOYX8ZLxL0QnnsFdy
jc9Q1dS6SDQsak0QNeYmWifSQSYrwwLyP2fDVScVDeV6P8d76PB2GlX59nfvvMWN
OOOYsNmoj/IbZ5rNZIDr9N5J/xzYJ0UjoR5Wvfklci7a779RJYl5TeAqaweUKD+m
Vu6pTm9KvYipgO9hf0WWG6pbhlXarqhtLXoJNGoXpnPy6Romn+QqyaLHOK6V1+eM
NItdC4Nidf3mHn2aa/xft/ZyVT0C+/iVKTTVIzC2vA9V8jKI22Woxh09kK8uLV+D
8hG5r5SZAS34Hwri2xCjoMk+8To+gJipZ1aZqVOaHqFBOYQwbTo=
=JtGn
-----END PGP SIGNATURE-----

--=-1bwwqH0Je4dzaYyFHyZv--
