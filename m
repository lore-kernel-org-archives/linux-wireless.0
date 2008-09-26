Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbYIZThx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 15:37:53 -0400
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <87abe3mdu4.fsf@nokia.com>
References: <877i98iw4h.fsf@nokia.com>
	 <1221819119.10419.75.camel@johannes.berg>  <87abe3mdu4.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cZQ5ZLmCm6XgLLycm7hI"
Date: Fri, 26 Sep 2008 21:37:48 +0200
Message-Id: <1222457868.3798.31.camel@johannes.berg> (sfid-20080926_213756_578196_B5E5AACD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cZQ5ZLmCm6XgLLycm7hI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-20 at 11:16 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > On Fri, 2008-09-19 at 07:43 +0300, Kalle Valo wrote:
> >> Hello all,
> >>=20
> >> Nokia yesterday published stlc45xx, which is a mac80211 driver for
> >> N800 and N810. Webpage here:
> >>=20
> >> http://stlc45xx.garage.maemo.org/
> >
> > quick look at the code
>=20
> Thanks a lot! I didn't send any code for review yet because, as you
> noticed, the code is in early stages still.

Right, just figured I was looking anyway...

Anyway, something else occurred to me, you should be handling the
sequence number TX flag from mac80211 because otherwise the firmware
will probably overwrite the per-TID sequence numbers. According to the
API documentation, there is a "disable firmware sequence number" flag
which then perfectly corresponds to !IEEE80211_TXF_ASSIGN_SEQ.

johannes

--=-cZQ5ZLmCm6XgLLycm7hI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3ToJAAoJEKVg1VMiehFYcZIP/jnJCOossLoqCJTDyu3BQrxa
DL5C3mmOS9Lblm+ut2VQAV5W00tiNWTdDaPuNNmOAoQK37ySkfFcUulVq3C0bo6Y
L7WEuJ7oW8KGgkt8YX8eHsaNYinMAoNSCrxZxRodshaleN/LoZhSunAW+dlzQjig
YD0Ig6IhiFSM8awCYjsfU0JkNi2Q2ThRkbrnjA6XC2MuGeI04EvktQ8GeLc6IbZK
2bssAFZWDkDcjNApZTYVoPizHiyjwgA9K5UHA2VbmWlhTNWOJm5svMh7YzJ+Tmlr
I5ahW/95i9oNGBysDLUHWKlrxpdscdPeLUnndebHauQ6uePKBrfApfC6t0L1ERWK
yfU8Vmkj1fiTFf8cpTdgUA5KAOhYlzIipcToOYRS3Sw1W9n1c5e7J6SS/rnBFq+G
PzWmMYebmeIxtsF5rhY8sMzybIoYyJ3kiyjdCWYxQKrur+1aQo6njPBmuXp7FvPI
uQ+96Hip342Q1M3zqJpZgoGpPAzNm04j1NpBXQBmlvCHjN2sWmGfESheq+/oOwrR
hzOQk6QNcE2MLVltp3Ri1pL5m1ysBH3XDKSy+Aa0DZZyzgrewSi/RMvbJi+XsSDZ
Z9JozjqUShX9ArQcMg2pDhPJEDW3gDANNMviUd3cBJDLwV7tjgpHNdu5PDflVq5u
vrmzFbJE2BavnWTQJFuI
=Ziw5
-----END PGP SIGNATURE-----

--=-cZQ5ZLmCm6XgLLycm7hI--

