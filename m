Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752435AbdHBSqZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 14:46:25 -0400
Message-ID: <1501699577.15969.23.camel@coelho.fi> (sfid-20170802_204628_568510_89AA9991)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Wed, 02 Aug 2017 21:46:17 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6dnofEqN9mRnrS5cLxFw"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-08-02
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6dnofEqN9mRnrS5cLxFw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here is my second batch of fixes for 4.13.  More details in the tag descrip=
tion.

I have sent this out before and kbuildbot didn't find any issues.=20
Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 5f5d03143de5e0c593da4ab18fc6393c2815e108=
:

  brcmfmac: fix memleak due to calling brcmf_sdiod_sgtable_alloc() twice (2=
017-07-27 14:03:14 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2017-08-02

for you to fetch changes up to 558f479f687aca6a336e13309424a7c3afd32721:

  iwlwifi: add the new 9000 series PCI IDs (2017-08-01 12:26:17 +0300)

----------------------------------------------------------------
Some fixes in iwlwifi for 4.13

* Some simple PCI HW ID fix-ups and additions for family 9000;
* A couple of bugzilla fixes:
  - Remove a bogus warning message with new FWs (196915)
  - Don't allow illegal channel options to be used (195299)
* A fix for checksum offload in family 9000;
* A fix serious throughput degradation in 11ac with multiple streams;
* An old bug in SMPS where the firmware was not aware of SMPS changes;

----------------------------------------------------------------
Emmanuel Grumbach (3):
      iwlwifi: mvm: fix TCP CSUM offload with WEP and A000 series
      iwlwifi: add TLV for MLME offload firmware capability
      iwlwifi: split the regulatory rules when the bandwidth flags require =
it

Gregory Greenman (2):
      iwlwifi: mvm: set A-MPDU bit upon empty BA notification from FW
      iwlwifi: mvm: rs: fix TLC statistics collection

Haim Dreyfuss (1):
      iwlwifi: fix fw_pre_next_step to apply also for C step

Naftali Goldstein (1):
      iwlwifi: mvm: set the RTS_MIMO_PROT bit in flag mask when sending sta=
 to fw

Tzipi Peres (1):
      iwlwifi: add the new 9000 series PCI IDs

 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  5 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 19 +++++++++++-------=
-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 12 ++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 20 ++++++++++++++++++=
++
 9 files changed, 63 insertions(+), 28 deletions(-)
--=-6dnofEqN9mRnrS5cLxFw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlmCHfkACgkQoUecoho8
xfrD0hAAiViM0u7kt9baWsJ8TymGPq4NMMgsMmqgIeHi/KDI1Kqe3OtpbJOXklzd
Bpky/MbpvetQaqJzZeYYheNxvXk97AHRtFXBz5/mA6JgLX4sNPYhXdOarx4QPxtu
n17nSsCehB5rSABJOAE9Cw+hh43MsLQ+IbrojFFRwT/M0sKvuqeyRgMfs+NbtF7X
Fl4P1OdPPSsOufkeMI8m88DOr+z35+2govgGNNYCg8dIlv2Spkfh4TOAvDaQ5qwg
+aslm2NwGJl60P3j5wKVd6C69Kn9aFevrt/LPVtLx8vG2soQuT+LdIzFeXjUWvza
l5We5TlRd9qmoWBwcMjrFJgZXY/rJlnIhUkvrZLeAxQhK3MgXqs3JzfsTqJYMPIV
IQ4pC6yCHpbEs9oAGO94AQLtVEMfUeo6qTQjDVNJ2Bu64E6kANlCzyZdOk7okCrU
0HuPe9rUxjYi9UWcTX3IhbaaOpOK16cKXHlyxMM3HPYtCI7Yf+sEOibVMUXsRK6J
yG5b2Osq8PPk/Myefd5jRLjFBiq+t6kucrEkNZDZob6p3Ah3rN2oiSPvsdDgkipS
J4tZmN3jo1tA8TCpLHVYgNY348mLttZFtPXg03CswAS9r4nI90/g+VqZGOVTqmXf
v2J9TDcq7/tjxkx0RbOPbccF/9v3jBNvt2fdiBEpDWjXEOiYsA8=
=APZe
-----END PGP SIGNATURE-----

--=-6dnofEqN9mRnrS5cLxFw--
