Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3E0NLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 09:11:55 -0400
Message-ID: <1369660310.14740.12.camel@jlt4.sipsolutions.net> (sfid-20130527_151158_294786_1950B718)
Subject: Re: pull-request: mac80211-next 2013-05-27
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 May 2013 15:11:50 +0200
In-Reply-To: <1369658569.14740.11.camel@jlt4.sipsolutions.net> (sfid-20130527_144301_831846_51777608)
References: <1369658569.14740.11.camel@jlt4.sipsolutions.net>
	 (sfid-20130527_144301_831846_51777608)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-HM1+2KC9nE1o0+NrQMQW"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HM1+2KC9nE1o0+NrQMQW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-05-27 at 14:42 +0200, Johannes Berg wrote:
> John,
>=20
> I also have a bunch of new things for cfg80211/mac80211. Just like with
> iwlwifi, I had to merge my mac80211 tree, so this pulled in some more
> changes that looks spurious. Again, a better looking shortlog all the
> way at the end.
>=20
> The biggest change this time is my cfg80211 locking and MLME/SME work,
> cleaning up locking there by greatly reducing the number of different
> useless locks. Other than that, some relatively minor things.
>=20
> Please let me know of any problems.
>=20
> johannes
>=20
>=20
> The following changes since commit f722406faae2d073cc1d01063d1123c3542593=
9e:
>=20
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git f=
or-john
>=20
> for you to fetch changes up to 0dd83174762ff46356824217e69daf374f794ba4:

Oh, there was a build error here, I've corrected it and the new HEAD is
now 6abb9cb99f33b20c2f32f18a3ae9cc7543e46edb.

johannes

--=-HM1+2KC9nE1o0+NrQMQW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRo1uWAAoJEDBSmw7B7bqr198P/0RhxlTCXb+NDxZtQBu0ZIsS
q8d+5m2RS/rUvZ3fYYn2Ia4xWoexttDUpVgLqms2eN2+uIiTvnEV2e3KvwXXp+xs
bKauYK6jVgsX34dCrOwET1E3/HYxifs6ueYYh4doma4HANBw0oJTnoL8iLyJ1KQe
CLfZE4R8TNbnMPekcuAUAX+/3QZ/PoD6nSdcskCSWTO/9F0hskME2O24d7LVbWpA
JunyZUQbpweNVPpwwaor2Lp+mc20t/oN2FHXJp1VcKVP7SwvRZ9IF/j5TOhZmnaP
WGJQN5Elav+59uS8/IWBDIdFHZHFoqtiUi3YpEhLqcFFb++UQx4zmEaTYvkLazXY
rIix3wWsrjp8UNXO33JWbECnQEYCWbL9qxBhqArU0EXRuFNvgKxDmqx7SlBoLt5B
mTSqRsBWiznGLZZ2jO43PI0ZYO93b1A7XTJV8AsfpigRcm+RCcAvx6go8g3nKll3
quKsYLOliqlgZyvv5vCM/lEk+tqjfmTOuZPGkcSppTkydS/iNQeIqviBcK5a0Uk7
W4t7yeFgTkbJIg2iiCFzDoRXD9lrFbcL9hf1MfvEhft5BHEVQowwkOSHHZAdZizl
UWgx5pgcJCGkHhGgSldQdTG0boFFnybIThVsDN5C/oJn0AXHKgVPWzjK1rS7f1TT
aLfVNd0/TSX3eYM6SDBc
=cM+g
-----END PGP SIGNATURE-----

--=-HM1+2KC9nE1o0+NrQMQW--

