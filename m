Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40004 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZHUMjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:39:39 -0400
Subject: Re: USB wireless support for ARM device and old kernel version
From: Johannes Berg <johannes@sipsolutions.net>
To: Miguel Garcia-Lopez <mgarcia@envitel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <55FEAD01-712B-4165-9F4D-260BDC3CA14A@envitel.com>
References: <55FEAD01-712B-4165-9F4D-260BDC3CA14A@envitel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-78QpQnQyS/4f41x32PCB"
Date: Fri, 21 Aug 2009 14:39:37 +0200
Message-Id: <1250858377.5137.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-78QpQnQyS/4f41x32PCB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 14:12 +0200, Miguel Garcia-Lopez wrote:

> Any hints on what to try or driver sources distributions I could try =20
> to compile against my 2.6.10 kernel?

There are none. 2.6.10 basically has no wireless drivers. You can try to
backport compat-wireless, but you're on your own. Just upgrade your
kernel to 2.6.27 or later.

johannes

--=-78QpQnQyS/4f41x32PCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjpWGAAoJEODzc/N7+QmaEi4P/iL5jfrgloXJGOaRTPDFiqQ7
YgHkVxaRukLO580kNBv7pQ8xb864r9THOoDtGLQTGvgIR2r3WALia6YHdxnqYruq
SK2p9wtvEVkzhhzcaEcAot2vSMdamFKQc1+YDsFWUVvbU0LT/exZu3kVCkEuqEtF
+MBLqR9cWy9G7JLPon47rXelamY2vfJBkC40PRgIX/G4w3htSQveVLxddtFHmBRT
fR58/2DOS7NHPBndi9ctkqKtuGfGn86/7ntcXwsCn74QZ5jhfkpKOy8O0nhdSn8r
+qvmo6qcMZ8eo4UBiQDqnjXpiaSun3E23mK9IpSUnvg4UWDYfug5YA6j8qFQJVep
OwjBVH+QmMxWXUM2wV6tFgMt5Nh1byg0cu30WIdjHMzUYKQYuZi13nOMyDSvcqoe
khfjq8FSxGq0tndlHR7ILpQs6+lFUIaf54f8SxOyy+GCjdzr7C5PUXNtEGEHLBb6
gWIwQwSQXZtX3xsqzQtI6ZFKqPon6TiHb6ar+FwUYmJrNxfCTJ/hZcuxhN8vLMDX
yiNVALARPaS3rmobSVfbj0QJQoKRCadIxBw7+5kzV9Hol5QYy20p9sYRpp96Ltv+
Ui4qof+TOJKrLq78dbviGnTqARRDMd0kN53CHW7qvRhHNhgwjYs8mfOSwCiMcqf2
OK5F7mguG+O9TsAHA6+W
=Kdxu
-----END PGP SIGNATURE-----

--=-78QpQnQyS/4f41x32PCB--

