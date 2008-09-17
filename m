Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbYIQLIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 07:08:05 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: "\"Adam" =?ISO-8859-1?Q?C=E9cile?= "(Le_Vert)\""
	<gandalf@le-vert.net>
Cc: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org,
	499246-quiet@bugs.debian.org
In-Reply-To: <48D0E463.70008@le-vert.net>
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nWa5Nh1xy/AlzEMkCLlC"
Date: Wed, 17 Sep 2008 13:07:18 +0200
Message-Id: <1221649638.9262.50.camel@johannes.berg> (sfid-20080917_130814_835082_60E0A149)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nWa5Nh1xy/AlzEMkCLlC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-17 at 13:05 +0200, "Adam C=C3=A9cile (Le_Vert)" wrote:
> Hello Johannes,
>=20
> I'm aware of this issue. It has been done to have a fully working=20
> aircrack-ng for lenny release.
> I'll package iw seperatly once lenny has been released.

Cool, thanks. Note that I think that one of the small command syntax
changes I made might be breaking aircrack-ng, not sure how to handle
that. They should've just used nl80211 directly if you ask me.

johannes

--=-nWa5Nh1xy/AlzEMkCLlC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0OTiAAoJEKVg1VMiehFY3vYP/2sSgKTzoogLCp0rOJFtNk3d
8Xm/1eUK4rYwY3yghDhPX9bUWMSv4ZESA+fsXTdO7pB9HK7SNtNDgXDshtOAj4pC
yZEsdlMTTSYPbn0U0R8SeDQkAaj/+bDUln5DRaHmLbQM/cvEDnfoyPsNuugOuZ/A
N9gITHXeX1Bogg9EwYkrK4OQCsNcpq9py9XCw1DF2Z2BdV9wZ0+WLRvDhFWXVAht
MbrpPyGQ/+xzCxVphCb6d6szlro88VLyJ8BYww4DA7Gnhr/tJyWpNTZSgR2ClZW+
/F4FoXTFzzYPBq94fBAg9rs4ZIr2TFI3fAPe5BdPdWF9dkkJF+Kjk1MoceNWb1k+
ir/Pzw+hrpkDCVyvgIWe5LRlbG6g9gmz+6l5nD8uFUTCSUUY1JDaH78RwFUQX0wq
0gEn7xJ8JJRURffTIciaZ6oOPFrdbqYGbfdNmSd9vxfzXl2tCYuupE7QMM22FG2+
TdDeiyIYxynrooVU3H+ybBXGI/tYLKOgaUk4+Ji0Eh/BHSxzX5vYjhKgqGGZYBP6
yfw7KUqdcCwGp3dsYa3NV6WaRKM9L6LJ1MVfBA+NBLQyKlFw4CEzlr6udqmplh4x
HCfDAOWwVucXL0zu340SMGi+Y995hG4yvh5Aa8+yd9cJRkaXH9udV0ZhL5MmhlkX
hYWWW3VcKU9kneMjFGhq
=XQHu
-----END PGP SIGNATURE-----

--=-nWa5Nh1xy/AlzEMkCLlC--

