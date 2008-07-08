Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYGHKEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 06:04:15 -0400
Subject: Re: [RFT 1/4] mac80211: make master netdev handling sane
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87tzf3p1no.fsf@nokia.com>
References: <20080705234735.210585000@sipsolutions.net>
	 <20080705235012.501072000@sipsolutions.net>  <87tzf3p1no.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C1u/pZWxfIp+2bRtAs3O"
Date: Tue, 08 Jul 2008 12:03:27 +0200
Message-Id: <1215511407.9610.18.camel@johannes.berg> (sfid-20080708_120419_090350_0113979C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C1u/pZWxfIp+2bRtAs3O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Are there any devices on the market which properly support PSM in
> Ad-Hoc mode? At least N800/N810 don't support it.=20

I haven't got a clue. I didn't even know the N810 supported ad-hoc until
I connected it to another network and it saved it ;)

> I have heard that the standard is quite unclear regarding this. And,
> after seeing the countless ways APs have managed to break PSM in
> infrastructure mode, I can only imagine what kind of interoperability
> problems there are with PSM in Ad-Hoc mode :)
>=20
> So I think we should forget PSM in Ad-Hoc mode, at least for now.

I briefly looked at 802.11-2007 and couldn't really figure out what is
required and what isn't so it does seem a little unclear. I agree with
you on this point, if somebody cares to research it should be easy to
add back since we're not removing the AP mode code.

johannes

--=-C1u/pZWxfIp+2bRtAs3O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIcztrAAoJEKVg1VMiehFYuiIQAJsHJhyEOUjBHpbEd5OPOojD
Tt97+CYUs99RhxMTxpJqFa69oumrgLxqC3KkgdaraeD9jmoxHNHypvNn9uFQliB0
t/MyFe0kmeiFCujdOvHlgWED5AyG6iWOF5Riii9ENi1wJpkG90SfXj7FWMnRzAWU
olo6DCaaU1m7jfOsOUieKtZZEuvnRZXxqYrDSciUz5GkahXUhoBe61djHS8Canqj
V3JrLLU5BgsLnwHfs0IqG9l0ViaNhD2s2smrX+yXP0g2GKcgSWR4EAl7iaEGk3RM
ZREKX1xMyvC0Bhcyz/JrvQAYm9vDUYGVkzDdXZHBOK+ffBDPygTqmnPEQ58WmpUZ
74bUqtrqPiNZzYkIlZjzLdYC+T4m7+xkA07FrRVHOOwLC6EeGIm23IS3mo4I9Ozh
gyefyeO+mpOTZTB5KHikrvJdZQPUwDL9xDmH7S+FIcY9FIVHYbZ56a6Vv+Ehc4/k
NpV1ok24QqwwWKYbObjW0kzsI+iO9myhZ+TXoSsWZqzt5ulaJr7ejhuGAl783AvW
dtc5dcEwxQhdv/dPmsbwPs66zIGuenfASrprG+qMDyK77YamSleYR3u0nLp0i0y+
PJQ+fz3yGa1hdTJFWssN9vqacudY5g1gZNAryvq9pMBNDuonZsFIa8eYeYZpeGvl
eEbz7A34z9DLMdIcm5EF
=4P42
-----END PGP SIGNATURE-----

--=-C1u/pZWxfIp+2bRtAs3O--

