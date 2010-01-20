Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0ATKQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 05:16:52 -0500
Subject: Re: wireless for manet experiments
From: Johannes Berg <johannes@sipsolutions.net>
To: "Frank W. Miller" <frankwmiller@frankwmiller.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <06EDB64EA58644438DE96E973C536BFF@FrankWMillerPC>
References: <06EDB64EA58644438DE96E973C536BFF@FrankWMillerPC>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yl5ebNRuQ5va3wXzmhMS"
Date: Wed, 20 Jan 2010 11:16:45 +0100
Message-ID: <1263982605.14538.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yl5ebNRuQ5va3wXzmhMS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-19 at 14:19 -0700, Frank W. Miller wrote:

> 1) disconnect the wireless interface from the IP stack and access it
> directly from user space
>=20
> 2) later, I'd like to interpose the Layer 2 protocol between the
> wireless
> interface and the IP network stack.
>=20
> What is the best way to go about these things?

In addition to what Bob said, regardless of what you want to do I would
probably just do it all in userspace with injection and monitor
interfaces, and then for IP offer tun interfaces to the kernel again. At
least for a prototype.

johannes

--=-yl5ebNRuQ5va3wXzmhMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVtgKAAoJEODzc/N7+QmajaQP/0+Z/M9/sBBXTrotOwb+7wpt
0uxF+/LwaCUOa3pg3yGWZrVytWiDc4d0LaVBZKI2aCwPjzCKBAGRWGGoZer4F5pE
w8xqFvY5b0H3n6wsUphswKZQEESR/utfsM/D0BIdriupEBJgLeE00qaASknVLGmI
nFVxSoRCgFENOarhaB7koIbtMvSGlHj/+vXCWHGLg4lHztPtfIF2rk5CDy97ilLC
CNuzwyS8Q41C13HQ9OKtzmx+GWah7rGG7YehsKEmz/nj10GpODR534EKRDTzLi/i
41L316Dl0b+btRWChoLN4SNsnxT30lcY3C54R9Zwklx+AdPBAWQK/H1o4xNG+gGd
XRVs8hwnZDsYCAGlI+A2fdxWcwvRbNVKerTvK60z5v5cdls6SlJ10U6ZtKMxVg2b
Iuq2z0LhWr+02PxB2rya9ot97weqDVPJ+dLdqgCOQc5iBu/6j6rQI8VB40u7kGEk
XRyl7FPCgwg1e8RI84TWPi3zOYLESQskL1rpqoOCwZ1qUuq0RWNhNt6KI1z01Y0t
tLR9y0o0aWVCP1aDEhCzwxHaOlJFAfxCkYZ6BZBbVWSwnLaBHI+QDQiGh07gioO/
IG8kGvFqURjx40Qu+Af7PSvKaxkzQtsFgxfMAA09Z/BiJw1FgY9yedChNuGwpqpM
AIdTtlIm1KbPc1xhWovD
=SvhL
-----END PGP SIGNATURE-----

--=-yl5ebNRuQ5va3wXzmhMS--

