Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZHAHLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 03:11:46 -0400
Subject: Re: wpa_test not used in wpa.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, Patrick McHardy <kaber@trash.net>
In-Reply-To: <4A73655D.1020205@candelatech.com>
References: <4A73655D.1020205@candelatech.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0zOzYUkHJre7Dboq8JWA"
Date: Sat, 01 Aug 2009 09:11:42 +0200
Message-Id: <1249110702.26584.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0zOzYUkHJre7Dboq8JWA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 14:42 -0700, Ben Greear wrote:
> It seems to me that in this method (and others), wpa_test is not
> actually assigned a useful value, but it's still tested in code
> branches.

>=20
> Any idea on how this is supposed to work?

It isn't really. It's some dead code that you can enable manually for
testing or so. It used to be possible to use a private ioctl or so to
set it, iirc, but that's long gone. I'd have no objections to just
removing it.

johannes

--=-0zOzYUkHJre7Dboq8JWA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKc+qqAAoJEODzc/N7+QmaN7sP/1iTzBfaYB5cZO4Ge1tzpqYC
eaegb06C06i8wBRWOsVu+1Cvck2yfcINL/ZKFT1/Vuu73GncuDQ7ERNDL6GhVWT2
YBOqpRtIQaXzO3Ec3YjPxtgZUh9nKglrCNDd2PXoDBq4EZ6pDs9kLLN6JzQwrfoo
KHg2YeEed2jNw8uJ/0sYURyOQWi+j5Rm0tcn9v7YNR684mlGsZAxGUixDb062lrr
+amoCCblI3NieWLaa9NNS3RnV961cAS9r7i7FgsTD2JxpBoyNNilaQ7B7LXzN0DD
qmibxgXEYKyARHF3nvLu40m7fFEWALH2NUjQnpcmT63GiCokBY6gQdQ7FMSIq1Pb
Vk+QKr70swcLEaPK6FcJcyNGjZVBChjw34vDVwmxTC5+gT87BT1oDmyXA2KcHYSs
4SoXa73FqbxqcA4y2ETGV7Q+YXh6ZM6JVHbMsI44njarlREnKSaooKu1cWkWRyHV
XDUCnN08cqEkPKOnOuQG9QjcUcBlox+ASl8LxYZn87wJVTGgMt33trEIzRksrUIf
lZZYBKyrDUFET1pOOeMwjIPCdwmXsim7hACTYFqeXhEvg1L5x/IeX7kMxN6pYVh8
nWe42+c9zrfOOBV/d9k+YYR5yu4bD1jNWcRYCMIvSkzO+038pr5nRbTwetwm2j/8
rUiLBad+NahoiqOEM5XC
=g/iz
-----END PGP SIGNATURE-----

--=-0zOzYUkHJre7Dboq8JWA--

