Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2KSQlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 11:41:49 -0500
Message-ID: <1353343331.18299.30.camel@jlt4.sipsolutions.net> (sfid-20121119_174152_904001_309ECC5F)
Subject: pull-request: iwlwifi 2012-11-19
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 17:42:11 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-80FEiXK7Kj9gBh2BK0Ex"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-80FEiXK7Kj9gBh2BK0Ex
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please also pull my iwlwifi.git tree, I have two fixes: one to remove a
spurious warning that can actually trigger in legitimate situations, and
the other to fix a regression from when monitor mode was changed to use
the "sniffer" firmware mode.

Note that the patch to remove the warning is already in wireless-next
because I didn't realize it was needed right now. It will cause a minor
merge conflict, you can just use the wireless-next version of the code
though since it's in there.

Thanks,
johannes


The following changes since commit 31df3bb78be614fb9125abe56972dfee79bd3e18=
:

  iwlwifi: use ieee80211_free_txskb (2012-11-07 09:18:43 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to e1b69fdf33f63cfa600b992172d7376f9d9ef2e9:

  iwlwifi: don't WARN when a non empty queue is disabled (2012-11-18 11:51:=
09 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: don't WARN when a non empty queue is disabled

Johannes Berg (1):
      iwlwifi: fix monitor mode FCS flag

 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 14 ++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/tx.c      |  8 --------
 2 files changed, 14 insertions(+), 8 deletions(-)


--=-80FEiXK7Kj9gBh2BK0Ex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQqmFjAAoJEDBSmw7B7bqrsOsP/RVKkIuQH4tCnQJtva8Qe+Af
mRPZEqOv2+O3xpLQViI8Tb5G9d/G/eqcAJQ6wnoeDu42AwbBcLZTQr62hs4E0iBh
1poyBj8penUp2QN/BB1bfJCzHM/3fjEXdWp5qNSsZhMrAOjxc3X4mt15DJUKNxez
WxSXcmJ1WRZCI4C9Pe89SemcWKMXjyriEPLPqwostTRSyBjzCzD7GCXfnd5NuZLY
hUoU8lXhW74gyNdVlgHVwZcgV558ady++wzTqZXdRgpMknQ88pVrcykcOQDYyc6g
J2QmI5brh0cZFK5OJihfRMukygSt8QFUll7TvZ/YPeJMqmHzCeI2Q+OtlYk2NyR+
XlgfaKorBzzdfLssQ2Ih5gNwD6PKfTIK01ikaUoNmzk5/KMghZxGWWEDsXSN2ZNj
qXqMRR950+gd0iEyWdxqwD7Q/2GBPCxGyDEDBGhPAISmWLl3muet7MSYSJdDdiR6
DW7rIBeOU182FH9ja/P/G/PRsCGvzPNqsLu+TyTpb2OQnE5b1PdYPZ17pg49z9qp
fUKGxrB1z0Q97l5Vc44B/kTxe6H77/2dyOb4lDhtkLFUaV9E0bwmsJ9bcKXXIcr+
KARbBjvytxpaBryKHUG+wqT7AwlaJDrslfopHC06lW8urJFXnYQZfprkFkvd3GbM
PJ87HE2CukzIjhkBgUFw
=3nr5
-----END PGP SIGNATURE-----

--=-80FEiXK7Kj9gBh2BK0Ex--

