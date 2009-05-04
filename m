Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbZEDQjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:39:16 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241454909.2903.17.camel@localhost.localdomain>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a+hTVDrXxIiR0eiHNmU6"
Date: Mon, 04 May 2009 18:38:45 +0200
Message-Id: <1241455125.8683.60.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a+hTVDrXxIiR0eiHNmU6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 09:35 -0700, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > > +static void print_powerconstraint(const uint8_t type, uint8_t len, c=
onst uint8_t *data)
> > > +{
> > > +	printf(" %d db\n", data[0]);
> >=20
> > s/db/dB/ -- fixed, applied and pushed, thanks.
>=20
> so how sure are you that you pushed it? I don't see it.

Sorry, seems I didn't hit enter. Definitely pushed now.

johannes

--=-a+hTVDrXxIiR0eiHNmU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/xoSAAoJEKVg1VMiehFY7JAP/0d8DoTLK1D5F/12AY3rJsdn
teRrl2FnzZEsWKm/Pt/E2bEMDOzsLQaTxFwXM5czLhfQLyDgEIALS3mJ7rR3vFis
41/wjPXnWRhhOmXvTQZjBakyQktnO0VpzfbFLk9pbS0Fs3WDShkLNHU6+B3Q9cJe
OT04tnD6slv8KB71PbSn93AdTRQ/Um+XfvAkuqJXT44M+Y7qzHcIjdthvjNBn3n2
w3FvUDqwEBT0Nja+fih8NeN5oa9SzX8zPV0h4LabNN6RigF0RKBJiRBdUFdN7E07
5HYjN2d5diz3kj+GVrDIR1wxO/q5L5UpF6X1Tx5+Tk/l2oujp5CKlCGKnBvu1Jr1
1gCB0sE+F1kwofeeXQ8++mswWhyVy1dZscWWCV6eWuz5lDuQ/qS5OJc5IM6lFc3E
hM5vcj4jL6rMrUwLtHsH89sVCAvIPgZ1FkGQSWLEIi2pM5xd/Zaow9ECk450d4ZU
4z/jz8xTerT5WXdLywAwx7JxL4Z3qFtxhcODPZsN2YRpWYlbY0BlQo6xuhUcr5oQ
oLDmsooICL/D1/2XqaGFpBhKfHRXA3nzt85lgPZUQvHHteGwWlsU62X/+AWIr5YA
YRQFQkaOZ4X5z01YHb3euCtyWqiN6kDNNv2POlS6zuvMZxt849sGmfjjGV3C+F0x
CHkQY94YJTpf4KsrFdjt
=c+U2
-----END PGP SIGNATURE-----

--=-a+hTVDrXxIiR0eiHNmU6--

