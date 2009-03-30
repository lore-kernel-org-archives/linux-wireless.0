Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbZC3JGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 05:06:33 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1238349195.24972.5.camel@johannes.local> (sfid-20090329_195345_745378_2F2074B3)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p+4fP+fywChXV5SoXlfl"
Date: Mon, 30 Mar 2009 11:06:27 +0200
Message-Id: <1238403987.24972.14.camel@johannes.local> (sfid-20090330_110653_764519_C0EFDC45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p+4fP+fywChXV5SoXlfl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-29 at 19:53 +0200, Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:
>=20
>  * all rfkill drivers need to implement polling where necessary
>    rather than having one central implementation

One thing I was wondering about -- should we just implement polling via
a single work struct that iterates all those rfkill drivers that need
polling? I've given them each an own right now, but that seems
unnecessary.

johannes

--=-p+4fP+fywChXV5SoXlfl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0IuQAAoJEKVg1VMiehFY1zsP/2V2jogdcMqqRZzrPuZpPDSX
9e88Le0T/MJORMbxFSpb/TRv/8TB2n78U77XrsrU9ccHeIMzufm6k+B+ZnMjBh2V
Bs3v+eveRXpYvhDgQO0wfxXCRtZPOOEKEXoG3Qz0zq7eZoVA/chdD9L3NjlpvBwU
RE4Kff0pEPR9UdaoviK4pZ0HCCpu5la05zka+QHTdZwgwsm8RKLM7vtd15zLqlfa
T8A2IQ8FcZNN9i9MRIQH2N9n5FAWbXXMJCFVnDUeYX4LB20wUwP6grb49hIofGY5
aBAInYr2MJtRYYNCw2yFs79rP8Usc9pVVE4UitPxOTAu/tH++KvjK8bUAQKpo4k6
qRstY6wcOKDKMOjpC3aR5AEBIxeChX3NphCjRASPZnqaBCwNocE7Zv7gRMgEkvRf
HvsKot3wypXRoWGMZs/JUs6ZTvrTZR+1KSMR3UBCQzThCagdo76M7OT9lWJ9p2b5
M6aW4tQw67lpoatFgr9vBP370XYusaee1DhFha4zjxSzjsXrCH476tvBKtTgQYz2
B3oNle/FzK8pWaixO5cLfKJxmYff0cLGCi7JXJ4FFv5qjyOgfar92f93NA31aGOC
zpAXfxzM+mE0PQGdPdB3DLmmnJ6kKDgMu0IkAuIDk0reg4B0cJl0b0RsTnIt71RL
hFr+tJ9djmDI8Gkg8+hb
=HnJT
-----END PGP SIGNATURE-----

--=-p+4fP+fywChXV5SoXlfl--

