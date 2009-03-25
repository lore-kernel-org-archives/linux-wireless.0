Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZCYLHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 07:07:12 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1237910398.9082.7.camel@localhost.localdomain>
References: <1237891149.4320.73.camel@johannes.local>
	 <1237910398.9082.7.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7kMWOxSzG4oIjES7pUxW"
Date: Wed, 25 Mar 2009 12:04:30 +0100
Message-Id: <1237979070.4320.156.camel@johannes.local> (sfid-20090325_120716_599938_C79712BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7kMWOxSzG4oIjES7pUxW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 11:59 -0400, Dan Williams wrote:

> or maybe gnome-power-manager (and whatever the kde equivalent is) should
> be driving this based on all the other policy decisions it makes?  it's
> the thing that handles whether you're on battery or on AC, what your
> drive spin-down time is, it knows when your laptop lid is closed, what
> your display brightness is at, etc.
>=20
> it might use some information from NM as input, but the overall power
> manager is probably where the actual policy decisions should be made.

Makes sense too. I guess that Marcel makes a compelling case for it
always being enabled, and Kalle says we need to have an override --
which semantically needs to be in NM/connman since that's where the user
will look if the connection is flaky (because the AP is broken)

johannes

--=-7kMWOxSzG4oIjES7pUxW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyg+8AAoJEKVg1VMiehFY2wMP/i+Uo+lHMBQmeF69fgsHfxn9
XCuqbohr1HG4oFY+qCrqmAVw+ADDt3acFaYpdp/ywUmGqFdTNInEHPth+ENWGIsD
uOO1UUYpZ5RAQAPLN9KedXdwCWoSPhoppFg/EDJ8C4sKbBnSrs80y1HOx5a6FTQH
RzW+ixrxWxv6hU1IxrVBNEzRrjASNVh0WGjzNIyypoP0Iym6+XGsdybr9IEHUT05
VBKXz6kwOmz0KWd6YYJ2bayQ0X+hQwsJNPu1NolgKPgLp23osqZu7/EYbbvoGSju
XiyXBu7HBZDwQbmbZHmHub6nROb2LtBsmXz9Ro55oO9vxOwmuk0PH9pTOEFfhUvd
Sn1FrGZZdYpHk+qs3WBwVt8GRTCxWG4gxSFDfpzzYdFmy53u+kszVDcXargpMZNK
Leq64DZvGCRBNE7HViL/hfXh6xl4B3xHpEHTFvsZG1EUwf+Xg+LUX/M01uZJV2gU
rAh3RDLRb7BL83+TsiNiviKtcBRSBYM7VsG2bQTnRaftsew+tyTSI5BXEdXxwE8Y
EDsNsqQgWob9No9XL+nz0Yl+JyVA7bXoT9Vrvj8BcVdW6ZGC8ZGM4l80IYRORNsO
PUiqwbsm1RmxUrYJeZTHSQ6OeoUj64WkfYAMzyYA31/rVswGHo7wcau6cZf6DSeL
Pz1JIbqlql/MDeFkA8SU
=x0na
-----END PGP SIGNATURE-----

--=-7kMWOxSzG4oIjES7pUxW--

