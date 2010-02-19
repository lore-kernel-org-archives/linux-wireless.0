Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0BSOTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 09:19:50 -0500
Subject: Re: FYI: needlessly exported symbols
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <22ee4e771002190616h72949c58n72e2e6a49f7ae1d3@mail.gmail.com>
References: <1266572413.3991.55.camel@jlt3.sipsolutions.net>
	 <22ee4e771002190616h72949c58n72e2e6a49f7ae1d3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ouKNZhqSiyD2R9aVB8fm"
Date: Fri, 19 Feb 2010 15:19:46 +0100
Message-ID: <1266589186.15178.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ouKNZhqSiyD2R9aVB8fm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-19 at 15:16 +0100, Christian Lamparter wrote:
> On Fri, Feb 19, 2010 at 10:40 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > According to a little analysis I did on wireless-testing, these
> symbols
> > need not be exported because they're not imported by any module:
> >
> > p54_parse_eeprom
>=20
> p54spi(.ko) needs p54_parse_eeprom from p54common(.ko)

Ah. I must have not built that p54spi.

johannes

--=-ouKNZhqSiyD2R9aVB8fm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfp3/AAoJEODzc/N7+QmasP0P+wYs1pyf6UTxWkfS1qRpjgIg
KjQKcIpMApIpQ04nQ0RwMFJiqpDujkPIvxkwYLxbp+nqcfPcgPiYkLw5fLYWMwai
EXTgA7FihVAfYAz8KTIQGAsHEcAQbKblCW7xNIixR19h9khYISbw/00XXmkZynQB
RrvSXumlLgs7zG9xg+R/7dFBh1xLqUBvPwN901fgaCJFNVfRogDzgPbryaede5LL
wHK7i2hA5Krl/iQiznFw4LnSVb3Ag21glfrv0tIT4630dygNfZM+y+yn5KMxuoYJ
HS7QVyEzRYNwqYGE8i+ApHyp6WpVBdWNdBgcCbac5xv63yzAfD+KKilNKQyDKjAI
4KMHbzVfmRDAPNOw8w/+1+rubl9kCVVN9dulqzCe+BaMc65Uk20CEt/a0ud/Vd4Y
ld/HUkEvOG6dfW6gfoyFFBbHpiJ2WmoS9tqtT4R3CqaeB5iowmMXjhnubmsYyjsN
EoKKpHEtN7LzlzBkCB0r6KMCtvhpdoYQ6RA84IHFY+/reQg/iWBm2f6NrOMBUbV5
0DSq9BphQbWYOxgSQOpVn8GCwSN+ovlIvXZ622Pw+ZzLFEh7qhyy6mu4M3WZtbHb
KI7BpQcj1dfHdUxiLhNMknt8UmXeaPYZNrrGz+wjJcBPditVFveVEFbpc0As+ViV
z8+3TADLxXz3BJS7rKS/
=6wd0
-----END PGP SIGNATURE-----

--=-ouKNZhqSiyD2R9aVB8fm--

