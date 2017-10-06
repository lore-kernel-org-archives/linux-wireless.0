Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51836 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751841AbdJFLQb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 07:16:31 -0400
Message-ID: <1507288582.908.127.camel@coelho.fi> (sfid-20171006_131639_352186_DA89B041)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 06 Oct 2017 14:16:22 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Gm1Z4aFMQJTFnbFGwbif"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-10-06
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gm1Z4aFMQJTFnbFGwbif
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is the second set of fixes for 4.14.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit c503dd38f850be28867ef7a42d9abe5ade81a9bd=
:

  brcmsmac: make some local variables 'static const' to reduce stack size (=
2017-10-02 16:52:55 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-10-06

for you to fetch changes up to 44fd09dad5d2b78efbabbbbf623774e561e36cca:

  iwlwifi: nvm: set the correct offsets to 3168 series (2017-10-06 13:59:44=
 +0300)

----------------------------------------------------------------
Second set of iwlwifi fixes for 4.14

* Fix support for 3168 device series;
* Fix a potential crash when using FW debugging recording;
* Improve channel flags parsing to avoid warnings on too long traces;
* Return -ENODATA when the temperature is not available, since the
  -EIO we were returning was causing fatal errors in userspace;
* Avoid printing too many messages in dmesg when using monitor mode,
  since this can become very noisy and completely flood the logs;

----------------------------------------------------------------
Chaya Rachel Ivgi (1):
      iwlwifi: nvm: set the correct offsets to 3168 series

Golan Ben Ami (1):
      iwlwifi: stop dbgc recording before stopping DMA

Johannes Berg (1):
      iwlwifi: nvm-parse: unify channel flags printing

Luca Coelho (1):
      iwlwifi: mvm: return -ENODATA when reading the temperature with the F=
W down

Shaul Triebitz (1):
      iwlwifi: mvm: do not print security error in monitor mode

 drivers/net/wireless/intel/iwlwifi/cfg/7000.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h |   2 ++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c         |   7 ++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h         |  15 +++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h     |  16 ++++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c  | 137 ++++++++++++++++=
++++++++++++++++++++++++++++-----------------------------------------------=
-------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |   7 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |   5 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c        |  21 ++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c         |   4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c       |   4 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c         |   2 +-
 15 files changed, 132 insertions(+), 95 deletions(-)
--=-Gm1Z4aFMQJTFnbFGwbif
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlnXZgYACgkQoUecoho8
xfrDvw/+MuewRJdLtqldP0AneoC7IgvOhtqfyZrg4Q8/BIa64TXSeniS4mX6tPpU
4Sskzz8hOw0xJ9nCCrobiZowDMJwVPwzLRJz8QCoruxBnimmlO8xybEkBvJ4Zx+4
e1nA/uW18aNj2+bAgtRWxTajSmpVHyQoT3KnbI7Uvjne9xjJORUSHoxtia219+TH
lenL4vw2deEg1vevwBs2SdmVLagpbGfLAviJZNu+5PSkrPbg+wq8kOO1kDC2lEPD
OgYI8eHc2kbVDQl04olu7XiuafQVuy0PcC+yvTKjuKlhp/IbtI7GgB3QzmAV08gU
EmR9Hp3h+ibE1alwxx2SiHGsCoy/5IgyHHFiMg0c7OLmo1WzO0Pr9rAZgkGVrxOt
IB9Paw8xv/mIMqfoEsWW0yauR6c+z6h7L+d47Frusu/eu7CXj8lxwag904hNW6zt
Fd6WT0iYLbYb4j14ZfMI6A3HjWm+KWTh9CohuqDDyxAsQ4sRDuKCeDShJLxbkU+T
MVE05P2cKeOCJvvpEDmnvPdOoi+HhhXotwhfBnudbBY+oWOmtZdYyiZirxm1ZlVp
1+tyLVw+OtNxVXWKXUTUPbfV1ZeSPbDSvCpaJwDCIHuPIqAEn1Be7fxoktsyfXnN
TcP6RaOrPTcpzDYZUQbIdmko8xXH6s9hA/Oy2vDX8cLecibH3/Y=
=WqIB
-----END PGP SIGNATURE-----

--=-Gm1Z4aFMQJTFnbFGwbif--
