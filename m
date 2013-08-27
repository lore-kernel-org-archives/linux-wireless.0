Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3H0IyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:54:18 -0400
Message-ID: <1377593647.20012.2.camel@jlt4.sipsolutions.net> (sfid-20130827_105424_735579_759CEB93)
Subject: pull-request: mac80211 2013-08-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Aug 2013 10:54:07 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Np892Orale4e6OjrUup7"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Np892Orale4e6OjrUup7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I know it's late, but I have one straggler for the current cycle. If you
don't want to pull it any more, I guess it's not terribly important as
it only affects some APs (though those are affected badly and no
connection is possible.)

This patch fixes a regression with associating to some broken APs that
send an ECSA IE in their probe responses.

johannes

The following changes since commit 75a423f493ffdf741acae27bf179cd560f7813d7=
:

  mac80211: ibss: fix ignored channel parameter (2013-08-21 15:33:08 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to d70b7616d9080ec9f868fbd31db5fd4341435d61:

  mac80211: ignore (E)CSA in probe response frames (2013-08-23 17:05:12 +02=
00)

----------------------------------------------------------------
Johannes Berg (1):
      mac80211: ignore (E)CSA in probe response frames

 net/mac80211/mlme.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)


--=-Np892Orale4e6OjrUup7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSHGkvAAoJEDBSmw7B7bqr1MEP/1MQhwOT7DSDToVIpnfDN1WR
gU2q/68NxnHlaQXXHRhg0vdodoh7xznd9M0Yzk6kYuPr7BF99NY/uEV+Foru73L7
109Kn0vDKENy3uGpjy3V0rqNXuS4byxiNpsFj3tKI9pleiLf1/aBkaNA8Nj8jyvT
T0FoyMnQt1TKjnSKir95nyPFWXtliwLp6q+7whMwzoZYzi8eKJzrsehSWEpj/SvI
YDkUijS5WGypjr40+3TCXtLQE7yctxKZNFldb3tIKf/6Zrr37RCgNLsipsAKsdKD
o499nq8FFvaaZBDN5E8eC22jLQtAAw7sanqy93OKnt5hrpcQgoiIN/fIvp8NDRkn
ULh3jR2CzpxKAfWK+9LeGT3ipquC7strTy7AG7gkFNgbIuTRgzpiAZ15IihvbTz9
zpWU+q9mE2H/I1BcNKSHoQz3uoZ2UmV9UxHJGntaFwtK2AJcc5Op0vZe0trSPlk8
yUHXNlTarNClwKA8wK4Njn878mntUwYFaGxNmn3BWmWOLYxNBVKYcGgc21so8ufN
biru3Aup0GPnM4yphgGK4EUXAjJza+xhNYTmUWA0Bblos4HiO5wxbwOH+tJO6WVx
RmsJrKQipZMdmdoGfeErB+XYy75kTlMtVTCPG89d/RPUGrut+vClPs4/bHc+/T6n
hEvfC5mBzq4nA1AkynVh
=odVP
-----END PGP SIGNATURE-----

--=-Np892Orale4e6OjrUup7--

