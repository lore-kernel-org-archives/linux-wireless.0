Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZCHNIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 09:08:12 -0400
Subject: Re: [PATCH] mac80211: Update IBSS beacon timestamp properly
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18867.49758.741918.767411@gargle.gargle.HOWL> (sfid-20090308_140452_425640_5DA5F113)
References: <18860.46550.551064.448896@gargle.gargle.HOWL>
	 <1236516770.4205.17.camel@johannes.local>
	 <18867.49758.741918.767411@gargle.gargle.HOWL>
	 (sfid-20090308_140452_425640_5DA5F113)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UyQI44tRk9/sgI0EV77X"
Date: Sun, 08 Mar 2009 14:08:07 +0100
Message-Id: <1236517687.4205.24.camel@johannes.local> (sfid-20090308_140816_668659_E284BA78)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UyQI44tRk9/sgI0EV77X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-08 at 18:34 +0530, Sujith wrote:
> Johannes Berg wrote:
> > On Tue, 2009-03-03 at 10:15 +0530, Sujith wrote:
> > > In IBSS mode, the beacon timestamp has to be filled with the
> > > BSS's timestamp when joining, and set to zero when creating
> > > a new BSS.
> >=20
> > I don't quite understand why, do we read it out again at any point?
> >=20
>=20
> Drivers do, when they do a beacon_get(). And the timestamp in the
> beacon is used to calculate TBTT.

Oh ok.

johannes

--=-UyQI44tRk9/sgI0EV77X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJs8M0AAoJEKVg1VMiehFYqDAP/R0/o547nXc9qtIytYkiZl2P
GkZGCw9GChAdMaSk3LXCnZybqizaTPhuXtg9R6vmDcemH/riyjaVZ7V51TGrgGuF
XKBrezJCSe4lpYVh5baLbWtvyDNif39chkGAv/T1kVV9MhBwKIezdtUBShSw+XD+
p7xBwTClVIf4bycOippYsFLGmMn9wK4X50ieTWhRd45ZQwa6eXQBxdWytI7zmWCr
gRCPB4q1cGGJ8zG4ZDoVNtGCkcTmMPQissjG3dLwX61Zl5RQOkK5uztCRPrhU+6c
FBNnWhIVRegkHxFjJonEWp5ED5IPryAhHufEtoWqU/IV7/LwT176bNC4tVCRll2u
xq1gYnjQWcObuih8baCKvrJlE1G6likKjI1JNB0Eo7yqKXORcW/iBNQplfQWlQBd
X2GlznDP/GyHcdB/7ijr0kjn5i8E/W96xmzK4jABbz+78HyEFcxGPeY3grb5EUhK
EY34VQ88h7Px86bHIji6R7ci4uCm2fy+3alTaP80rd2jQqsYKegDsnX1dwS6ons2
pmZudFFde7zTf2zS6LMKtLi6h4jDKkjSZ+fllY7H3+Mfj8cF6VEgwv3xGPoTXMsK
juoYeYIbbrPJYxViGMkGxKTKoNE7UGsBOS/i9oSjYVUkzAs4D0noXf6Abm/vrlkT
Q3z++YXrS/E8XWOVBNRX
=Ylri
-----END PGP SIGNATURE-----

--=-UyQI44tRk9/sgI0EV77X--

