Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43826 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750826AbdKCKTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2017 06:19:06 -0400
Message-ID: <1509704342.4492.353.camel@coelho.fi> (sfid-20171103_111915_040068_ECCE8F85)
From: Luca Coelho <luca@coelho.fi>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Fri, 03 Nov 2017 12:19:02 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-q3dQMsT0mXEkvyMD602P"
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2017-10-13
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q3dQMsT0mXEkvyMD602P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kyle,

I have updated the firmwares for the 3160, 3168, 7260, 7265D, 8000C and
8265 devices and added new FW versions for 8000C, 8265 and the new 9000
series.

Please pull or let me know if there are any issues.

Cheers,
Luca.


The following changes since commit bf04291309d3169c0ad3b8db52564235bbd08e30=
:

  WHENCE: Add new qed firmware (2017-10-09 18:03:26 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
tags/iwlwifi-fw-2017-11-03

for you to fetch changes up to c4276b65390d32d33c8263a7e3c8be0db8cccad4:

  iwlwifi: add firmware version 33 for new 9000 series (2017-11-03 12:09:42=
 +0200)

----------------------------------------------------------------
iwlwifi: add new FW for 9000 series and update other ones

* Add FW version 33 for 9000 series;
* Add FW version 34 for 8000 and 8265;
* Update FW version 17 for 3160, 7260 and 7265;
* Update FW version 29 for 3168 and 7265D;

----------------------------------------------------------------
Luca Coelho (4):
      iwlwifi: update firmwares for 3160, 3168, 7265D, 8000C and 8265
      iwlwifi: update firmwares for 3160, 3168, 7260, 7265 and 7265D
      iwlwifi: add new firmware version 34 for 8000C and 8265
      iwlwifi: add firmware version 33 for new 9000 series

 WHENCE                            |  26 +++++++++++++++++++-------
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
 iwlwifi-9260-th-b0-jf-b0-33.ucode | Bin 0 -> 2637216 bytes
 12 files changed, 19 insertions(+), 7 deletions(-)
 create mode 100644 iwlwifi-8000C-34.ucode
 create mode 100644 iwlwifi-8265-34.ucode
 create mode 100644 iwlwifi-9000-pu-b0-jf-b0-33.ucode
 create mode 100644 iwlwifi-9260-th-b0-jf-b0-33.ucode
--=-q3dQMsT0mXEkvyMD602P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAln8QpYACgkQoUecoho8
xfps2w/8CiCbUBpvd9r/Ak+GZDARJnMSAT7WcEQFpFCk6mFf+/Vxz+W25j05OgT4
tvNkkY+OeeUqJJB1KEDw42rQavBoigkDpXWc73TGJ3zk32BfErvoXHKfOhg0TvSD
KXp7RdDcE2ygFYLlgGnT/F/oWGBvipxUrm7Exgl416xJ84M2mnFEu2tx9aXddD+7
2UwjMim58tgjpaoGYoo+wh+im/ehj+2S3Jm+/YGBw25rMn1Tg/yEv4hhKmaky1Cx
AyFR6DHMRyYjfBRAP1lB1mkH/LLNHRPftK4qPGJikYt3F+7mWDh1y1LvyJC40w34
ol8PqFw1PHtgCGPTzoVXHoByCWh2IAiL+np6q9S6x+9HKqPJ1tIFMVqWkkjIGMa2
spy6CAYi174cQjCyWPqCUlWRuenWThFwwx1ErjmoVSfmXdA/BZHIm5iHN15WHcL1
9ycx9SRkz3f+bvW34JS0cdezt8cBqx4d4ighp1zhUAnd6QPWsgBFuJl/xVsFZqY1
My0ILGLzAikzGXYaHWs03kxMIjDor8JSkiJ77r0E3w6dc9/5RnxJBjzv2lkwsyau
CWztJU0zDQUEXnr2v0CQ/7BcJPHTUlPo0C9sO4kipwDmY7VGDOKKur0zn7dEsUfQ
R7Orh5FYRCqKD82Jf83FCaaKTR8GSl9Bb09qBOwi5IsXIBWELWI=
=2AmB
-----END PGP SIGNATURE-----

--=-q3dQMsT0mXEkvyMD602P--
