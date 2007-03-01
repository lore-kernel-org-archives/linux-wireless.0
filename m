Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbXCAOQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 09:16:26 -0500
Subject: Re: [TRIAL BALLOON] rework wireless Kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890703010611o33b2a5b3kc43cadd2a11a5287@mail.gmail.com>
References: <1172755537.11911.50.camel@johannes.berg>
	 <43e72e890703010611o33b2a5b3kc43cadd2a11a5287@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EXwEQQXgL56vRy501+2W"
Date: Thu, 01 Mar 2007 15:16:02 +0100
Message-Id: <1172758562.11911.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EXwEQQXgL56vRy501+2W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-01 at 09:11 -0500, Luis R. Rodriguez wrote:

> > --- wireless-dev.orig/net/wireless/Kconfig      2007-03-01 14:18:51.854=
246483 +0100
> > +++ wireless-dev/net/wireless/Kconfig   2007-03-01 14:19:19.614246483 +=
0100
> > @@ -29,3 +29,11 @@ config NL80211
> >
> >           If unsure, say Y.
> >
> > +config WIRELESS_EXT
> > +       bool "Wireless extensions"
> > +       default n
> > +       ---help---
> > +         This compiles code for the wireless extensions.
> > +
> > +         Say N if you can unless you have external modules
> > +         that rely on it.
>=20
> I'd say we put more descriptive text here and explain a little of how
> cfg80211 is supposed to replace it with nl80211.

Noted. I'll need to respin the patches anyway and just wanted some early
feedback.

johannes

--=-EXwEQQXgL56vRy501+2W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5uAi/ETPhpq3jKURAlnnAJ9KE6g1bEhhw3VEFeIjNgafklQ+agCfYLso
wVw+Oy8xsmV1WAITC4hTNBs=
=bAMI
-----END PGP SIGNATURE-----

--=-EXwEQQXgL56vRy501+2W--

