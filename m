Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbXJISEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 14:04:54 -0400
Subject: Re: [Rt2400-devel] Mode selection in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net,
	Adam Baker <linux@baker-net.org.uk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200710092018.28113.IvDoorn@gmail.com> (sfid-20071009_190220_636461_94582DFE)
References: <200710052319.10600.linux@baker-net.org.uk>
	 <200710091954.03727.IvDoorn@gmail.com>
	 <1191951652.4013.48.camel@johannes.berg>
	 <200710092018.28113.IvDoorn@gmail.com>
	 (sfid-20071009_190220_636461_94582DFE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C+vko/i/bcgYntkQgW0r"
Date: Tue, 09 Oct 2007 20:05:34 +0200
Message-Id: <1191953134.4013.50.camel@johannes.berg> (sfid-20071009_190456_304611_40827C19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C+vko/i/bcgYntkQgW0r
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 20:18 +0200, Ivo van Doorn wrote:

> > > True, but in G mode you are compatible with B. The legacy driver does=
n't
> > > switch back to B mode when the AP is in B mode. This means that it wi=
ll
> > > be using the G timing values.
> >=20
> > That sounds wrong.
>=20
> Not really, this would be the same behavior that you suggested earlier,
> when you stated that a driver should perhaps not register 802.11B mode
> when also registering 802.11G mode since it is backward compatible.

Well, in that was the assumption that mac80211 tells the driver whether
to enable shortslot or not regardless of B/G mode. It is only perfectly
compatible when B slot timing is used.

johannes

--=-C+vko/i/bcgYntkQgW0r
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwvC7aVg1VMiehFYAQKRiA//XGvrOwcDBE+FOMrnz2urwrRMdfHUQjpM
TCkb03edHN368bLUdBTH/SKj5OWfh9IFP0Dba+5nlteqaiy8WRQjYrS37Yk0RvAH
tmb9B3OujPwQqrzCorogPPduRNrb2myXiAQBLPBW9tkqsYEtGJoidcsXjwfCsAFz
g1dh22nsy7qcA4TQOUv1vOUxuXVn7+79czFvpL+gJGdL+Ub30GeF0ClRucV43of5
vVEJrbf1cKus5JPpAHX69GdgusO8GfoIvCBoVrFKw8hV3gFsSQ4N+DjnF+hxsoD4
00i6mekabcXt7v44V7+z08G7zc/Zjv+MAzUhYKjsmQDwusywGXHiax3WI24h8KuY
HyfeZQ0dVrRN9iswbqtn2iUBZtUK5vQzdPfczAeZBld9tFtWHr6hAhwoY9zxZ8Te
hylIf2Eddk5CEL+B76UWQxbJmLr7jB/Kh0oqiBmXuOzTIeb3iLONG1HtRuyPZUen
t8wUtjmKGbiw8nLjwzG0YGRuvx3xbPa4wrmLMjO0+OAU/BFkOhDAtLujwQ8VLGEz
mFGYNgiHhmApOtNKCEa3O5/keGgdzc7qqGzWRxFnqLWlQ8gOcHOCFgqM2ppzNw3+
GJ7z5aoXtP11zy0YJoyJ2nDGnUrrDKGWvJmgLif69Qzxeym/LJJGjweVTKkEtwxr
VA09YMArF10=
=3l0J
-----END PGP SIGNATURE-----

--=-C+vko/i/bcgYntkQgW0r--

