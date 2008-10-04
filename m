Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbYJDIcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 04:32:08 -0400
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
From: Johannes Berg <johannes@sipsolutions.net>
To: keithl@keithl.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <20081004011510.GA10015@gate.kl-ic.com>
References: <20081004011510.GA10015@gate.kl-ic.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NVHwGm0x9kDfWnHTdQgm"
Date: Sat, 04 Oct 2008 10:32:05 +0200
Message-Id: <1223109126.24551.70.camel@johannes.berg> (sfid-20081004_103213_275178_1923BA0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NVHwGm0x9kDfWnHTdQgm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-03 at 18:15 -0700, Keith Lofstrom wrote:

> The Trendnet TEW-424B is now version 3.1R, and contains a RealTek
> 8187B ( lsusb 0bda:8189 ) rather than the Zydas ZD1211RW .
> So it should leave the list. =20

Ugly. Should we have both on there maybe with a version number? Daniel?
We can list the other one for rtl8187b too.

> I've ordered two more USB wireless devices from other sources.=20
> They claim to use Zydas chip sets.  One claims ZD1211B ; I hope
> that works with the driver.  I will let you know if they work.

Great, thanks.

> I also hope that someone will make a version of the Realtek driver
> that works properly with Network Manager, and backport it to the=20
> 2.6.24 (Ubuntu 8.04 and others) kernel.  Who should I encourage?

Uh, that's unlikely to happen, unless compat-old (see the Download page
on the wiki) works on that kernel.

> A friend of mine owns the small company Invictus Networks, which
> specializes in wifi hardware.  He helps us provide free community
> wireless networking in Portland Oregon USA ( www.personaltelco.net ).=20
> Perhaps I can advise him on Linux compatable models of Wireless
> USB devices.  Then we can keep him up to date on devices and
> chipsets, and buy from him.  Can you suggest some companies and
> model numbers known to have Linux compatable chipsets in the=20
> products that are for sale now?   Perhaps you can set up part of
> your wiki for people to report recent successes (with dates, so
> we can see how old the information is).

I'm not sure how we'd keep that information usable, I think we should
rather try to maintain the list maybe with device versions?

johannes

--=-NVHwGm0x9kDfWnHTdQgm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI5yoCAAoJEKVg1VMiehFYJ0kQAL00YwyeFaU6ohoRqXwQFA8C
CRcb9fUSXJrbtnjiu6npp7oO6zktjvEo6nYNoYIjFTRKtJofKoMYAymxO6N/njKi
X68YexNcPw6+SNAkC8sfkmqMljClZCrMvBgOW1o4gUoUpm2Mwo4k9AfLo4ZNJcwr
e359Ayh/1OCW4QMrLx2y/ffCuy1vyo/Fb5j+XGTr3eU3QLvQkvrhnyOoOxgucIbY
U4KBpqsk+pnzS6do7Nxo/h7kHauYoo9GwZ3CeWlYXqXgxv40EmBEFeoob2vRkiiL
vuiA9MNQp14oBCpXq7ptS4blAlfHXRfR7eoGuo6WAadpl2+OBlSQb83w2/uMuWLV
ubv2jrB661/AGA2NsjEZoQDOngdd1Mb8qi4i2/bSTK/L56/eKt2zsz9uR7niGQiz
mPgplKL6LD5/V2injnTslDGQ+ykZFoW5BZI+yVDpOXq56Nxv4VRiBV3Z6eewy0sD
Y0o5c+K/OJNfLWlazOidKtq2xM0QRLYwTTJ39YMFdK5hCsCHtMfXxvAn/3UKm0fo
kDxcz86qjAKXFbrd3W2b1OUjocHmpG5S8p3b2YtAO5mqF9BSTx8POcf5bFXSJ6Mc
WrBJceNGWPXr1j4ZNa76sZzHM5Q3P3okdx17gqM+iseUvuAIqbUaXnGGFmfpxWzO
xjd/SN48SrJyX1FdYfqV
=6vut
-----END PGP SIGNATURE-----

--=-NVHwGm0x9kDfWnHTdQgm--

