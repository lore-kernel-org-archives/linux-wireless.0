Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZG0TI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:08:27 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248721359.7440.2.camel@mj>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
	 <1248710568.8500.7.camel@johannes.local>  <1248711120.6965.6.camel@mj>
	 <1248712821.11808.6.camel@mj>  <1248718929.13118.3.camel@johannes.local>
	 <1248721359.7440.2.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6LRssp5zYsvsNPdx8pY1"
Date: Mon, 27 Jul 2009 21:07:55 +0200
Message-Id: <1248721675.32365.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6LRssp5zYsvsNPdx8pY1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 15:02 -0400, Pavel Roskin wrote:
> On Mon, 2009-07-27 at 20:22 +0200, Johannes Berg wrote:
>=20
> > Nah, the bug is far more far-reaching, please see and try the patch
> > below.
>=20
> Yes, it's working!  There are no crashes with correct and incorrect PSK.

Good to know, thanks.

> I'm not very interested in making code look nicer if the real problem is
> elsewhere.  I just assumed that the problem was where the panic
> happened.

Right, just wanted to point it out anyway.

johannes

--=-6LRssp5zYsvsNPdx8pY1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbfsGAAoJEODzc/N7+QmaxPIP/2thnPaV5GrtCVh2yJGBrDyP
71co4tOdFPMJ6drkR8JPYY4K1sXbjiLy+7leHxJ+qjZV80MGPFoazLMT6eqyBKId
/rqvfj0UJvuzCbO+ob3XkHo5Fw/nFjZEGw2MRvLR8af9E5vAud3uLVcnp95IZtH3
dUyZwDndaR3Tm3U5avvTkucDTGE/vVksPUROoMGdFZEj7x3b+Fl8NIf/x6n2DqJD
EjNtTfdACwoY2DF38GrQWZGUYgK/nKlxl4UzUJ0n4jkuQh14mjC7eEmQnhMOm3pj
6qLTzSzdRWy5VPiQwdrTv9dHKTbUYOTXICMYOAfS4XA7eemoPySbLqrH+oWmHsi+
X7M2nd3eSwImva04B/FjWIMMAoBBm4y+UgOwjtp29hEZ7s8uKDW1sz3Qssh3mZ2n
ePo3094B94xxqVE+gkLYz2jLwVXKAVmZMVYEEjIwv2qmH20Xjg4Bu34CXOaGebl7
vzWw3X+aUHQ/9mdTigtYUjhHtGU8j1nuVDge5hypLpNzC0zu5qExIfAVx/CuxcGH
zqpmkSbsUCQmnuRevGa+fwrSiuyFFbDPVkTxGtbq/GgPE6x4pUwYiUW1FG5tuA3k
j6hXjR3N0zuOjJhBrJRRqlhfa7cvrJtrM/Kbn798z5rPvQoNOMzMpulGNvXjfFY/
PRaD0IPl9WUMyeBHOIL3
=X+V4
-----END PGP SIGNATURE-----

--=-6LRssp5zYsvsNPdx8pY1--

