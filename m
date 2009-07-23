Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZGWJlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 05:41:10 -0400
Subject: Re: Update for regulatory database on 5GHz band for Thailand (TH)
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	David Quan <David.Quan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
In-Reply-To: <200907231031.48801.hs4233@mail.mn-solutions.de>
References: <f7de31c0907220607v3266710co5640389fc0ccbc22@mail.gmail.com>
	 <15B47C78534E094AA9A41F58FB8D74F30147BE67876F@SC1EXMB-MBCL.global.atheros.com>
	 <43e72e890907220941j70f5ca98g5af9d9372eeef2e@mail.gmail.com>
	 <200907231031.48801.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vzEIwztdPodsO8+kXFc1"
Date: Thu, 23 Jul 2009 11:40:36 +0200
Message-Id: <1248342036.19121.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vzEIwztdPodsO8+kXFc1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 10:31 +0200, Holger Schurig wrote:
> >         (5170 - 5250 @ 20), (3, 17)
> >         (5250 - 5330 @ 20), (3, 20), DFS
>=20
> Is it an error to have the same frequency listed twice (once in=20
> the "from" column, once in the "till" column?  And if yes, does=20
> frequency 5250 get's assigned "(3, 17)" or "(3, 20), DFS" ???

It's not, they can even overlap, and probably need to in this case.

See the discussion about new regulatory rule interpretation a couple of
months ago.

johannes

--=-vzEIwztdPodsO8+kXFc1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaDAQAAoJEODzc/N7+Qma7jUQAK7Su58PffPZLjyMlB6ltHzv
xwrtFLJaWC9AYEGusWvdR7vGQzOAoGMwG9rc6cJxGCvdmthBqMVujw0cZxFtbL6w
5PgSpILAnXvN1cefE2cvtEmT1V2jwB/EIklb8gH3Ot42iR3mQx6FWLL7BmItKIR0
lWRZ4KKxkz5Olw9cR2BPeGflNu66/sulquVLbYAEbvJ6qr7Dl1uB07ALHBX3ghjm
X7snte/zY3Mp4pQA11NkS0im/qFyl3kbPHraihDZ9AsuVm1SLrEIH8Dv7VA+lEJX
0vNRQCiDAtQY7uvnjUkLu18cOO8aWV0KbyeCYMiscvsj538/A1dvXlwPc7VB25Te
A1zwwyIVdAgdDOhjne6xGPgiu9TzMmxUhiCH7F2DGDWqjDqUJ5+4YD2/qz64R3/2
TGW6MhJJmRlJ+SawJIoNDL2RS0jkysIb0t/H6IKLkTQXdrHQlM71NgoR4JZzGEMw
CXJJ4fa6W89BsuRNBUL0eHkRfKc0jjJfME0key00KzhPU0ksGNmjsRG6UoLVm+nA
eHf97fonpct2wZAOinasInYO74OSgoVK0lz9EwAMHNre4k4KoTVaoxjMHKpJ4BFC
Hhjby/uOwRoKN0lLYnuMr9TVRfTROiEe0FKk5Ds1zk2riCBGsEUfqEixhos+WHi4
pkYBYtIKqjTdExQ4j6zF
=A9qd
-----END PGP SIGNATURE-----

--=-vzEIwztdPodsO8+kXFc1--

