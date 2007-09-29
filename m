Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXI2L1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 07:27:44 -0400
Subject: Re: Kernelspace --> Userspace MLME move and related items
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XrV3OWIlbe5cJGspPbAk"
Date: Sat, 29 Sep 2007 13:28:59 +0200
Message-Id: <1191065339.22960.51.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XrV3OWIlbe5cJGspPbAk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-28 at 20:25 -0400, Luis R. Rodriguez wrote:
> As I was discussing with johill earlier we should probably lay down
> the overal layout of what our communication path will look like down
> the road between userspace, userspace MLME, cfg8021, nl80211 and
> drivers both FullMAC and SoftMAC, This conversation spawned over
> implementing the next console userspace configuration utility, iw.

Oh yeah that reminds me. If you're looking for a way to create or delete
virtual interfaces now that the sysfs interface is gone, try
http://git.sipsolutions.net/iw.git/

And send me patches, best Cc the list too :)

johannes

--=-XrV3OWIlbe5cJGspPbAk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv42+qVg1VMiehFYAQJH0g/+K+/cDKjT4T60S22sX1qWQ1AyNcsFNJ0N
PxcDVj+BmRo3ix9tPgmamvf/miZ+903CqnIINtflu1EkvtWKezxcauE0N6Weqj5a
Oy2CnUQU/b2ZIR9dXCQCGUM3igNjyA4LOgKH8/BAhRogIFhfytPSZ+gHQNaN/TYH
nCpeBRJU3diRZuYqopjRRquZierUG7EJIA1gaezIgyZERKlwYKVjafCCQmIZZHuD
CfL3hB/hT1qQRyNv/LB41dBYi7GPGX2gOXQVxhkMN5pax9KyNz5IjM2BKUUGV9Hu
JEOd+mz54VAXsb0t90ZVSe0oF7NT7b3qRfvvqeJLHduMILtjwpr89GuFxFc6yYvV
EZzQhkM1RZlnel3sEJSJZeYfW2yhcdlTre1JxVETTBPaqCinER25KAGLP4Dd5Bw4
amZO09xd48pxhH9fX8qLzvJRpWJx6JmUMhV0i88cz4n32RQ8vYiP2YimqthV+0Q4
oSuSNcg8VPwOg46itqNkNzSx+f2m16svfFHZOipVklixBtKv7dozBtFKeG/0J5wJ
23VRfD1CylQEkKuEUslL16BY0n0eQdGeRy6m2YGng+ivdx1MS/2TDaEek8cuqvH4
73W+lKfZIF02lNCzajKInBOZfcSZvvd57Bn/833g+9D5AtRphngGuAbGukVwPCoD
oWDqjxob5DU=
=tkP+
-----END PGP SIGNATURE-----

--=-XrV3OWIlbe5cJGspPbAk--

