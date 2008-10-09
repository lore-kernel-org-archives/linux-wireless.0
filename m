Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39905 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbYJIJty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:49:54 -0400
Subject: Re: HT capabilities IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810080630n1a1f26f6pab575d2457ce4cbf@mail.gmail.com> (sfid-20081008_153021_291470_B065F886)
References: <1223460098.3618.53.camel@johannes.berg>
	 <1ba2fa240810080540m32134461t26096022d11c6dfa@mail.gmail.com>
	 <1ba2fa240810080630n1a1f26f6pab575d2457ce4cbf@mail.gmail.com>
	 (sfid-20081008_153021_291470_B065F886)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xTL2o6KvaF9Dnd3jIDiT"
Date: Thu, 09 Oct 2008 11:49:54 +0200
Message-Id: <1223545794.22490.23.camel@johannes.berg> (sfid-20081009_114959_451664_3E922DEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xTL2o6KvaF9Dnd3jIDiT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 15:30 +0200, Tomas Winkler wrote:
> On Wed, Oct 8, 2008 at 2:40 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Wed, Oct 8, 2008 at 12:01 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> >> Hi,
> >>
> >> quick question, I can't seem to read that from the draft, is the HT
> >> capabilities IE supposed to be constant when, say, sent from an AP in
> >> every beacon? Most fields look very constant, but e.g. the SM power sa=
ve
> >> mode might not be?
> >
> > SM has to be changed using action frame by the spec IIRC
>=20
> Sorry, wrong answer in, this is only the STA side.
>=20
> There is whole section about Legacy HT coexistence when connection
> parameters changes. But  I didn't spent time on it much so I would
> have to look into the spec myself

Alright, thanks. I think I have it covered differently now anyway. Will
have to revisit that anyway.

johannes

--=-xTL2o6KvaF9Dnd3jIDiT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7dO/AAoJEKVg1VMiehFYGcUP/29DZ5aCddD5ObOq79mKQGUZ
YZ/GkI9OU2bn3Rhm7WU2Yy2Pijh03AoYPwwqKNtIbdTdh6p613PgUnipEco6dWpU
85ZwzU7uJTVaaPntrqQ5aWLrqaDOKNAp+yxoAWjxP2c+b6hUvTiyELJI6qKYve5F
jXLEfh32uvJ2W00b6um4VYDaUHtQqv+DDxOXuCJAImTIRG4FJVVW7i67GPGlD56x
GOSM2/G0mffa1k0kjxSzbnjXN1DGA3m2hZ2+hngzLZF6TN/4Nl4OOQvjV47VkL9U
k44k1QNm1l17HmrF7yKUTWWPZozpKEXMdXn9xRoVoVpclPc4Jp07pYdH9dLXmL1P
lUetevFjJwfmYokh/8KEZkMDpE5WgOIhbtPufkiTicbiLjZOjtoE14KeepD5iPms
tDK93KOg4l/d3BUSHoYQ/5VL8qUQ/cq1KAFSGLzMkIC36lyNnySS3fGz2Ku/IT5Z
4CYYYuoFoNMNbPQ2WXTn1EL+r4VsaYT38BPfNRS35Xfa6vY2IKhT8YH841DFqR0S
xEYXz0SheuPUPNjpDiRGV/gu6f9W34MbqsUjF80aYOWPqJLcHmv/Xg2QLGpAcp3o
XX+PAc97jND3uUHC5gkIg9nIDD+pDcPmZhQN7+AvIRvwu1bwLROEljmDEdzCkwkm
FfuoM3mITYuwOZnHzOK+
=BAlp
-----END PGP SIGNATURE-----

--=-xTL2o6KvaF9Dnd3jIDiT--

