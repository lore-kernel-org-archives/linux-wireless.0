Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbYJORuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:50:07 -0400
Subject: Re: [RFC] make ieee80211 invisible
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224092268.19219.7.camel@rc-desk>
References: <1224006562.10113.47.camel@johannes.berg>
	 <1224092268.19219.7.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FPCYDHw7kFXJ7lCHUsAO"
Date: Wed, 15 Oct 2008 19:49:01 +0200
Message-Id: <1224092941.735.23.camel@johannes.berg> (sfid-20081015_195022_611042_D7CA5D35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FPCYDHw7kFXJ7lCHUsAO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-15 at 10:37 -0700, reinette chatre wrote:
> On Tue, 2008-10-14 at 19:49 +0200, Johannes Berg wrote:
> >=20
> > This makes CONFIG_IEEE80211 invisible. The drivers that require it
> > (ipw2100, ipw2200, hostap) select it, and everybody else really
> > shouldn't even think about using it. Also, since there really is
> > no point in compiling anything without crypto support these days,
> > remove the crypto options and just enable them, leaving only the
> > debugging option which only shows up when a driver is select that
> > requires it. This makes it hard to enable, but most people wouldn't
> > want to anyway.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
>=20
> Very good idea. Not sure if you need an ack from us for this, but you
> have mine in case you do.
>=20
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Any pair of eyeballs is welcome either way! Thanks for looking.

johannes

--=-FPCYDHw7kFXJ7lCHUsAO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9i0JAAoJEKVg1VMiehFYqbkP/AjboHalIQaUvtO/LHvDN7Pl
IQIjK7zmXy+JMoBybZBV80hcpNhw2CSIhE1O+HSNvx1C00dt8i7i1th6vjoIHs9d
ivAJneTAdXNK6l4fKY/rwbHAh6v/IO9AVJtawLQgBNbM8DkJYDgJu8vVg8ZfFrOn
45tBipzhU/rscuy67TNpsKbATOeNLUrppZ6cXzIPxdk7CpQoto9dxwQVumt5UapB
eH1JyZD+P1jebwBWQcoMw6uKqwNu36SVeMlSRYefFYNFi2f4oFM22l0sQSIKyYFf
iK4bVpRZbwa7jJ7N3I7Tc9UEDcYCl/Vp4J9QYf0D+zkLvntPjikCanfOWgL51OxQ
c+3aD1rvSVuGohPC2kY3wMledzhP/X01xtINDvw4nTGYFe52O9/pUBrbOyAE32ro
sN97r7OzxlGOasnQOsrj/XGN7RZi4AQ+Fpm8xjYzJxwLcmjDZcyI/EWlJWdL4JsO
mUPAV7iYg1rt2vKDPArnPcMTaQ7tyb2+NTZjUdkGlaa6MtGItTnQoH1WBoA6FgVi
6ibwGxYGITR/IXphG5JM0+9qyAwgqtb61dCHuv5eyEoB9RtWMFhrZjL7L/6hVgi0
U/1kIRnabWQy+ysZu39b49aLhIJFbzDuBPC+lhydt8moby+chDikDkzec7KGBoe2
+Aa6EZswHvOQxT04imLB
=71Tf
-----END PGP SIGNATURE-----

--=-FPCYDHw7kFXJ7lCHUsAO--

