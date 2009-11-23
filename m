Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbZKWKtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 05:49:24 -0500
Subject: Re: [PATCH 2.6.32] rfkill: fix miscdev ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258973082.3675.0.camel@maxim-laptop>
References: <1258968499.3271.5.camel@maxim-laptop>
	 <1258972050.7094.140.camel@johannes.local>
	 <1258973082.3675.0.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mNEaiu4PjpLPo/nNM9lY"
Date: Mon, 23 Nov 2009 11:49:22 +0100
Message-ID: <1258973362.7094.151.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mNEaiu4PjpLPo/nNM9lY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 12:44 +0200, Maxim Levitsky wrote:
> On Mon, 2009-11-23 at 11:27 +0100, Johannes Berg wrote:=20
> > The /dev/rfkill ops don't refer to the module,
> > so it is possible to unload the module while
> > file descriptors are open. Fix this oversight.

> Thanks for the quick patch!, works fine.

:)
I'd tested myself in kvm so didn't bother asking, but John can add
Tested-by I guess if you would like.

johannes

--=-mNEaiu4PjpLPo/nNM9lY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCmivAAoJEODzc/N7+Qma/jkQAL+didyxU7RvEosHRmGIwTAS
x5OZ6eS3f/Tn1XsLD77Mtb06aoHvfzkBz8/puYhOWayYyYDy7UvrbIqAXN3bkW93
BIYEYwRn5bqZFgDX0Mid9y8fVXodQQkmcxNfkyrDXVdKc4tl6/1XYEVI8RmLxYft
AnwVeTDJVq0HAJ+7fByVP575l3oGUGUsZl23zFyHjMT9RGCSX4+GzW0sQFk/th9M
YOmAhwvhQbyQXAsww05z9dYft/JWUY8W+VEx/Fz4kALijFApc1wDLA27Gt2UahDv
tIlY0imKSHEpXZtgD7oGkw5yq8KS5thxrjj4Wit0N5gKXqyM0PiHiALP0WFDQVgf
UnZcX8KYAVjaPMpiEuWA+d9V4lyvecZWH+dkdX8FVG/vr9WutsaCxzdK76bLUZfe
beGcQy4bhgzyOKSu7MQh/r7vmQHqXGqZcLAG9ZZ9tC5VmHITtd6vnkkPuQp1KDaw
GLVbeuHDV26HwIjlzKayvDWvJ4DBmUpfDb/bNOCSWL7NVXYzjI2RCEniPM7Eyic9
bIuKJfpc5WxV0EYe/hvQ/K0opkalLjS+fI+6fHR3xUI+fD3+EEZjC8uNXIm9717C
Dd+jZh5vARDBLjOwhioRFGy0jYtRWcr9fpvCIVV671pCJEivdS8Igdeo8m+6+R5j
AphSr6DdG2RvBPVYpy3N
=ZxTh
-----END PGP SIGNATURE-----

--=-mNEaiu4PjpLPo/nNM9lY--

