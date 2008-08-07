Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYHGGeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 02:34:10 -0400
Subject: Re: [PATCH] mac80211: fill start-sequence-number for BA session
	start
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240808061542k7fd3e0dat61df0ee77710e463@mail.gmail.com> (sfid-20080807_004217_600254_9FD74166)
References: <1218051926.23048.65.camel@johannes.berg>
	 <1ba2fa240808061542k7fd3e0dat61df0ee77710e463@mail.gmail.com>
	 (sfid-20080807_004217_600254_9FD74166)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GnKFb11XQtRYDHLNVGhe"
Date: Thu, 07 Aug 2008 08:33:33 +0200
Message-Id: <1218090814.23048.86.camel@johannes.berg> (sfid-20080807_083414_131483_EDAB1B1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GnKFb11XQtRYDHLNVGhe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 01:42 +0300, Tomas Winkler wrote:
> On Wed, Aug 6, 2008 at 10:45 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Otherwise, drivers are required to keep track of the sequence numbers
> > themselves, and they really shouldn't be since we already do it for
> > them. I'll fix the race once we figure out how this code should work
> > at all, it's currently disabled.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Finally I know why nothing works in iwlwifi. This is most crucial
> point of correct driver behavior.
> There is direct  mapping between hw queue indexes and sequence numbers...=
.
> This is bad.

Eh, this particular patch has nothing to do with iwlwifi at all because
iwlwifi overrides all sequence numbers anyway.

johannes

--=-GnKFb11XQtRYDHLNVGhe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImpc6AAoJEKVg1VMiehFYwskQAMIIOnYzHXzXyaSqVob/oLS+
d5tSyeYQbcXKW5JHeWrPUJNm2+byJVWASFFCStDcB/B+cYTETG1YKLImapo7ee5k
IcUS0nnwUQkp7JMT4U75bMSeiKOevW8k+UOuBfabOqHgUB0a0vvoSO0Tr6X+kcSq
niesHPRb4e3V6X+bTB4gpNNjuUuFG2Q4+fka+y9jVQvw6uLaJnTdc9MoHqMNi6Fk
Cj2UuSDwWibuCCTZaPoCxzVvKUJz0KTuepk5GIY5Gb6nKqLkKA9bCBdUf0iqv25D
HEjdL8WrGtoABQ4Tf0TtypFDUxVfaAVPwKb6McPxwQwLIucHN6vbbiO2ya11S06F
cTI1E5y8GYaHE1GBu5SBBBkiaBnShLhW+EU9whlxWNFR0UJCywLPgd5F+H20c/0G
EYlr0vZ9JVntySCN04Xqp6piA8hxWm1aLxzIcRRDczpi5/S+8YhV8l+5yyqk3xno
LbzGxW7Ft2hGBOq+Pi/OvqNzcKXMsbmLK7fxwZ7j74ZC4TM7KUmnzQTbu79Mg2r5
wSWSs7df/tL4e67SJNYBt3PbmJkkkKuNbYKtToyrShIU0s9cuWmxg2mwi69L17wy
vBBpDh96eOXmEzOGDXeT5bqRqfmIrFWiHq2ZBAG06JzyhDxP0raSk/9ianQnpJpX
lGZMIfT4yApFgERzKD8r
=jtAu
-----END PGP SIGNATURE-----

--=-GnKFb11XQtRYDHLNVGhe--

