Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab2IEPf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 11:35:26 -0400
Message-ID: <1346859359.4364.27.camel@jlt4.sipsolutions.net> (sfid-20120905_173529_796160_BEA0E761)
Subject: pull-request: mac80211 2012-09-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Sep 2012 17:35:59 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pobKcwZvz7H49pVIKzn0"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pobKcwZvz7H49pVIKzn0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull (according to the below information) to get a few fixes.

 * a fix to properly disconnect in the driver when authentication or
   association fails
 * a fix to prevent invalid information about mesh paths being reported
   to userspace
 * a memory leak fix in an nl80211 error path

Thanks,
johannes

The following changes since commit 27f011243a6e4e8b81078df1d83608dae31e3d38=
:

  mac80211: fix DS to MBSS address translation (2012-08-22 09:45:05 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 7ce8c7a3433c6d6f4adfec0611d250782f0b4b0c:

  mac80211: Various small fixes for cfg.c: mpath_set_pinfo() (2012-09-05 16=
:06:05 +0200)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: clear bssid on auth/assoc failure

LEO Airwarosu Yoichi Shinoda (1):
      mac80211: Various small fixes for cfg.c: mpath_set_pinfo()

Wei Yongjun (1):
      nl80211: fix possible memory leak nl80211_connect()

 net/mac80211/cfg.c     |    9 ++++-----
 net/mac80211/mlme.c    |    4 ++++
 net/wireless/nl80211.c |    4 +++-
 3 files changed, 11 insertions(+), 6 deletions(-)


--=-pobKcwZvz7H49pVIKzn0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQR3FfAAoJEDBSmw7B7bqrVUoP/i5+TwjpQZ1paA2yzl3IPoWY
/H+sW0Zf2c3FpNM325QHEEHYtHRLR7Ceh/R+5nhpcQQz9Tbbc6hx01E+oMfm1tez
SAKBLoWlTLpshVBLnpz7eA3Sl5ZlN5GJwEZZkCQGUtmhe4HU1oi+sE1OzaUUi+dU
qLWylCsDwbgvF8EMmIk9iG8jr8XPIbbjiYHPOk16eCIM5DehI5fJ57azKvOREi9j
4FR9YzPPGSnTVO2I/HmhUExPjs8FisT7EmWp4XacRgrc+v9sjwiJa/K6+Z25Hxjp
5QlLrhA14+cwHnE07EBBPJDUop37Fj6vdf9VsrW8FnfRjzmhIdLK6yWQGRMp9Pd+
iiPejJHjPe99rUIWJfHPntCpmGd0qK+zUa49pUyuL9dG942WMsIPGMTX0w+DNcdo
h5GNLU4QZ0pE/dbSsoIGdvZA1JNBWaP0ebKDeWUfCmRQiZ6jCV3sTwwCZOC/0Iy0
QBT1CImzwke3RnoddRQqNFhuFJUzs8R32GuaOSmc1LVyh/i4IR3SXRptZp42nw8O
SeULNIYSAA5iKfrWcG9COleSmrJfME4WSXCQ9CmO9YcB2hXZWcn8YDbytXH7Ih8k
OOgKw1b+EF7L25wi6vH7qgNE9lkkxLPUWzKKCl7LvWgvC4rJxFBGU77lzKhdVWjb
inmAZrPUpjqia1RY/yIs
=kBUn
-----END PGP SIGNATURE-----

--=-pobKcwZvz7H49pVIKzn0--

