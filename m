Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39474 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751241AbdBHTBi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 14:01:38 -0500
Message-ID: <1486580477.10952.14.camel@coelho.fi> (sfid-20170208_200331_184784_30CAF699)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Wed, 08 Feb 2017 21:01:17 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MbwadKB63SsqvpopXokV"
Mime-Version: 1.0
Subject: pull-request: iwlwifi-next 2017-02-08
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MbwadKB63SsqvpopXokV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here's my third and final pull-request intended for v4.11.  As I
mentioned before, I concentrated on our bugfix patches this time.  More
details in the tag description.

I have sent this out before, but I didn't get kbuildbot results yet.=20
Hopefully there will be no issues.  I'm sending it out already because
you asked me to send this before 9pm today (I'm probably 1 or 2 minutes
late :P).  It's up to you whether you want to pull it as is or wait for
kbuildbot results.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 8364fbb497f00de21d6d347194fa8b6bbae1d6f5=
:

  iwlwifi: mvm: support new beacon template command (2017-02-06 19:19:27 +0=
200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git ta=
gs/iwlwifi-next-for-kalle-2017-02-08

for you to fetch changes up to 0c8d0a4770cb6863f78a25c8d211f42e9c82251c:

  iwlwifi: mvm: avoid exceeding the allowed print length (2017-02-08 17:54:=
23 +0200)

----------------------------------------------------------------
Some patches focusing on bugfixes for v4.11:

  * Fix 802.11w, which was failing to due an IGTK bug;
  * A few more bugzilla bug fixes;
  * A channel-switch race condition fix;
  * Some fixes related to suspend/resume with new HW;
  * The RF-kill saga continues;
  * And some other fixes here and there...

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: Fix CSA received immediately after association

Emmanuel Grumbach (5):
      iwlwifi: mvm: use the PROBE_RESP_QUEUE to send deauth to unknown stat=
ion
      iwlwifi: pcie: don't increment / decrement a bool
      iwlwifi: make RTPM depend on EXPERT
      iwlwifi: dvm: don't call << operator with a negative value
      iwlwifi: mvm: don't call << operator with a negative value

Golan Ben Ami (2):
      iwlwifi: pcie: Re-configure IVAR table after stop device
      iwlwifi: pcie: set STATUS_RFKILL immediately after interrupt

Golan Ben-Ami (1):
      iwlwifi: mvm: avoid exceeding the allowed print length

Goodstein, Mordechay (1):
      iwlwifi: mvm: avoid race condition in ADD_STA.

Gregory Greenman (1):
      iwlwifi: mvm: fix a print of NSS for HT rate

Haim Dreyfuss (3):
      iwlwifi: pcie: move msix conf functions above other functions
      iwlwifi: pcie: separate between SW and HW MSIX configuration
      iwlwifi: pcie: re-configure IVAR table after suspend-resume

Ilan Peer (1):
      iwlwifi: mvm: Fix removal of IGTK

Sara Sharon (2):
      iwlwifi: mvm: fix references to first_agg_queue in DQA mode
      iwlwifi: mvm: fix reorder timer re-arming

 drivers/net/wireless/intel/iwlwifi/Kconfig         |   7 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  20 +++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  15 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   7 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  17 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   8 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 243 +++++++++++++++++=
+++++++++++++++++++++++++----------------------------------
 11 files changed, 188 insertions(+), 145 deletions(-)
--=-MbwadKB63SsqvpopXokV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlibav4ACgkQoUecoho8
xfr2RA/7BbS46FjNiLbrKmqQrd3T596Td0pZoVeKtNKILwPpfNioWydXf+Ppz5LR
CgRv08AAjuD29meJNIpEp0Ya69zjVMrOxa61QBUfVwPw/qJI97sCDZRF883ei0Dv
a+bWnk2FeUYcbXo453MYTFM4J9ogE3hM+8x5V6e+BWj7FFcb+Cp9VUAFocGKsBKj
tqSMf8+rE758s3bqNmfJfDQkZU+LATlA/2cmMvQhoPXMiBJu/Luc+ej+TD9uIXKQ
wfYb1RmsniZ+2PP3ZiTPx1W4cgGNvKiAvwfXQW5EN9ElfzMovA0/MmFxlvTN5NKB
5ZIHpBLH/AREyYDGRdshnlub5p1H96tRwvE9Bf4MKlWV/ntCZUgXR/YNG6FGBptJ
yHwooF0o9c5sBjo9bovd8jN8Cu8035nHC14mly7PnoOkv8Ouft7+/uh8Fkvh0OkK
0RAZgeWRihiPSsKkjFr2yB1LxddV8YEP8DGUgewx37xp9Q6kRPJzXXwENHGa3vdh
t+6Fq8lua87hCriJ35K4Cj7i7BWjBj2PJYozdfTK0o/Xm7kdP7dcugekDl+NrvKx
VoDBu3ZrXbF+eTr1WG338wXn/LKlzbaKLwEJqmhWajYHqgJyeGqzJmvWOYBCF9wA
idVcrabRoDsaiMEPcwy2PPS6zRTckRHNCDCJOggJHALZPqBoV0o=
=wa6z
-----END PGP SIGNATURE-----

--=-MbwadKB63SsqvpopXokV--
