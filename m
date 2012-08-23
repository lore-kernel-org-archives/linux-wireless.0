Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab2HWNvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 09:51:18 -0400
Message-ID: <1345729870.4534.1.camel@jlt3.sipsolutions.net> (sfid-20120823_155122_005790_3D3A09E4)
Subject: pull-request: mac80211-next 2012-08-23
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 23 Aug 2012 15:51:10 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Pyt6er4R/4lhoD0u3xRR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pyt6er4R/4lhoD0u3xRR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

The last pull request introduced a bug so I have a fix, and as we
discussed I'm also sending you the rfkill patch. Please pull.

Thanks!
johannes

-----------

The following changes since commit dcf33963c48e1959c83fda84e336dbb000eefa3f=
:

  mac80211: clean up ieee80211_subif_start_xmit (2012-08-20 14:13:46 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to aba4e6fff8de0c92e53f0e7ef077231e75f7d760:

  mac80211: Fix AP mode regression (2012-08-22 10:55:04 +0200)

----------------------------------------------------------------
AceLan Kao (1):
      Revert "rfkill: remove dead code"

Sujith Manoharan (1):
      mac80211: Fix AP mode regression

 include/linux/rfkill.h |   31 +++++++++++++++++++++++++++++++
 net/mac80211/cfg.c     |    2 +-
 net/rfkill/core.c      |   14 ++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)


--=-Pyt6er4R/4lhoD0u3xRR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQNjVOAAoJEDBSmw7B7bqr4zUP/Rrw2Kg1h0pamhbIJH3zn4j5
v+sVJVRMJdn3fPq5/UUKYitHuuZfkL0xwhtN1iihjXVoh4+t207utVE9YJtl8YfF
G9sOkbHla2wliSjFTIyOjrIANzNE4KcpDl1ULvq5+mldrGh0X/mRDngBp96fK46S
/CKLteo6kkG44yNHD08F0+HE4LUCaXpROxgVM9KiejjCQ0GuEA252VXDwu2fZ8AT
LVoqzOuWbCM0+MuXLnZF0Bk8P/1M5IF6k560x1yiKYaXMiCGo/SUL4HMSoRlAbIA
LwW71RZVG7CmYpez6vT9P0kuOtFVWx5Nw8wotRtsdTVNflCo/pwuSZ12DMVmwSRd
gLxiPdWckVogvPHR6tmBdfClBaWvAe5VtwiNSGp+40oL4/0OPgWvhQ1m/Fj1b9mw
4A6i6BDqUzYXVO+usAk0cI0LsPctWtXw8CAjDD5geE6w7sTkYc8K20lxNt1Niuph
qrYgDaJNm5UmjU3whAP2NZ4zAZIhXsaGNSbiSv8sS5p4Ni7oeNxHTiG7tPmefo9N
HKrmPnCKb0D95FwnmioCpSYtrhtUSx5rvKyktxUGBFcLcGUIYT5ihf6kwCRyOgX/
+0R23bUhVd6WqJtBUNydZuZJxJTBtuqEMtYGDXREUggeY6rW0d4cV7Ak2fiFaRbg
Jaxv2u5s5W+ezrHZNMRs
=IytO
-----END PGP SIGNATURE-----

--=-Pyt6er4R/4lhoD0u3xRR--

