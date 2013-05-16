Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3EPU7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 16:59:34 -0400
Message-ID: <1368737965.8253.9.camel@jlt4.sipsolutions.net> (sfid-20130516_225938_574124_575DD7D8)
Subject: pull-request: iwlwifi-fixes 2013-05-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 May 2013 22:59:25 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Sf4E5y/rVJPbhFZuNlUs"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Sf4E5y/rVJPbhFZuNlUs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And another one for iwlwifi, much fewer commits though.

I have fixes for a firmware crash during resume, multicast RX,
aggregation and a workaround for a firmware scanning bug.

Please pull. Thanks,
johannes



The following changes since commit 61f1598278876527314f5fc1d00cf0a4d525c1f7=
:

  Merge branch 'wireless' (2013-05-10 09:44:05 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to e3d4bc8cc0230e8dc8033484666f03f87392a8c4:

  iwlwifi: mvm: fix aggregation drain flow (2013-05-16 22:39:07 +0200)

----------------------------------------------------------------
Alexander Bondar (1):
      iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD

Emmanuel Grumbach (2):
      iwlwifi: mvm: tell firmware to let multicast frames in
      iwlwifi: mvm: fix aggregation drain flow

Ilan Peer (1):
      iwlwifi: mvm: Always use SCAN_TYPE_FORCED

 drivers/net/wireless/iwlwifi/mvm/fw-api.h   | 27 ++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 12 +++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 17 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c     |  6 ++++
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 13 ++++++--
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  2 --
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 48 +++++++++++++++++++++----=
----
 9 files changed, 105 insertions(+), 22 deletions(-)


--=-Sf4E5y/rVJPbhFZuNlUs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRlUitAAoJEDBSmw7B7bqrvC4P+gN6uWtEAugycgINvjF3Hdif
YCW4TlK2mtrpTedxH5gNc+69AyZG0o6f+tjFo9ZvnhmyxmBhBZIeYpmsnu+lxx8d
vu5pSAiCUttzE2Fbh3hzogbidsv1UK62/+NlMDMXJe2J1ZWj4e5Nf2fSFkWReNB0
crEgISi71vhEZ6wY9aHAdq5kuV9rlO5Up44rB1NVTTnrDR3Gfs7h3BPBP5DpCV4K
crhgt6nfFTNE1TZCyqVxuinNTzEsZ3to+Qf6AULgTMUxtlWGyQ0KHSsquvZ6jxD9
fbLpt3GpQ5DUfgm9jU69ZznqqtlnbpMASBtJekT77BLO6Nb9HVb7yAp3FNbtqTOi
//FlkZ+sDlOnPiDOpg51+vNcVJVwBAh0Y23A1uUvN8tQH0u0vYqrRRofpiAnjanT
LU6bMkVxHk99ZgxkRA7fNhCmfRIO1t8OVl2vAFpcftOFZjFZDPKfyMsmj28a597h
JnRVIEgcYmSAMha7Sf76qrRqNi16HeVFQ5jsK7Lg/jaMqIZf5CK77pxMbvX+10Vh
8s1cqb+hChn3pqXW6ZdPAwtlu8+M309hC2cBcMJ2qb92lPviwwri5eFJ0MMtLdSq
+ZX7A2fJzF3zmH1st6oJwNEnInGiAUxxcwCMsEUsnhQ0jl75/2Cpx3xwdzcgQR+N
LoXCAZG8EMqhFwZJ66Eu
=DzMN
-----END PGP SIGNATURE-----

--=-Sf4E5y/rVJPbhFZuNlUs--

