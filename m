Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXKXIev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 03:34:51 -0500
Subject: Re: [PATCH] mac80211: include MAC timestamp in radiotap header
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200711240021.12394.flamingice@sourmilk.net>
References: <1195814754.4149.86.camel@johannes.berg>
	 <200711240021.12394.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DyIqIdtiQ9YxChaEnAIU"
Date: Sat, 24 Nov 2007 09:34:43 +0100
Message-Id: <1195893283.4149.188.camel@johannes.berg> (sfid-20071124_083453_084818_BACCCA0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DyIqIdtiQ9YxChaEnAIU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2007-11-24 at 00:21 -0500, Michael Wu wrote:
> On Friday 23 November 2007 05:45:54 Johannes Berg wrote:
> > This makes mac80211 include the low-level MAC timestamp
> > in the radiotap header.
> >
> No thanks. Not every driver supports reporting the timestamp and supporti=
ng=20
> timestamp/no timestamp in the default radiotap rx code makes it not so si=
mple=20
> anymore.

Uh, so how am I supposed to get the timestamp? Copy all the code into
b43 and make it generate the exact same radiotap header? That's pretty
crappy too.

johannes

--=-DyIqIdtiQ9YxChaEnAIU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0fiIaVg1VMiehFYAQLnuw/8C0iAPg8O12g6ygWE/u/T5ufNOVncivX2
KXyYDU9ab5iPyhhJlMgpUajFCELvumYyYPgbJ3pcqgrBIuQw8/zDN9tZYgJJFR2u
fl9asQ+VKfd1qtipwYQaj5GwW0fF/R2lOtoat9PosJ/hm3++IHxNpCF7fgz1aw//
lqsnXq9SUj86Z2c9t70ncsM7aFVke7bCcDft2Ab0dXzt+f8hPPT64H61q9/Rvgs4
LPC/yRs9dFFTvLyghfNgsKvRH69kaGiCasJCm8Cl/augb5JIpjc2a7LjiZ3S4tMU
njNudlBaStzdjGZZSZ0jCitfQg322HqUYGspqNvwRVHYoNrwHORTPMG7I2st/ev7
hpeUbztdBS5v4HpolH8j1v50T9pjlSduZo+dEMJR7H6snXiOqkB9fYFoEnYaZ5aO
hzBijAEszprfY5B/Vb4aRRNREJNGodAEI0YR0xl/yMuXXjqyYfnuIHnAv4tqcjM7
JK1Lg3b1qGFch33YeSxAcweraf8CgU0RdtkaGqwXqa6PPZmwU+jBPGO5WZrG+wFV
uHVWBxn19aLXJAkKLSvzcNbATbwGmawqFY5kgAjdfl1IA0Jc0+Ps+Pd+OFYv7IQM
ldRuAEgcxRMOlTu/+Qg0vl9/6imLfcZk3UNLaBNPKOZrTwRt/riCQK1OOXMpCwsd
CE3X1z+Nsw8=
=mYMz
-----END PGP SIGNATURE-----

--=-DyIqIdtiQ9YxChaEnAIU--

