Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZDPLHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 07:07:14 -0400
Subject: Re: [RFC 0/3] mac80211 powersave improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87iql4981b.fsf@litku.valot.fi> (sfid-20090416_130208_558130_BEE7A112)
References: <20090415171046.336006351@sipsolutions.net>
	 <87iql4981b.fsf@litku.valot.fi> (sfid-20090416_130208_558130_BEE7A112)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ev8ADcIq5d2DVSekwXpD"
Date: Thu, 16 Apr 2009 13:06:40 +0200
Message-Id: <1239880000.9737.20.camel@johannes.local> (sfid-20090416_130720_703548_82711DB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ev8ADcIq5d2DVSekwXpD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 14:01 +0300, Kalle Valo wrote:

> >  1) improve powersave to only allow it when a single
> >     managed interface is active
> >
> >  2) disable PS when the maximum networking latency
> >     applications are are willing to put up with is
> >     smaller than the beacon interval -- in that case
> >     we cannot allow the AP to buffer frames
>=20
> No problem with these.

I'll send these along with the software beacon filtering, I think.

> >  3) enable powersave by default
> >
> > The last part might be controversial?
>=20
> I think this a bad idea. For normal users we should not enable powersave
> by default, at least not yet. I believe that there would be so much
> problems that we would have to revert the change eventually.

We can go with the configurable one -- and default y in wireless-testing
but default n in mainline for a while. Get press coverage etc. and at
some point flip the switch.

> > Should we have a default setting for the dynamic PS
> > timeout?
>=20
> Yes. Having timeout zero makes no sense in normal laptop use.

So, what's a good default? Fairly long I'd say, maybe 500ms?

johannes

--=-Ev8ADcIq5d2DVSekwXpD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5xE8AAoJEKVg1VMiehFYwrwP+wfIF7HBqTwVG2I6hcWTxn1u
9dlPCcK+iyRbWjNJMrHCO7FVVEOP3rB6mIVueaiQtxvPOXyxnzFYFWGHNUr80E9C
2DaFgY+Xwvurcnd6Orlc7PBCuqxwOqH+XURd2vbdBWJbYzwQucLip1eWZ16LPPz6
qxRQpfpNy/clg0bHIEMMYBQs8aqn3n5hsGfXuCTyuXnT98JNpiPLKIvNwr81d05R
WE+dnnK2WZpTsTjScRdx3DkjjIm6y1K1d7Gxjtismnv1z7MrmkZOsTNnbny811f+
1xu6D4tCxufh6/qjEXH/Ksni466PZd+dzFKRgKj11ZL25nW5Wz106OO/up2kBeXp
L0CWuZKXOV1vlq8fBlvEIEMWiRQIDJN1QRezx5kTYtq4IRB4qV1sk1lNLc4YGSGC
6EmRsu7ohWJfRI5EqIALd+4HIYysX6uX9hdzjOUQgTJHGnRhTOBUTGZwv0Ec6Sx5
/JmwVD76j8oFFVqG4T/AojGRaL0v5HyhHXismd01rgX+l2Cr2ETKdsMgks1er9Je
9wv7zjKkQbl2i/xKeES+1R8UEep+/KN8nz9gjqFQCTHZnerIyRyiY5AAvdSNlVHm
D8hzkFpjxuae4qBQnWE8SNhtrhPeU8AQyITLkSAZoWpC8sB37y9/xOSLFRSRWwUp
YaXpCL/8M5UR4qeHI91t
=ZEtc
-----END PGP SIGNATURE-----

--=-Ev8ADcIq5d2DVSekwXpD--

