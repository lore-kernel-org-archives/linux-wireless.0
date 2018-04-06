Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751623AbeDFGen (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 02:34:43 -0400
Message-ID: <1522996476.4488.4.camel@coelho.fi> (sfid-20180406_083446_983833_EB5B251D)
From: Luca Coelho <luca@coelho.fi>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        Josh Boyer <jwboyer@kernel.org>,
        Kyle McMartin <kyle@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 06 Apr 2018 09:34:36 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Wahm5nPKiHv+/4dE5zNA"
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2018-04-06
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wahm5nPKiHv+/4dE5zNA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have updated all the firmwares we currently support.

Please pull or let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 8c1e439c967a50f0698d61aafdba3841aff10db0=
:

  amdgpu: update vce firmware for Polaris (2018-04-02 09:26:24 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
tags/iwlwifi-fw-2018-04-06

for you to fetch changes up to 50c132306e524dc9038d4a42205921730a3add24:

  iwlwifi: update firmwares for 3160, 3168 and 7265 (2018-04-04 00:15:23 +0=
300)

----------------------------------------------------------------
iwlwifi: updata all currently supported FWs

* Update FWs for 3160, 7260 and 7265;
* Update FWs for 3168 and 7265D;
* Update FWs for 8000C and 8265;
* Update FWs for 9000 and 9260.

----------------------------------------------------------------
Luca Coelho (2):
      iwlwifi: add some new FW versions and update older ones
      iwlwifi: update firmwares for 3160, 3168 and 7265

 WHENCE                            |  26 +++++++++++++++++++-------
 iwlwifi-3160-17.ucode             | Bin 918268 -> 918268 bytes
 iwlwifi-3168-29.ucode             | Bin 1036372 -> 1036276 bytes
 iwlwifi-7260-17.ucode             | Bin 1049340 -> 1049340 bytes
 iwlwifi-7265-17.ucode             | Bin 1180412 -> 1180412 bytes
 iwlwifi-7265D-29.ucode            | Bin 1036528 -> 1036432 bytes
 iwlwifi-8000C-36.ucode            | Bin 0 -> 2486572 bytes
 iwlwifi-8265-36.ucode             | Bin 0 -> 2498044 bytes
 iwlwifi-9000-pu-b0-jf-b0-38.ucode | Bin 0 -> 2520568 bytes
 iwlwifi-9260-th-b0-jf-b0-38.ucode | Bin 0 -> 2521412 bytes
 10 files changed, 19 insertions(+), 7 deletions(-)
 create mode 100644 iwlwifi-8000C-36.ucode
 create mode 100644 iwlwifi-8265-36.ucode
 create mode 100644 iwlwifi-9000-pu-b0-jf-b0-38.ucode
 create mode 100644 iwlwifi-9260-th-b0-jf-b0-38.ucode
--=-Wahm5nPKiHv+/4dE5zNA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlrHFPwACgkQoUecoho8
xfpRmBAAt/cXdsNp1ZXeLCr4pSBN9g1uwTYpm/b8nAxVY2mXb3oJdwd5lmos1G+D
e1Cizb7NQySRE6N1Fuck+KS1RHDLk6XaT/8dV6H6SWhNSZm41qpMZ+KZZe7SxAgh
Xz1PzMTXmd9eE9B0PuO3V/p5Ix5TL4trgOEcBs54Fpmf2lVFHFKC6wfvGqMp1XEX
Uu3rw2K55OpiFvEwNwx9tW6OsTPQEoy+ONvEef6ASnRGsJTpEeLHsgjld8FLnmNo
Jiy30Xj8sdiFpevywut2Lae4KTcLXdNlsVKtuLTVrX1qT3TcCnytrrTKWCao6MUy
B+xGxFkSwK4mwTNd+wNmrvT1NrvWu0BrESW3hGBMYbE+w1vMVuYAWbJA5YZA2UOw
lBjud9g1+LMPAc1O7BCCLoo6Dv76qklbCfUQYrvOJQ8HDydPQl0FuKX+TmP1n3gc
eK0CzUB09E4tbIlUiIkoKWfN4RFDSKN5UKi9fwrQG7u/dHKTw82SWUhkLmTMUWrV
lyn1YF7Xw4+6jTjIB0b0uot3xPJ9N0SSJBUPGkQIVLZGjrcMGt2j/LxxCesA98fc
dN9etimFePSSkc4oiir/4AacN/3UlH+dkfBDOjlnafzOaJ7HAYDXKCVZz4uJV+ht
6gqHfkLKYKuNJCS3sgT2AF56GRbmHHTw9rLFJlJsu6Klij36b9A=
=XCwb
-----END PGP SIGNATURE-----

--=-Wahm5nPKiHv+/4dE5zNA--
