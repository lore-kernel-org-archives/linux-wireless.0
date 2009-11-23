Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZKWX3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 18:29:03 -0500
Subject: Re: Adhoc networking, was Re: compat-wireless and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0AEEE3.2050808@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OZT+gEr8BBbshzG+Jly3"
Date: Tue, 24 Nov 2009 00:27:46 +0100
Message-ID: <1259018866.7094.189.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OZT+gEr8BBbshzG+Jly3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 12:21 -0800, Adam Wozniak wrote:
> What's the next step in making sure this patch makes it into the real wor=
ld?

In that form, it never will. You need to create it against
wireless-testing, give it a good changelog, sign it off, make it not
white-space damaged, etc.:
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches

Besides, some of it really is a hack.

johannes


--=-OZT+gEr8BBbshzG+Jly3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCxpuAAoJEODzc/N7+QmaYxEP/1HHJy4KnO4HguJRVhlUEUKv
b12zuUyRBUmJBGmnkUumgGGJ4YLbPBcFGTYC8idIfFCwbg+zTM6rV/bIPQ/jLZBp
iBahqeJv8IjeZvLBlvMVKcUDISaLtltoxkNidXBxAtdLW+iBg1xAFiiMf0767PgE
nf2FWf+vB71rlKVsjtBgMigZNrlXmi8FcC3fvoRT8GvInpWfPDgJaYn2Lt2/Z8ER
LJjFCt/SpbTwLZ0Fjs3Q2wv3144ys2brhVk0WjrWqT3gfoSuPFf5XT3rjizbQRFU
UDktkrPjymOpCETywbUFqmbvsAkcJrYW380RpCiLNIrRzur57BTMHec0DtwGRvPi
nnC++iVovsYvIotttEtgaZxavXAQqbBeZ4MC9Xz3rXYoUkn/tl8PRUgGLGZpEUvD
tvN4wAlZlCJyJ6Z2nVB+wpd6zK/pXnNt68W3ooL3n8RenSD1jp4ZriBPJTI4YKc9
jv+/eNgQGXheYgHpJVrROLmiVexip4xO3YVSbkOj1pJO1BMMDN5cfpUZKL5aS8XQ
fQP9BGZOSnyW+MB+xSXyMS4eVut8BVQdAWFNOmyfrNYD5uxMv3aeMPd9fPt1wZ9x
4Y2oQDlwtQNHFBizG34KnC//G98w5nXoYZuNud8fu9EBW9oT/rafRAsJbCba0Cqo
AyildErCQwaHnuC5YwVi
=TkVU
-----END PGP SIGNATURE-----

--=-OZT+gEr8BBbshzG+Jly3--

