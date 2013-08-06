Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3HFIwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:52:53 -0400
Message-ID: <1375779167.8219.5.camel@jlt4.sipsolutions.net> (sfid-20130806_105258_138359_BA270203)
Subject: pull-request: iwlwifi-next 2013-08-06
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Aug 2013 10:52:47 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-63RAk7hz28cngASXZW6a"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-63RAk7hz28cngASXZW6a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

And a few more things for the -next stream for iwlwifi. The signal
strength reporting fix is the reason I'd originally tried to ask you to
not pull before :-)

This time I have a signal strength reporting fix from Avri, some
cleanups from Eliad, Eyal and myself and a new debugfs file from Matti.

Please let me know if there's any problem.

Thanks,
johannes

The following changes since commit 147fc9be81d10e6e863323c0b54e140b42fd1ed6=
:

  iwlwifi: mvm: advertise support for DYNAMIC / STATIC SMPS (2013-07-31 11:=
05:08 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to ef4394b9477f9078d78ae3e8359eae094c9b19d8:

  iwlwifi: mvm: use designated initialization for some arrays (2013-08-06 1=
0:35:04 +0200)

----------------------------------------------------------------
Avri Altman (1):
      iwlwifi: mvm: fix signal reporting for < 3 antennas

Eliad Peller (4):
      iwlwifi: fix some documentation typos
      iwlwifi: pcie: some little cleanups
      iwlwifi: mvm: add some missing cleanups in iwl_mvm_mac_add_interface
      iwlwifi: mvm: use designated initialization for some arrays

Eyal Shapira (1):
      iwlwifi: mvm: remove traffic load monitoring in rs

Johannes Berg (3):
      iwlwifi: pcie: fix resume when no opmode is present
      iwlwifi: mvm: small cleanups in quota management code
      iwlwifi: remove transport suspend/resume indirection

Matti Gottlieb (1):
      iwlwifi: mvm: Add RX statistics debugfs entry

 drivers/net/wireless/iwlwifi/iwl-op-mode.h  |   4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h    |  25 +----
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  | 138 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  17 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   2 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |   2 +
 drivers/net/wireless/iwlwifi/mvm/quota.c    |  11 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c       | 164 +++++++-----------------=
----
 drivers/net/wireless/iwlwifi/mvm/rs.h       |  12 --
 drivers/net/wireless/iwlwifi/mvm/rx.c       |  31 +++++-
 drivers/net/wireless/iwlwifi/mvm/tx.c       |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c     |  18 ++-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |  23 ----
 drivers/net/wireless/iwlwifi/pcie/tx.c      |  17 ++-
 14 files changed, 247 insertions(+), 219 deletions(-)


--=-63RAk7hz28cngASXZW6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSALlfAAoJEDBSmw7B7bqrh8oQAJ8xAgOb0BFJfEVvwBtmJmdv
r0pll92FzLZUtTHgWXP+5MwKaUrKH0Tjky0vLNOHR2DlX+AJE4+ns6XaHGGDYL9U
f0Iem1bUCrTDW369MXcSlWLaPWTVHVQnNzG/o8/JN+5wp9GWIItZCj1tNkJlwNjx
PnVHQCA+Oumaab1AvJDUeuBMVxLSunNk3ebTErViUKo3nOnmrGV7A/WTy/oJq4B6
z3Bddf0yfbSAMytOT1640JmibZrNz/Tq5R4JN1x7qvYFduKyj1y3gkIuIXwk+nmZ
9CMat0WcF0kKE37Fp6yLgW6OBmEnxzAI9vfbDLO5r4Q7yt/02M23fKyTWyUFyNjX
m/MrXiSDtF2qiCV6KZtJAjrG68v7Z+56u/tHHIQ4gZhEETGwcIoTgnUjlmgV9lM2
4L3+Vzin8Q8E1pRVBYT/mD8LgMKoB+/oA5uV5OCngKH1VNPqCZt7W+ckg/HehzP3
c0zr4xLqsz7vkHhPdBd2Fjn78UATDLRv++BkcQO5LEWnmMGaq+Md6CLzJByNDKSa
2+7UPQOCQjo8ZNBAafrSyKwodcuEHNleaytljs/Tz0HXo/+hnk1OD0ZnyKUqnBXY
3C4HzqyI6dFJ3FGtpUm7OpC/V1gNBIyqJYZeubjr4OLqS6DVw097sMgNgk4ioXxk
nZCf4SH+MoHC718jjcOR
=EKgz
-----END PGP SIGNATURE-----

--=-63RAk7hz28cngASXZW6a--

