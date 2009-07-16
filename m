Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZGPOQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 10:16:11 -0400
Subject: Re: Further improvements to the software scan implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@gmail.com>
In-Reply-To: <200907161138.58874.helmut.schaa@gmail.com>
References: <200907161138.58874.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JE7fXOWyqWLiKyIDPgUo"
Date: Thu, 16 Jul 2009 16:15:39 +0200
Message-Id: <1247753739.30529.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JE7fXOWyqWLiKyIDPgUo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 11:38 +0200, Helmut Schaa wrote:

> Another optimization I thought of while reading [1] would be to take the
> same approach as Intel in their ucode. If a frame is received while
> scanning a passive channel switch to active scan mode and send out probes=
.
> That should allow us to shorten the time needed to stay on that channel.
> Luis, do you think this is ok in regard to regulatory restrictions?

One problem I could see with that is the TX power to use.

johannes

--=-JE7fXOWyqWLiKyIDPgUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXzYHAAoJEODzc/N7+QmabL8P/A4KAGJ+DUCa26YLrlaoAror
3xzqm+JcbIcchoztS7xuLigNkWUzYrIzwJVQTbF2Kf1kaMwil14CtsfFpN3QEBRr
8SC22YHkxXriCe+Ca1O6BLs5IEZskqymsSIyoKioUYOJUgiJs5kdieov2zFznngC
jqYM7HyKdTHfJzkD2HkAxA5q669ePB88OyatVgelSIcenBIvLWqz5h9iTNkWdjHX
O/rIqaB4JlJljVocqpKUEIXY89BO02QPgWQ0Jq/HQghM/0iH5yxNoUxbLJlgp48N
InOGlHjrJB7B6UHDiL6I6fQ58upqOuG13uTxrP2NzqzCUaLLVNp/hPeZSOrFYo01
FYIomz+YpQe02CZrr2pQKglQI/5VmM8d8yhsDjBaSi/64egoiNpoKQAQKshYgn0T
M8V5yoy2NxN+oOCWMSq9zGPe8gi8xdoNW+91Tbaz3ew9VRiFSJyS6YxIRI7+YdG8
yy+p3ox7EyhS3kwU65Fw4LoyOprfcgBz7vFSnBGs3O0CUTzE31GRWZSkhSDGOhy0
0hGB4ODW3aml/S2vEiPFPZAUtftGB20ekNm1hCvtg2ck+QupBLaQIk2x+IC3OjL8
O68h/xf7f8c17WgxUGE7rYZFrOzzE8V9LYK4Su69lYX1tUljbfbox73AVrhg+FOk
R2HV1H/1/pPdfJie2enO
=NZt6
-----END PGP SIGNATURE-----

--=-JE7fXOWyqWLiKyIDPgUo--

