Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZGYIbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 04:31:35 -0400
Subject: Re: wireless-testing regression: iwl3945 scan fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87skglqpb0.fsf@litku.valot.fi>
References: <87k521s2wa.fsf@litku.valot.fi> <87fxcosron.fsf@litku.valot.fi>
	 <1248278121.17896.2728.camel@rc-desk> <874ot2sa51.fsf@litku.valot.fi>
	 <87skglqpb0.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y1cr15o9nu8aaiHgeIeH"
Date: Sat, 25 Jul 2009 10:31:32 +0200
Message-Id: <1248510692.32151.46.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y1cr15o9nu8aaiHgeIeH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-25 at 08:55 +0300, Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
>=20
> > reinette chatre <reinette.chatre@intel.com> writes:
> >
> >> Are you saying that this problem occurs always with wpa_supplicant and
> >> sometimes with iw?
> >
> > I did some more testing and I can now reproduce this with iw as well. I
> > just need to reboot my laptop to reproduce it. I'll debug this more on =
a
> > rainy day.
>=20
> This is getting very odd, I cannot reproduce the problem anymore with
> rc4-wl. Just to be safe, I rebooted back to rc3-wl and I was immediately
> able to reproduce it. To summarise, rc2-wl and rc4-wl were ok and only
> rc3-wl is broken. So something fixed this, I just don't know what.

That makes sense though, I posted a fix for at least a similar problem
that only happened right after bootup ;)

johannes

--=-Y1cr15o9nu8aaiHgeIeH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKasLhAAoJEODzc/N7+QmaZYwP/3Pw1/jNI2XipfaZYMtMOcxu
t9COotZyLmNojx57gTkCl4rTvWVsJIt4RGn3Z4QSbjZh9S0LWvPiGRocry0jIZJM
F2GcuCYhl9nAxezo9BXjJsj+lvksatHw9Rpd1e3Y9GinDNtuyJp+Bo5xB2JNRPrN
13Iv9A+jGMG8/i2nISCrF6ZLQLLenqCyg6aZPb8N2CQS5E+ZetlPdMAewDPOPtS0
wjcwMuYRQ8BAs83HdONu5qXtM4GqIgjgt7uALWDf5v/dVKZeaSRxU/E/0JndLYBI
wEF9IPXXXMIzDa1ufNORJOGMZw+utsBOXmmCsX6iWdnTTn5RaokoaUhaC5hzkBsL
iJd1fscLEpL+MtbVTc+DbOXke7HoYVL4XbAC8Q0exgOY9j5/2B1awzFERlwvXnxF
EWfa4o8GgAq5e5NdjVkHQCWriMWG9cUg0PIidBvVvIkXzHLGjYsamH/iQt2aXrHo
LB1QQjC/aFfvfHpN9aFasxorX9cUioZ8NldPmdYRRBxIufhGgctPuw9hDlm6GtEU
4uv1d3gT7g8d8BMTqYdsRQiVxfDjm29na5e9je9LmG7ZNiRcjJnM4kjDFAyS08GB
1X+/IRFrMqWAz77t9GDafCS/hTmYR1SgWuPsny4s14QECAFdZS7gfH7aZVW6cXdn
nmradGoKBtkIGnf7AfuY
=QJBr
-----END PGP SIGNATURE-----

--=-Y1cr15o9nu8aaiHgeIeH--

