Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYLJJYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 04:24:06 -0500
Subject: Re: wireless drivers sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Elmer Joandi <elmersoft@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8f6a4c2e0812100113l7802fd31qb295400a91e063f8@mail.gmail.com> (sfid-20081210_101359_985634_3F7BD29D)
References: <1228823435.22164.216.camel@johannes.berg>
	 <1228829427.22164.227.camel@johannes.berg>
	 <8f6a4c2e0812100113l7802fd31qb295400a91e063f8@mail.gmail.com>
	 (sfid-20081210_101359_985634_3F7BD29D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Frs55nyk9p5ylXWcInmy"
Date: Wed, 10 Dec 2008 10:23:34 +0100
Message-Id: <1228901014.1029.36.camel@johannes.berg> (sfid-20081210_102415_757460_D5E4D0AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Frs55nyk9p5ylXWcInmy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 11:13 +0200, Elmer Joandi wrote:
> Well, about arlan driver - I am sorry, but :
> 1. I lack the device and I even lack an installed 32-bit linux to compile=
 it.
> 2. The card has been out of production for 10 years
> 3. I can not imagine anybody using it for anything sensible anymore.
>=20
>=20
>=20
> To get rid of warnings the seems a need for a correct typecast to be
> used in 2 places and a "static" added to a declaration.

Indeed, on closer look this is harmless. Wasn't sure about the address
space warnings.

> However, as use of this driver seems to be so rare, I would suggest
> marking it experimental or something like that, i.e. retire it at slow
> rate.

Wow yes, I had to really dig in to figure out whether or not the code
was correct. This driver uses netdev_boot_setup_check() and is listed in
drivers/net/Space.c and other things I hadn't even _heard_ about until
now...

johannes

--=-Frs55nyk9p5ylXWcInmy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP4qQAAoJEKVg1VMiehFYYpMQAJt2fgawlXku4lIxoVLSmCWD
HRIAtChpSni0titcQFQLPp1KI/f5IiY/h8L/36KGbHVCt28yOg3c2vgDtKbfb8vP
YTTIHR58AMOhRAoUQ6MsQabJ/4ZXYxNDKjRq2Y5hjNUUY7/OBVfTRrmyp9jK9Qge
fM3eI3xwJvE1EeKFYHtMP3jLuJm1Y5kW/erlVNchzzkqv0SA9FUg/jYjJioSpmq6
ZyVPChKZKgarwXP/2JlqA8NAMfwvOjfa9eE1G3tDT/4aNtgta/hL7lGG4Vg6om6x
eDBfWL8uTIks+byoN9ogzD0MJO5kBEtmXOyb29X1s5CIQplqGm3rFV1E4sOnE9xx
G0NTwcCMv1G7ZKuvTtX5kCJkcTA6aSoF03e4CAzgAEbKEGaGZ86YRxpgxQE5GmAv
DklVMMNKOV0zS3SiXChQEZmLjl5Sn0AnP4ffmlFHa12PmT7NfWAjl2qI8NEbupJn
zKgczleuV14ZdeNv+KEF3Y8UggvFSsbW3vA2YxnSOTP3D2ccceEXo3280zMrWN7I
FyUtdK6vgbxb/KJZEYT2ia1I1pbfIIUQLNlg/mspF2wfDV4HekG0uJBOYQ4bvggI
faa+v30nCI3wn+kMgrpbGfFYyha22V1VdhQmZX/J3tOXGHyQHBhqHAQ3cfowCo0S
Xgvp19lGWz8vZB4cXXtS
=Rscp
-----END PGP SIGNATURE-----

--=-Frs55nyk9p5ylXWcInmy--

