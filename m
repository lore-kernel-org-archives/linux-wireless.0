Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYJ3ObK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:31:10 -0400
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1225369608.3690.43.camel@johannes.berg> (sfid-20081030_152503_051723_2131F9C6)
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 <200810251228.17562.IvDoorn@gmail.com>
	 <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com>
	 <1225008571.3478.14.camel@johannes.berg>
	 <445f43ac0810261334y7c064785gbf83efe3ab00cdf9@mail.gmail.com>
	 (sfid-20081026_213518_519033_70F09A6B)  <1225369608.3690.43.camel@johannes.berg>
	 (sfid-20081030_152503_051723_2131F9C6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/tCpyFeMfZX4TxDf/ssC"
Date: Thu, 30 Oct 2008 15:31:07 +0100
Message-Id: <1225377067.3690.48.camel@johannes.berg> (sfid-20081030_153115_408722_902D1D71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/tCpyFeMfZX4TxDf/ssC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 13:26 +0100, Johannes Berg wrote:
> On Sun, 2008-10-26 at 13:34 -0700, Javier Cardona wrote:
>=20
> > >> > For rt2x00 this would turn into:
> > >> >        FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS
> > >>
> > >> With the above configuration, will the rt2x00 device acknowledge 1)
> > >> unicast frames addressed to itself? 2) unicast frames addressed to
> > >> others? 3) none of the above?
> > >
> > > It should always only be (1), mac80211 might set OTHER_BSS if it (wel=
l,
> > > the user) wants to see traffic on the same channel from other BSSes.
> >=20
> > Good.  My concern was that FIF_PROMISC_IN_BSS would disable all
> > acknowledgments.  (I've seen some wireless hw with that behavior)
>=20
> Just for the record, (1) is the behaviour mac80211 needs, and hardware
> that behaves as the one you've seen wouldn't support FIF_PROMISC_IN_BSS
> at all, and consequently not mesh either, I suppose. I'll add a note to
> the API page.

Uh, I suppose we both meant FIF_OTHER_BSS. I did, at least.

johannes

--=-/tCpyFeMfZX4TxDf/ssC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCcUnAAoJEKVg1VMiehFYfrwP/AlpLJiPbaGlFyyq86yJsMCU
ApOmhnNwxxWcwT11VjGbLEVdJajLjGsE7XD7TtmJoVTGAeEwI6PZkZrM1Lo3Uuzr
epfSwHP2SfjlGaNJaFozv3/Qm0d+dotYyEAZdpQm3xnPfQjfjb/sh6rD631NqFl2
auEYWsWYYPsM2ko3GZh66J59ws4/9c/aY1+K0mMrtUDOKI0iYL+nvkv4DaV5CQ6D
u7gINuGV+hLFKMJkz7M3NWf2/l97+WFNCt10HCTR0bXFSVglWC9h62RR2G9QbMku
7kB2JlZCU1sdtZexxB2UkmpNip9IXOvAAnaM6GbqgWqQ46dZEUpLcRPhbIEXF2rY
sllKsKz+6A87DEZYkK8nfkfqQRFn1KddbwaxZ4U9i47JWBstM542wtTfP4Ud1pMp
O9jWSjdS6VzZ1qNW05Vwnt9vGgTLv4Rgfdem6TxrGot9+YxfvYGOZ5TXz6h/gXvn
pNC3NYbIw5EPTa3zbSLpnA6iL/q/E1jzlOGP3y+1+1cgE29h3p+PeHGJ1hYG2Ans
ed+MVpuNmPfAjcoKV4tubChcgpWvBtDoEafGVg4s/KZaritf5NdMaodUnl/4fQ+F
ZoFqKTVDEjmZ1JSCjuR1NBCGh7jneygMWcO5imv8KkJFXvbfcDQLZP3wKgJwMDuM
qxrje7P0eCp55LvczxV3
=+83S
-----END PGP SIGNATURE-----

--=-/tCpyFeMfZX4TxDf/ssC--

