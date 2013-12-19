Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3LSUWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 15:22:38 -0500
Message-ID: <1387484548.4298.16.camel@jlt4.sipsolutions.net> (sfid-20131219_212242_601472_69D0777D)
Subject: pull-request: mac80211 2013-12-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 19 Dec 2013 21:22:28 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UeNoGlZQH1S5QxVxYj22"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UeNoGlZQH1S5QxVxYj22
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Just before the holidays, didn't you want more pull requests? ;-)
Sorry, but I think this should still go in...

I have a fix from Javier for mac80211_hwsim when used with wmediumd
userspace, and a fix from Felix for buffering in AP mode.

I might not have sent in the wmediumd fix since it's mostly a debug
tool, but hey, I have to send in a pull request for the other one anyway
and it is a simple patch and bad bug, so ... Let me know if there's any
problem.

johannes

---

The following changes since commit bd02cd2549cfcdfc57cb5ce57ffc3feb94f70575=
:

  radiotap: fix bitmap-end-finding buffer overrun (2013-12-16 12:06:43 +010=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 277d916fc2e959c3f106904116bb4f7b1148d47a:

  mac80211: move "bufferable MMPDU" check to fix AP mode scan (2013-12-16 2=
1:44:05 +0100)

----------------------------------------------------------------
Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Javier Lopez (1):
      mac80211_hwsim: Fix NULL pointer dereference

 drivers/net/wireless/mac80211_hwsim.c |  2 +-
 net/mac80211/tx.c                     | 23 +++++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)


--=-UeNoGlZQH1S5QxVxYj22
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSs1WEAAoJEDBSmw7B7bqr098P/08u2dW/QbPNDhz4FYxc5L2i
EL8uaCyFhxUgP0eeOwiDPnovQdhvo4T1HuFczcnAaf1MAdi303zE/2TG58Smvd7l
+C4VCe6Sr57BzYQn2uWtrLPofYlNqoU3EueHInsY22++lJvyHw38Pg+uZHZRO9kf
7enOWOkvrpRpF+sLsG3W3gzsft4plgithzqh48PxPID1NzIhWzFAWPaGiiu4hpU3
J+kTLMF6FarMSzSKvJMSNSLjjCMeen8RUcMWrxYbVS6DoWb+SifFT63YRvrPmkPk
4jGWa2Nc9c5F6VO8XDUF8cpgfPN8s/kA2BIf7lDicrNw3Pghr74hkorsjo5qmiJH
RhU4imuD9rTMfo4SHtxhMIqmxNBPm9x6rwhEwgTxb+inZ3Umur0nwZfwTJ+8OzEt
pHNHMCvS10Dp8PSkLvRvyCCAIJgLtFXvbD79++sZlw3yThjHYXlWGe922BD+L/qS
DCuEPStssd/Z2r36EsATBx3/L4NCCT269HsPs8/d7JgeW3F3yfJ1g3jakiqTQa8C
2M8cH+J7hk6UkdaP6gFLBRPYsKuTb79yYrzP4kkuWpzz8Rq33asPyAiqkg7OYhjy
JuDd8B3Ka3JiryetzToBrb5SxMplFXIPhNmC7by13aZgRZ2n8uzKSPFjFu1/Rs/t
yXb/jOoO1Suh08kUkyLi
=kTK6
-----END PGP SIGNATURE-----

--=-UeNoGlZQH1S5QxVxYj22--

