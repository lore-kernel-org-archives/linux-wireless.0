Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYFPUWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 16:22:38 -0400
Subject: Re: [PATCH] mac80211: remove shared key todo
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213647566.18384.6.camel@localhost.localdomain>
References: <1213642529.3803.47.camel@johannes.berg>
	 <1213647566.18384.6.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ae5fUZFtWlPf9p9EWJnc"
Date: Mon, 16 Jun 2008 22:21:49 +0200
Message-Id: <1213647709.3803.50.camel@johannes.berg> (sfid-20080616_222253_276747_9564BA71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ae5fUZFtWlPf9p9EWJnc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-16 at 16:19 -0400, Dan Williams wrote:
> On Mon, 2008-06-16 at 20:55 +0200, Johannes Berg wrote:
> > Adding shared key authentication is not going to happen anyway.
>=20
> +1; I've _never_ heard or seen anyone using Shared Key auth with adhoc.
> How would that work anyway, given that there's no AP to send you the
> challenge text?  Just auth against some random peer?

I have no idea. Usually, you don't even do open auth for IBSS, there's
just no point. Unless you get into IBSS with encryption, but we don't
really support that yet, and we probably never will actually support
that without the userspace MLME in wpa supplicant.

johannes

--=-Ae5fUZFtWlPf9p9EWJnc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVstZAAoJEKVg1VMiehFYDLEP/R8XsQbhyqzCtVxeTL9JBOlD
cHtjAGPoKpDDXHgS27OlBXP9i1KXu/Nzo+JqKa6+GOkciAA1VMjQZvnnpB2TEosd
6y/V4BYXJe/zZ/lSXWcoWBMb4rXHJUxyJ7UejMuKqKon/2lkNVWBi2skOZdPkbQZ
woko1inFBfCbbjVFtHvTv4LcGp0dZrzlLu0GXfBDcf2fvESU3JSGUl2ku4/Alx+r
q+NaZ4pHGww3Trl2JBRGBIZ8xg7bjnezWa/daTvbmtZrV3pKdumH89qujQc+SufN
L9w4HEuneQHbWLGL7s9ag8OfUUWLQ77VSkI5fe4MpOY9nJhfvDj59Wd5XPltwpTm
CrRMS7M0qQZJERmmHOTUhepphDZG+qZt4sEJx3nxc6mfOksdIKQUFkX9abPXsSAR
Z49JfB8LzF7Ocwz7mqQuT039SpKb2fpZlQzKgBhKpsg66XNaXfDQlPCERN8gUVbP
uCl/5OoSbzvnGGgwaxksFoZEkLWx0i527CQBZE2UaBVjoGlBzPvEz5SzLNpBCXaC
PCqfwvEn4KFsOEk2FN+ow64txoKfRqSE8jMlMkjzcQaylD57hlecJpYLYuLglmiu
+3/uhDHkJTH9dRdCY30SmJMCGz/tyGssplpDcmL25jHjp1vXevzCDT4NcDnXPDQ8
pZW3gd+j92J68smc9zW/
=6W9H
-----END PGP SIGNATURE-----

--=-Ae5fUZFtWlPf9p9EWJnc--

