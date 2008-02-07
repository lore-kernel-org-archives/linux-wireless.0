Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbYBGKjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 05:39:06 -0500
Subject: Re: [PATCH 10/13] o11s: mesh discovery and peer link establishment
	support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47a78292.22528c0a.1300.1aef@mx.google.com> (sfid-20080204_212438_516087_6199B5A8)
References: <47a78292.22528c0a.1300.1aef@mx.google.com>
	 (sfid-20080204_212438_516087_6199B5A8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GfRIXh0/ePlUzLakPa/Y"
Date: Thu, 07 Feb 2008 02:13:08 +0100
Message-Id: <1202346788.9965.95.camel@johannes.berg> (sfid-20080207_103914_574256_AC8F9359)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GfRIXh0/ePlUzLakPa/Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-02-04 at 11:34 -0800, Luis Carlos Cobo wrote:
> This file implements mesh discovery and peer link establishment support u=
sing
> the mesh peer link table provided in mesh_plinktbl.c.
>=20
> Secure peer links have not been implemented yet.

How would you design implementing support secure peer links? It seems
that to do that much of the mesh bookkeeping would need to be done by
wpa_supplicant instead of the kernel. In fact, maybe it should always do
it and much of this code be migrated into wpa_supplicant's userspace
MLME?

Peer link establishment, mesh path updating etc. could all be done in
wpa_supplicant's userspace MLME, no? If we add all this to the kernel
now, would we have to reimplement it in the userspace MLME to support
secure peer links?

johannes

--=-GfRIXh0/ePlUzLakPa/Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6pbI6Vg1VMiehFYAQL4mxAAv/8QYgG/WjRwcCHbhmpHcPaZfjYHofti
OnGzgOEXB7VcaOb5wWbvR5XgSEFo09WKQ3VRfz8rlVY/1HtA/UqO0G4thVyG2lZT
J8TSpKipL6CD3nHUUghin1cpM4tqeCoT+ITx6ldipdjoD+yVtx7R7yl4+DsrjiB2
lm4UPwM1dvRxTeYoONPzwOUM2EdeMuWiY94PspjyDITEwSq/pF3tucu5G4W/eJwA
QDIt2aii8M7BwYGhIclyJLnAxf5gb8AVcLsuPARBqucwUQ6JPvJhpYx1YZNO51ZP
vNxVjjN53IQB1yw1M0qjVCIWbiGwNM+ovrCXkOiTJWftTBK+4J5zQ2Qu4/jZnudH
f/bdj6tKEMMcSfGp3aFw+g6AHYerRtQMyDK1Uzq8HQ55jAx64ShGQ2+lj2iGKFrt
rpB8sXPPTz3EjG9+NvquzsSvXHSi3sTCHYHD4DicDf+uDle1QDCOO9+1PfyVagqZ
ORJddYdn75IgsVHDr4EgNgDpt83bO4L3UvzNUabMEguE7idQXqJ9rxx2x2elRJ4W
UYDjPvbjUdshvKpcNyOx5MezZvvvsuLlFYv2KdQ4l4v/jzJUm6E7416N+vWdgFlY
24zE8qKUb7rAKXr9HrCfbRpiARSv+4UXXBKn3YUu0VbfqWOiZxTIiI+EcSBpfRy/
W7LmdPcIo9Y=
=eFe+
-----END PGP SIGNATURE-----

--=-GfRIXh0/ePlUzLakPa/Y--

