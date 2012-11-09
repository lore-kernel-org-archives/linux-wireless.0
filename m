Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2KITrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 14:47:55 -0500
Message-ID: <1352490506.28302.1.camel@jlt4.sipsolutions.net> (sfid-20121109_204759_841154_B5950E84)
Subject: pull-request: iwlwifi 2012-11-09
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 20:48:26 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-8bSk5Ievt8gLHKrFAvpW"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8bSk5Ievt8gLHKrFAvpW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Two more fixes for iwlwifi ... one to use ieee80211_free_txskb(), and
one to check DMA mapping errors, please pull.

Thanks!

johannes

The following changes since commit 8f7b8db6e0557c8437adf9371e020cd89a7e85dc=
:

  iwlwifi: fix 6000 series channel switch command (2012-10-16 16:28:36 +020=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 31df3bb78be614fb9125abe56972dfee79bd3e18:

  iwlwifi: use ieee80211_free_txskb (2012-11-07 09:18:43 +0100)

----------------------------------------------------------------
Johannes Berg (2):
      iwlwifi: handle DMA mapping failures
      iwlwifi: use ieee80211_free_txskb

 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c     |  2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c      | 23 +++++++++++++++++++++--
 3 files changed, 23 insertions(+), 4 deletions(-)


--=-8bSk5Ievt8gLHKrFAvpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQnV4LAAoJEDBSmw7B7bqrQ7wP/1KM2nRvKmI5TnzzDGMLRVGZ
XU3QWzh0huK7CiHjrqqETh0QF1y7n1LHbPe37CuhNoZR/XW1XnsojG9hA/7BOT2y
Mjx5bj5nuhBGtZfKiX0aE/5KbUD6Eb+nU/XM+lB9KNOJo95HIhqs29ZTXKC8w5/C
B1NcvKhpg8EvF6/zz89/Oc4580o0OjJnr8e5Tjgm9Y6gtXFzfrKSHkn1aJZZffNx
Qa8Cx7KjIUq7HlgPqj90K2MYNojdj4RsAXnO4FptI4yTK6BqWCxgm1D6o8we/NQ0
+jC/0I67vgnZpSqXrqkENLnboRyLHRBenst1My7Uq8sIOvqJvPXEXFdGCxzAGIFm
ZNqXInA9MJH2DsagIQ5IN9Y35TU61YSHcKkFUsw/rr7bpkuZNGmeEl2qmEWGRTzi
LTcOSVo22TIF1yBkflffYb0p3ODQkpBUoNqbgNa6dAMW15tRkpdY0pFfsa6TT5XA
JpRuKnErYWe7Sjbsls27UdKQiWo+kOFwVuJ9KwZ33xhzDYz6G1f1U7hSTU8XPpVA
HYNt8PjlYss5J8dDwU0j0ahn145q79aCYpgHfuRLsF+/7Z0d016kSW4modmXkFbH
t2vPIE+NjMs1ht7Egdm66JH00TeypDlXMH7rOIC+0uSG2MVwJPnsIifbVwLqktHe
NO2R2Kv01rZ5Ka0Qa1Pu
=ndLz
-----END PGP SIGNATURE-----

--=-8bSk5Ievt8gLHKrFAvpW--

