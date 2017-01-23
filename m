Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36090 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751508AbdAWUvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 15:51:02 -0500
Message-ID: <1485204642.2774.60.camel@coelho.fi> (sfid-20170123_215106_744707_77DC6662)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Jan 2017 22:50:42 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ZR0HtU/tq8+DPL7H6ZFK"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2017-01-23
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZR0HtU/tq8+DPL7H6ZFK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

After a long time (too long time, I admit), here comes a pull request
with two fixes intended for v4.10.  Nothing major, just two small fixes
that were pending in our internal trees.  I have some more, but I'm
keeping this small for the -rc series.  More details in the tag
description.

I have sent this out before and kbuildbot didn't find any issues.

Cheers,
Luca.



The following changes since commit 92549cdc288f47f3a98cf80ac5890c91f5876a06=
:

=C2=A0 iwlwifi: fix kernel crash when unregistering thermal zone (2017-01-2=
1 14:58:37 +0200)

are available in the git repository at:

=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.=
git tags/iwlwifi-for-kalle-2017-01-23

for you to fetch changes up to 03c902bff524e0cf664737a33f2365f7837040bf:

=C2=A0 iwlwifi: mvm: avoid crash on restart w/o reserved queues (2017-01-23=
 12:55:32 +0200)

----------------------------------------------------------------
* Remove an extra hyphen from a string that was preventing the firmware to =
load
* Avoid a crash when the firmware is restarted in certain scenarios with DQ=
A

----------------------------------------------------------------
Johannes Berg (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: mvm: avoid crash on restart w/=
o reserved queues

J=C3=BCrg Billeter (1):
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iwlwifi: fix double hyphen in MODULE_FI=
RMWARE for 8000

=C2=A0drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 2 +-
=C2=A0drivers/net/wireless/intel/iwlwifi/mvm/sta.c=C2=A0=C2=A0| 7 ++++---
=C2=A02 files changed, 5 insertions(+), 4 deletions(-)
--=-ZR0HtU/tq8+DPL7H6ZFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAliGbKMACgkQoUecoho8
xfobbQ//VdcvPe8FHkY3bbMp0eoxJyMk1m2/3HoKKqWRIOFa7Zh6j6LEcai7bC5Q
lZzEQferYPEpt6G5Ml5sMPlxWApwyV193Bw3281ShtHmV/857J0k/KjQUPGWDDnv
EQQu7j/q802qcadkgRv9TztDfV+yWmoSiWeIO2Iv4JbCLNt0iagbqD+0LPSpF5ZH
9R95Dy98v+YpRFzrYv+ougWgsbQMcCeKC9G8olzankGGGV+O/Vh/w3ere6/7S99I
c+n+zqj95KSvSk97JH22HHebkud8KxJHKeNyDRBk/8WFzl0VhTLjmUysmkjsVozS
LK4i7GfQd1GDpBJnPxge21ytV+06KK3IjyikQbZZx1QsUjGx693SCLqx/Eix/fBv
nM7Z6InX0WW+3cakUzx2DTtax9jcbDIkM/Zz178ASwMTeMwBTabThZBudOvsoFAR
EKwhKPV/GyaTR8MqFO92lRQyaEMf0nK+sdSE1j/OQwVQztYQ6nNXHLO53HxbUTT4
X9EYqW5fiRPo5Wh2xNRWOz9NdwfGDbEG7GOVVeXgVbbnO5G79u+PSOXUEJptBKcC
bAMjY4SeTJybzUSJcbys2Z0LTakhgo529tdRjCofVUtsvvRP+Imf1ENHyiTv5XbI
KEYjAI2SYStPyd620rz/66NeRqf/PetdF1IyATPU9XE/aQmoDew=
=2Pkh
-----END PGP SIGNATURE-----

--=-ZR0HtU/tq8+DPL7H6ZFK--
