Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYAHRSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 12:18:41 -0500
Subject: Re: [RFC] cfg80211 API for channels/bitrates, mac80211 and driver
	conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890801071527t4125cfbfr77ec2fb47ccffd08@mail.gmail.com> (sfid-20080107_232727_444141_AA835167)
References: <1198448108.4103.6.camel@johannes.berg>
	 <200712231850.37136.flamingice@sourmilk.net>
	 <1199484080.4172.173.camel@johannes.berg>
	 <43e72e890801071527t4125cfbfr77ec2fb47ccffd08@mail.gmail.com>
	 (sfid-20080107_232727_444141_AA835167)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UIL61pDNHgsYtRbilt5w"
Date: Tue, 08 Jan 2008 18:17:07 +0100
Message-Id: <1199812627.6762.3.camel@johannes.berg> (sfid-20080108_171845_034342_5BED84A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UIL61pDNHgsYtRbilt5w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-07 at 18:27 -0500, Luis R. Rodriguez wrote:
> On Jan 4, 2008 5:01 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > Will repost later.
>=20
> Poke

Sorry. The only thing I really did was a few cleanups, but I found a few
problems with it too, namely a NULL pointer deref when receiving packets
w/o STA (so w/o sdata)

johannes

--=-UIL61pDNHgsYtRbilt5w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4OwEqVg1VMiehFYAQK4fhAAtc3io9WTvaStvCZAkCwL1FqFf8KpYHSV
skO22OCQ08uTiaWlr4ynAl5E9jt/TpYVov0rFxle6JVvOLa5SG6ypxRFm1do9ONx
Ps/pSeKPTgNaa+q4Xqcx+WxIS/OyBWyZlj0NawqWLpmfIAp+TZtrfFTDg6RN9Lgm
MYelLB2V4MbPq6R8DE5GTQvasjzP/oGFMJQbhEr8Lse6ap6ZkfPgbvUJO3kTbMff
Khba1gWiRck0geq4gbe9tC992NjtJ/iKgtQ2merql8QdILH7TLThY44S1fn98iIN
ZgBiIgUVlCDzSxrtb4IJG6O/Byishwu0sjXgvp9o4uU/HbGHcyDS4ba0OTQobvIL
KqTCFugE96PFmIJ0zcUHHJntfv6Qf4KxOkek001dNBRyRGSO2riihKen7Rbt+RJv
BRowtZAcDoOJywA8FQFDsQWuBO/oM81OALEL3QhTy6hUBThpTHoL1CVKY2BxZpAX
ca/0yd8AOBFy8uRUmG/IgpDyWMy5QVwCUY6V0JB6yOYcmrOE2YNI5ORp6Nlz8cjG
LkOqsiuxNJaeAMWO6ravoEUqi8+LCzym64g8UopP66lYI2G1sXBMCje44FVepEmi
/7IcE5ITQqbNoXtu7A5neKvTcxg9rsqG04zMFDTL+oO1yabWNTyBbk8lxA2WEUF0
4ZLQqQbkD1Q=
=+zSB
-----END PGP SIGNATURE-----

--=-UIL61pDNHgsYtRbilt5w--

