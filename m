Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0AEQQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 11:16:10 -0500
Subject: Re: [RFC] cfg80211: add regulatory hint disconnect support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e891001050814t359807d9y2d7181df9790244c@mail.gmail.com>
References: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
	 <1262683554.20098.10.camel@johannes.local>
	 <43e72e891001050813n5f5cd0bfp7e703902d3979158@mail.gmail.com>
	 <43e72e891001050814t359807d9y2d7181df9790244c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/OYLqdnsRmRbeS5D2h6l"
Date: Tue, 05 Jan 2010 17:16:02 +0100
Message-ID: <1262708162.28653.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/OYLqdnsRmRbeS5D2h6l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-05 at 08:14 -0800, Luis R. Rodriguez wrote:
> On Tue, Jan 5, 2010 at 8:13 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Tue, Jan 5, 2010 at 1:25 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >>
> >> However, I don't quite understand why we need this function. We
> already
> >> tell cfg80211 about disconnect events or requests, can't it call
> some
> >> regulatory update when either of those two happen?
> >
> > Sure, hence the RFC, can you point me to those events?
>=20
> You mean the netlink ones we send to userspace?

I mean the functions we call, like rx_deauth() etc.

johannes

--=-/OYLqdnsRmRbeS5D2h6l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQ2W+AAoJEODzc/N7+Qma7ZoQAMYeJbpfae9DnTYRzdxT1HQL
8yvIixmtwAwB37O/Te33NYSzcetq0/AgL5xBNJLcC+37bgzIwsjV6QDa6/Vl92J2
9A3nZjtRrO3MdGII+O/8pQb9SvoaF0ATc4LFRvtKuy0lLyPol/HvFk+XPW3Q9bDL
TXVtF5ZkUSnw/TCI22BI1yfMJOMhSH6P0FSm+BZsu5CFhSOWYl8Ip2IIFFejNn6T
DtdSsR4M/umKrBTzxrF+hNsPSWe9S849mxUPNypppkAqplpkiS5/UU4F/Rjrxkaj
jKxSYzD19VAn6g3fI70YlkcDVyqMQ+ohZdGnMe2mzkRVPCE1A/aBNJdL5lRm4j66
rRHrOgvdYHWTw1Vn8lslbmm4Fat2HZvAzqGVf0NWAu3STzRo743265DXmhBXbN+M
rW4GiSsTK4Li/wrFKfbhIeAwZCnDQFcd+tYWu23vIlTm6fNqVle+oWp2ks0jE+Ac
iyoA0R9WT8qse/omoaAj6DNjgsrgpO8i5OVIu2xZrWYj7jDk1QJ/LvJCdbtyG5Z0
PxmPRZU/lewhHdszes1nXEbLNJBo/emdUXntVk4Dk/G2WsFH071f5xVBnOIi4eJ1
KoaktZEkyRBaB0NhUW0SnnZN5EQX5pSBa+h6jgs3j/g+EjY/4hT8MHoLgxhvrKUq
XPycobxhF1UM1KmhDLx2
=PfeN
-----END PGP SIGNATURE-----

--=-/OYLqdnsRmRbeS5D2h6l--

