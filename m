Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbZJ1PXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 11:23:53 -0400
Subject: Re: iwlist wlan0 scan disrupts communications
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0910280802r279bf0d8q3424245ddfb1f8a8@mail.gmail.com>
References: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
	 <1256676190.4237.27.camel@johannes.local>
	 <86201b3f0910280747q557a6153oec929e8235459c8f@mail.gmail.com>
	 <1256741651.4237.112.camel@johannes.local>
	 <86201b3f0910280802r279bf0d8q3424245ddfb1f8a8@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2JU9GYAKh88xb3VZpTpY"
Date: Wed, 28 Oct 2009 16:23:18 +0100
Message-ID: <1256743398.4237.114.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2JU9GYAKh88xb3VZpTpY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-28 at 11:02 -0400, Charles Gordon wrote:

> I think that when the scan completes, mac80211 should either notify
> wpa_supplicant that it should reassociate, or maybe send a null-data
> frame to the AP which might cause it to send another
> deauthentication/dissassociation frame (if we lost the connect).

it does send nullfunc frames, you're probably running into an old bug
that caused those to not be sent.

johannes

--=-2JU9GYAKh88xb3VZpTpY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6GHPAAoJEODzc/N7+QmawwgQALzYxtQTR83LY5ZGkQfYjbnm
XUfC1xcI7HJhj0HOYxS95pJ/HVE9oQHKJRG8422GRoaEu84rNZZRVhS/tskTJfEM
2ErFK+JzGmhoY6s38lDbNPvgoluyhshtQq19Ynf3RExdSqgsxiUxHD1NGh9OHLze
dM6/yqKbx1ntOUGUN1CqUm6qhwbuL3a1Ny1uQaQZ4dnYfQfc3aA5AwEx5lXNUpcu
91xkiFC83TuXqd09cntqNHFzAW1xn1RTaLtmbXOU76LaTcl6UzoWrwGm3PmY/cXh
lQvrLu5fUzoc5f0QKFsAIPlhVmGHb/ZwdxoU2GDRddnW4OY9bm3JjUcuJpUQwV6S
CovzzA2+ytDH3wH/Zepne+l6O7VBYpbEFy4b8xmR2r8zG27latmynV0DlMsMifLC
4Y8J8c1f+Se2cFEMuOOIeNoGUSR+S2ycKh7azIg72iwQMKd7iCjty26drfz7tol5
4c007XXH++iVxw390aXdjoeTtLE0MJJwndrflconfoA0WQ42RPWLt+HEWt2gt6g7
Iw2KVQTKM9+MrKQxB3F8XsTfs18nszNZccayLqqWhmPf1HwSTWcsNz5hnfZ8Xnwc
ALhBxnwX4OHGW3TX+Rws9FYfUNx+0l+Yeui4Bk4qsRwm/n9q3yEdPUX+4CszJqEh
qOFKzL9dP58C5noZuTAD
=sDso
-----END PGP SIGNATURE-----

--=-2JU9GYAKh88xb3VZpTpY--

