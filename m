Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57174 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbXHXKPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 06:15:41 -0400
Subject: Re: [PATCH 26/27] mac80211: refactor event sending
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708231817.04416.flamingice@sourmilk.net>
References: <20070821145905.689978000@sipsolutions.net>
	 <20070821150052.127733000@sipsolutions.net>
	 <200708231817.04416.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DxbbWcBzeu8t5YEVvVcV"
Date: Fri, 24 Aug 2007 12:10:32 +0200
Message-Id: <1187950232.24933.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DxbbWcBzeu8t5YEVvVcV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-23 at 18:16 -0400, Michael Wu wrote:
> On Tuesday 21 August 2007 10:59, Johannes Berg wrote:
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ wireless-dev/net/mac80211/event.c	2007-08-21 16:00:34.715923881 +02=
00
> > @@ -0,0 +1,36 @@
> > +/*
> > + * mac80211 - events
> > + */
> > +
> Should probably make this look a bit more like other files in the directo=
ry=20
> and add the usual copyright/license boilerplate.

Can do that, will post a patch.

johannes

--=-DxbbWcBzeu8t5YEVvVcV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzq6Y/ETPhpq3jKURAgqqAKCOcHN0OuaLjndduEUea8HLm7fjVQCfRXvE
+VUzg/oORJxsFDytLfEbmiU=
=Qis1
-----END PGP SIGNATURE-----

--=-DxbbWcBzeu8t5YEVvVcV--

