Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753038AbdKORqL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 12:46:11 -0500
Message-ID: <1510767968.4011.124.camel@coelho.fi> (sfid-20171115_184613_840389_029B9AE2)
From: Luca Coelho <luca@coelho.fi>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Wed, 15 Nov 2017 19:46:08 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-D9TISi1WPewe89zi4vwz"
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2017-11-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D9TISi1WPewe89zi4vwz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kyle,

This pull-request supersedes my previous one.

I have updated the firmwares for the 3160, 3168, 7260, 7265D, 8000C and
8265 devices and added new FW versions for 8000C, 8265 and the new 9000
series.

Please pull or let me know if there are any issues.

Cheers,
Luca.


The following changes since commit bf04291309d3169c0ad3b8db52564235bbd08e30=
:

  WHENCE: Add new qed firmware (2017-10-09 18:03:26 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
tags/iwlwifi-fw-2017-11-15

for you to fetch changes up to 85313b4aa4ef0c2ce41bbd0ffdb9b03363256f28:

  iwlwifi: add firmware version 34 for new 9000 series (2017-11-15 19:21:16=
 +0200)

----------------------------------------------------------------
iwlwifi: add new FWs for 9000 series and update other ones

* Add FW version 33 for 9000 series;
* Add FW version 34 for 8000, 8265 and 9000 series;
* Update FW version 17 for 3160, 7260 and 7265;
* Update FW version 29 for 3168 and 7265D;

----------------------------------------------------------------
Luca Coelho (5):
      iwlwifi: update firmwares for 3160, 3168, 7265D, 8000C and 8265
      iwlwifi: update firmwares for 3160, 3168, 7260, 7265 and 7265D
      iwlwifi: add new firmware version 34 for 8000C and 8265
      iwlwifi: add firmware version 33 for new 9000 series
      iwlwifi: add firmware version 34 for new 9000 series

 WHENCE                            |  32 +++++++++++++++++++++++++-------
 iwlwifi-3160-17.ucode             | Bin 918268 -> 918268 bytes
 iwlwifi-3168-29.ucode             | Bin 1036372 -> 1036372 bytes
 iwlwifi-7260-17.ucode             | Bin 1049340 -> 1049340 bytes
 iwlwifi-7265-17.ucode             | Bin 1180412 -> 1180412 bytes
 iwlwifi-7265D-29.ucode            | Bin 1036528 -> 1036528 bytes
 iwlwifi-8000C-31.ucode            | Bin 2309768 -> 2310116 bytes
 iwlwifi-8000C-34.ucode            | Bin 0 -> 2448976 bytes
 iwlwifi-8265-31.ucode             | Bin 2303024 -> 2307104 bytes
 iwlwifi-8265-34.ucode             | Bin 0 -> 2440780 bytes
 iwlwifi-9000-pu-b0-jf-b0-33.ucode | Bin 0 -> 2632620 bytes
 iwlwifi-9000-pu-b0-jf-b0-34.ucode | Bin 0 -> 2677620 bytes
 iwlwifi-9260-th-b0-jf-b0-33.ucode | Bin 0 -> 2637216 bytes
 iwlwifi-9260-th-b0-jf-b0-34.ucode | Bin 0 -> 2677772 bytes
 14 files changed, 25 insertions(+), 7 deletions(-)
 create mode 100644 iwlwifi-8000C-34.ucode
 create mode 100644 iwlwifi-8265-34.ucode
 create mode 100644 iwlwifi-9000-pu-b0-jf-b0-33.ucode
 create mode 100644 iwlwifi-9000-pu-b0-jf-b0-34.ucode
 create mode 100644 iwlwifi-9260-th-b0-jf-b0-33.ucode
 create mode 100644 iwlwifi-9260-th-b0-jf-b0-34.ucode
--=-D9TISi1WPewe89zi4vwz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAloMfWAACgkQoUecoho8
xfruKBAAvC6HlsK2EjhyX69mahDLUDRSf8z7PkyUC3aPIS20KjUIWSThfJNNndtV
WiU1Gg/IVSBOmQ6giMipIvRzhaG6ozEa1Zff0fI3uCMIEoFzAQP0KDSRpLc4dvXu
c48Wj14PBwYkPjJHAKKhG261R5Hec3XNJzsiU2Aj8Ir4hm+kkIKL8T/mD7hEhntS
Hr7pbW8l7qFB7HIFZwGH2BQQd4mItb+p8zQi/jFh+QtuKIxoA+iEXK4iDnKPPJkC
ks+QyXjblgtdpCqrezmEqFKlrjlqIbCEZ7m6oHcZKSPvfE8SuScLElT3yo74/4jM
XE0CVSpru5IKqabXM5Cf020w4y3TVHH2WZKwj9jDsZ7zupQR9HGaeOkRdqbV8fqE
m5lpaMP4LLjpZ8vwAymGBcJplqKViImaUdDrnkcyRA467KufrwSgl2F2r1tUzLU1
LXtuMTBBxbbWPB764VRv5/kYY1RELOSROQ2jxmaoUpOGJV3H1MigrdqU5IS90DIa
nRg98IbeR1DirEYWfaK7ij+nTjLX/YMgUUHFn4ofgTsS5S8r7/BqgC6zgmnlWvSp
14eRhC+Zz3f1IdSvocrlcBxPfFPeAep+iNJuXyUGkrm35oxmQydds+bFOc5XrVTD
bnviox1a26PzyHZn8TBucsiu9KoiQBflY98abciHFxRMgto3yC4=
=GfOG
-----END PGP SIGNATURE-----

--=-D9TISi1WPewe89zi4vwz--
