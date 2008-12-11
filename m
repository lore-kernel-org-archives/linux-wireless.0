Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbYLKNzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 08:55:53 -0500
Subject: Re: Listing established mesh connections
From: Johannes Berg <johannes@sipsolutions.net>
To: Keir <keirlawson@gmail.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <e27b78a40812110314w409a0294w1e73d40d9d34fac5@mail.gmail.com> (sfid-20081211_121449_680610_19E5F8A5)
References: <e27b78a40812100713l588e5cfch952c3d909c1dea19@mail.gmail.com>
	 <1228922932.15837.4.camel@johannes.berg>
	 <e27b78a40812110314w409a0294w1e73d40d9d34fac5@mail.gmail.com>
	 (sfid-20081211_121449_680610_19E5F8A5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W7vNhi9l3zhi2wbnfV9P"
Date: Thu, 11 Dec 2008 14:55:11 +0100
Message-Id: <1229003711.8081.4.camel@johannes.berg> (sfid-20081211_145557_042440_476C99E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W7vNhi9l3zhi2wbnfV9P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[dropping o11s list, keeps telling me it drops my mail]

On Thu, 2008-12-11 at 11:14 +0000, Keir wrote:
> Hi,
>=20
> No, I mean I want to do this within the C code of the mesh stack.

Oh. Well, is that what you want? If it is, then you can iterate the
sta_info list in the stack and check the sdata.

johannes

--=-W7vNhi9l3zhi2wbnfV9P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQRu7AAoJEKVg1VMiehFYUuUP+gLzaOcZHZbKPpGtl/COUeRa
TJOQArdcuJYqVih/JY+grxPva4UqM3tppRkkpBFVN9vkBDnjvYPkAy3tytK/Qwkt
nA6OUdmbWc9YupSodlbzBLj4CRBwLzUuEQFiAeh02wmEfcJf1RePytVWUykmEnrD
pG4/OFkllFvRh0YKSaZAvIh7x0Fq918r4RgewVomZrNpR4smGBPNBQUTmVVL/m7n
nlDXbQG0vY6aYboIgQH6lswWZpS5YG1GzdLAv+QgusEIaXvcMdmyMdm3jbLIMIWN
znQuy+exiVaOhc+QGdp6ZFddAfQNmLab87P06NjFpl8aP3cAappvb+8wDgsQkyw7
cZquzy6duxeyU+Dvg5/pjDq8JKCp84i4HFfB83lTAuw02D0eLAL7k5zC8qZeCz0k
l2/DCLC/WAOnoMadryPUPecrxaurEzTAY58/W8IKjj2IepwErEPOC3QsjxK9z5p2
hR8eAJfeJhUQpl4x437ztu8Fcen+DUyWUGaDfaCifEkKY0kiV8H0VP7w6T/7aaxu
cHu3w1KwTyfa9RkrxQcWeaG3fMnmvZwo0vG55bg7abF/NY2oTuktmE1onarP1QrE
W8slO8KFo+6Vt2mbE7Ww74oEFYHjTJIFfDUpnjqVeVXkaIxGxudB5edU/wWd8wKD
911krIPlYY1GzRyDqhDJ
=Rprv
-----END PGP SIGNATURE-----

--=-W7vNhi9l3zhi2wbnfV9P--

