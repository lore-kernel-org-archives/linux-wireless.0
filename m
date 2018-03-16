Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35196 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752554AbeCPKuQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:50:16 -0400
Message-ID: <1521197408.3786.26.camel@coelho.fi> (sfid-20180316_115020_616137_7FFCE940)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 16 Mar 2018 12:50:08 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-cPHvy5Xr9JggbT630bu8"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2018-03-16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cPHvy5Xr9JggbT630bu8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my third set of fixes for 4.16.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 87de1201ddaa39d4f3fafa9f35ac143e582517e6=
:

  Merge branch 'erspan-fixes' (2018-03-09 13:03:57 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2018-03-16

for you to fetch changes up to 86a2b2043af79deff5cf000c5a08847faa4f2ee0:

  iwlwifi: add shared clock PHY config flag for some devices (2018-03-16 12=
:34:54 +0200)

----------------------------------------------------------------
Third batch of iwlwifi fixes intended for 4.16:

* Fix an issue with the multicast queue;
* Fix IGTK handling;
* Fix some missing return value checks;
* Add support for a HW workaround for issues on some platforms;

----------------------------------------------------------------
Beni Lev (1):
      iwlwifi: mvm: Correctly set IGTK for AP

Emmanuel Grumbach (1):
      iwlwifi: mvm: set the correct tid when we flush the MCAST sta

Johannes Berg (1):
      iwlwifi: mvm: fix error checking for multi/broadcast sta

Luca Coelho (1):
      iwlwifi: add shared clock PHY config flag for some devices

 drivers/net/wireless/intel/iwlwifi/cfg/9000.c     | 62 +++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/file.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 21 ++++++++++++-------=
--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c       | 10 ++++------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 38 +++++++++++++++++++=
-------------------
 8 files changed, 109 insertions(+), 36 deletions(-)
--=-cPHvy5Xr9JggbT630bu8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlqroWAACgkQoUecoho8
xfrx1RAAiRnHhCh9mA/kWsi4PvgVnyu8sgzkRcHFqZe6g+hMchUSzTZAl3YWi52e
TEv/h5LTHFiR376KPrhoQ1mqjxiUjIX1dJhNoTq5VfdxByWp2qbsWEJ3ndTEYNd1
lPkhKhehvJJ1+bU8Cuy2sEtxfqSsuJaxkrgcSb6RCqztcMwzM6l/ggMDqBC7H6bX
TgVfUwD8rQvoO56YcPM4Y5u2aejRXLF0derkhlLoBOggUC9TZ8DqfM6o8w5yqRg6
NTDNWEfcKAS+W8XLXGztg5Mj5iyuVT+/UxlrDRW3Ma2X4FxNyg/n/P2FFxWCaU+x
XlQ/DOiMaM+gn86fTHIHOX46QPB1DeaRVgUyhvgW2fCe5ShGEDgONqYxrLUK/X1b
0X2BEFbpoUR29tn5iIehIcR1nObjJEgea3TutuPVluPllqDJG9uRcbBH/XvsToPu
W7NU8VoWfDEK9wiuyGg4bwSFR8XxHn/ch4MmIDgUqlIcmNv2OswEjADVX9CzeYy+
3OC09gj8gm4kO+HxqeCF+8ccch7ZOJYGgr2FZ24pDC4yO6X/9Ozyl1WfSHNkzOVL
Hz+LoaXn8uGj8BS5CHBvditLpImWSmRjpQjUdLXDI12Cp+G9CuOKKyePMt0i9wHg
OLI2/PPUXiyBb1ECVAtr+tE6n/TRJxGnZ0D/jd0IPHOcAZMXrHg=
=U1Yv
-----END PGP SIGNATURE-----

--=-cPHvy5Xr9JggbT630bu8--
