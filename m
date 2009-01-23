Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbZAWVxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:53:01 -0500
Subject: Re: [PATCH] mac80211: add interface list lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200901231748.46076.IvDoorn@gmail.com> (sfid-20090123_174920_595672_D8B92898)
References: <1232643879.5819.5.camel@johannes.local>
	 <200901231748.46076.IvDoorn@gmail.com>
	 (sfid-20090123_174920_595672_D8B92898)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hDWY440WbTzHuw9PEFhY"
Date: Fri, 23 Jan 2009 22:52:53 +0100
Message-Id: <1232747573.3977.0.camel@johannes.local> (sfid-20090123_225307_777899_D21464AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hDWY440WbTzHuw9PEFhY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 17:48 +0100, Ivo van Doorn wrote:

> When this is merged, I'll see which rt2x00 work structures can be moved
> back to the mac80211 workqueue again.
>=20
> But it probably also mean the kerneldoc for the workqueue field of ieee80=
211_hw
> needs to be changed as well. It now says:
>=20
>  * @workqueue: single threaded workqueue available for driver use,
>  *	allocated by mac80211 on registration and flushed when an
>  *	interface is removed.
>  *	NOTICE: All work performed on this workqueue should NEVER
>  *	acquire the RTNL lock (i.e. Don't use the function
>  *	ieee80211_iterate_active_interfaces())

Indeed, thanks for pointing that out.

johannes

--=-hDWY440WbTzHuw9PEFhY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJejwyAAoJEKVg1VMiehFYVDcQAK8ZDmvQr0T0RFlX70ccwqe7
W8CF+RbOYpCx/1lEsFw8YA97ttebgqGWHyzSGAleQJiP925F5bb1gicpxZES6BKi
6baaeBSRf38XIovc8cR4rDGZh3TqtsiUOnFEIDNU2wlRmQD15Gtx42BL/SMCeUk/
AezZvMAfJwd4+Ce0PXJNHdZhiUA2nM3kHvc7OVYS8vVf+46xFWnAbuonB/zr/Myz
IxnjNu4h2OkyMrfSehnvG2vmGWSba8dXdLjvpK829+CDm1zHeufwW4+KFxdm9E1q
ecYr3hmcQ4y7kBhA1ntKYQeZ3fjsJg2VHHIOGt2XUna2SXZmDCoB0LOwQU/5mAQv
v4vjjQpSCOQtoWrAMCqUwiL+YSu1K0PP4ODYNYhMZN6AQLCiAec823nv9OKsGvQZ
VTkgEhpsU6bDY5sYgKnShniPAO5Nf7WYol5I45U9F5ZsfYM/0FUf6gSezibDmJJI
l5iK+Km3h0XN1AGD1Ths802nRgrv932eSr7Ui5hOMkItLCXXdHU5WM78i9z+6/Ma
zUYW86bdHkb+clasnRs+Av1TeT1ofbu6hLW8+xnYd2PAp6H1E5YZ21GGKO2kF1+o
MudDQO+t6KcIBAnsoDmFJa7QQWv/6Seqaghfq5NXKiIODY2iN70CibvWltMb7Fcp
ESjdWROXvOG+O0yJXl0U
=3WnM
-----END PGP SIGNATURE-----

--=-hDWY440WbTzHuw9PEFhY--

