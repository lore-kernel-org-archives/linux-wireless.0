Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35468 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932792AbeCSIyH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 04:54:07 -0400
Message-ID: <1521449644.3786.110.camel@coelho.fi> (sfid-20180319_095425_122417_E2108843)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Mon, 19 Mar 2018 10:54:04 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-KI78u6B9cRCICV/ib1I3"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2018-03-19
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KI78u6B9cRCICV/ib1I3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my fourth set of fixes for 4.16.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 1259055170287a350cad453e9eac139c81609860=
:

  brcmfmac: drop Inter-Access Point Protocol packets by default (2018-03-16=
 15:00:24 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2018-03-19


for you to fetch changes up to 9f4ef1d70f05ebb7f0755545c05ea383be0eeb0f:

  iwlwifi: mvm: Move unused phy's to a default channel (2018-03-19 10:50:38=
 +0200)

----------------------------------------------------------------
Fourth batch of iwlwifi fixes intended for 4.16:

* a couple of fixes for channel-switch;
* a few fixes for the aggregation handling code;

----------------------------------------------------------------
Andrei Otcheretianski (2):
      iwlwifi: mvm: Increase session protection time after CS
      iwlwifi: mvm: Move unused phy's to a default channel

Avraham Stern (3):
      iwlwifi: mvm: clear tx queue id when unreserving aggregation queue
      iwlwifi: mvm: make sure internal station has a valid id
      iwlwifi: mvm: fix array out of bounds reference

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h        |  3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c   | 21 ++++++++++++++++-=
----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c        | 53 +++++++++++++++++=
++++--------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 15 ++++++++-------
 5 files changed, 52 insertions(+), 45 deletions(-)
--=-KI78u6B9cRCICV/ib1I3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlqveqwACgkQoUecoho8
xfrzYA//VL1KBplpK5GNc63VYCDkLMltNepOW5fKCbhfABAmjMlAmk2XHaY8VyUw
3gjh3BBnBnVt00EsnSs3qwKRo9YSFQZAO7r+rFchd3oZBRb+AZqi9vKDf5sW09+A
AIvOsx4So3k1omVrSzMEB6WMkccqRSykdcHpFydsWLGTdXtzhW3p6DWsYl466rad
eqjfVmVnudMZ01TK7Vmkm0sGL9Hv+kubHO9n9EsqI5MOB/QTMEhOPCx7EGYDAunn
UwWOpbPA1GNnh45ncHWqdKtXerVl1Zx12twT7hz89guWPU4Wwv3T+TPkl/3dPx/Y
ZMlTL6PmRDGgoMUyxEzJVO1whgW0sRHy6vUU1QKjK0wOgbMWX2JzYYD2NLaeonFi
LlaW2CsSp5QXLBYym0Q/YNIiuDAqI/lCMSq41cr7yGozHYWdC2r2FeslNL0L9np3
SdNSGzbtiqO3Z5QDdThUB4cwCkyalEbKvs1tVs3mPe++00JPkckD6VgazGocWEem
vfbBjWCky6EoNrUWFP1WUb/noi/fOUGUOXLn5dr3jjAM1WsISrHXK8zIfxpz8eVX
o/jjZPH3vLrcqwZvZw/1dFRdrRVRLTSYlu/ZyEcjr+6jlvFp91kOh9FdlLNMKOPl
nshkhiiMg3gOjA+hc0ejvgdKikTLCde8F3iV71wV95oYotGGa9g=
=YdEb
-----END PGP SIGNATURE-----

--=-KI78u6B9cRCICV/ib1I3--
