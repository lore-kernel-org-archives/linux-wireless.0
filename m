Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYJZIJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 04:09:38 -0400
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com> (sfid-20081026_022028_483495_EFC3953E)
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 <200810251228.17562.IvDoorn@gmail.com>
	 <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com>
	 (sfid-20081026_022028_483495_EFC3953E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WrUbrOambF3WhFaJYSm9"
Date: Sun, 26 Oct 2008 09:09:31 +0100
Message-Id: <1225008571.3478.14.camel@johannes.berg> (sfid-20081026_091009_145273_39DCD692)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WrUbrOambF3WhFaJYSm9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-25 at 18:20 -0700, Javier Cardona wrote:
> Ivo,
>=20
> On Sat, Oct 25, 2008 at 3:28 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > For rt2x00 this would turn into:
> >        FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS
>=20
> With the above configuration, will the rt2x00 device acknowledge 1)
> unicast frames addressed to itself? 2) unicast frames addressed to
> others? 3) none of the above?

It should always only be (1), mac80211 might set OTHER_BSS if it (well,
the user) wants to see traffic on the same channel from other BSSes.

johannes

--=-WrUbrOambF3WhFaJYSm9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBCW3AAoJEKVg1VMiehFYMK8QAIJG2h6bT5+ptSRY2QFiuXzr
V05OuLIDIB01EPBxxzK80i3CYt92wcQIVeNRiRWDMFohES81ZS2yLQWw6bF3WgDG
o1nf7WmIbgzEpfP3mhUtz9EhpAw0cyAIIzigw1fyFQbm3atdVCybTN78HcScFsqB
hHoNY9omhLkPFhSZaarnoz/g6A/UYQYsmKPC20pdZNRtN3dzR0UAFtZG99txmIUc
Neh5LUBoJFjqNupJD2Xl21i3NiccUf/ceIri6NbgWDDhaJG+FBT8bdrxp4y+L908
qDOZw1dlRF74DMMR7WJVdP6zrXewkhqbmJhJLSoYNDNZ+NanCeUplTL8iU99ZtjQ
WB0DB57/aQgaKtdOSXcUaimK3LMhv1hXO5EGec5ME0mOB8fsEcbJzf0tDoPuIH47
BeBHf3r2TfQjqdN78evkMblBwM0KmTnRmUJ+I4fb8u0kut9mR2vQKMyhMpQle0NV
9uTDc1upQPr9Or6PyG3wJwGx1xkiB5lr7DBbrx4ps6D/lrrBbrY2+2yEOWF3GZA2
fzIgufEN8AgTWu4VZdoAhUllO5ciNuySVDbp0BRMKaCHL7wf2qHaHEMDpTgINSaV
kZQptWgRRs666GST/MZeC8bbk3UjMG+Fi0BYI44Zjmu3sQijVEnrD12AUVFV5xEJ
5idvDxd89mv5ZfjNmaZ4
=+TVy
-----END PGP SIGNATURE-----

--=-WrUbrOambF3WhFaJYSm9--

