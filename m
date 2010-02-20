Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab0BTMWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 07:22:03 -0500
Subject: Re: [RFC/RFT] mwl8k: convert to new station add/remove callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100220090345.GK1637@mail.wantstofly.org>
References: <20100219180652.409890561@sipsolutions.net>
	 <20100219180737.156138399@sipsolutions.net>
	 <1266603517.10689.1.camel@jlt3.sipsolutions.net>
	 <20100220090345.GK1637@mail.wantstofly.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/NQJpXwLypX4DhYsEMCV"
Date: Sat, 20 Feb 2010 13:21:57 +0100
Message-ID: <1266668517.12943.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/NQJpXwLypX4DhYsEMCV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 10:03 +0100, Lennert Buytenhek wrote:
> On Fri, Feb 19, 2010 at 07:18:37PM +0100, Johannes Berg wrote:
>=20
> > This converts mwl8k to use the new station
> > add/remove callbacks instead of using the
> > old sta_notify callback.
> >=20
> > The new callbacks can sleep, so a lot of
> > code can be removed now.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>

Ok, then I'll upgrade this to [PATCH]; John, can you pick it up?

johannes

--=-/NQJpXwLypX4DhYsEMCV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf9PhAAoJEODzc/N7+QmahcEP/j+P6fqK6GeD3MbxBCc10acP
94iuInPk9uxpVBMrAWarsA4kBSp8d1nJk55r1rCNKcaT3mnwHF41m922H/NoJP4Z
oeXyJKmVKtrE2Sa8rflFhMGa2AGsu1v00h5yfUGvgE3rWAFj225jZ5v6FbyeFJyR
w+DtiELsauyENE0F5LSMTFOiqInqV1ljIdCBU9s42VKVFxYhwJ5ZGJfiJvtP9agD
5Ob4Np45bDbpv+wtBJTnMLMbScvbrqSfD1OtGnm+KlGm07iS4xC/gtpytInt7+se
ElLBDQ17UXp4MKY9uCg3q1Qb2T9mPjIbCLuygEGX6vWuU0O1KX8gOxxjzUOl6w+R
BZrB3wZMnTO7tTiBLJbu5lpcouleaWjjiGBB7L42qXtcMLjUIKNZNLhGVishYgSL
v3Wl7KrtTWsQXskCnp8I1MQjSp58+VEVFCPMbBvOjRLN2JEh5tRPZyxX6JfcDVib
QxMvbC/6tttWKb9376z9jsEzh+J/v+JQVFgjxWddlnoa4UyWg21witQ6Px33hygW
/708UNNxdNu5mAqn5vwsL4ekL3w4BtNYfFtq0JdusfJ1sIBnNEtcE0XLsVpsKpZH
M2acwe+D4yvexZgZTCGbeArc30CQPU/aGi5nLb5emtv/As6mmCtEWmVPkeBxXn7b
aQ9FU94x7NA1jLfrxZ1b
=jP3G
-----END PGP SIGNATURE-----

--=-/NQJpXwLypX4DhYsEMCV--

