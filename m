Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbXH1J1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 05:27:41 -0400
Subject: Re: port of my recent patches to net-2.6.24
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1188290459.7837.55.camel@johannes.berg>
References: <1188027470.9529.5.camel@johannes.berg>
	 <200708271945.55384.flamingice@sourmilk.net>
	 <1188290459.7837.55.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PAdAY3fi5V39wAjaYjZC"
Date: Tue, 28 Aug 2007 11:19:43 +0200
Message-Id: <1188292783.7837.74.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PAdAY3fi5V39wAjaYjZC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 10:40 +0200, Johannes Berg wrote:
> On Mon, 2007-08-27 at 19:45 -0400, Michael Wu wrote:
> > On Saturday 25 August 2007 03:37, Johannes Berg wrote:
> > > http://johannes.sipsolutions.net/patches/net-2.6.24/
> > >
> > Patch 22:
> > +		ap =3D sta_info_get(key->local, key->sdata->u.sta.bssid);
> > How does this work when we're setting a multicast/broadcast key on an A=
P=20
> > interface?
>=20
> Hmm. I don't think that ever worked correctly for when we ourselves are
> using WMM. I can fix that.

Ah no, I see, I just missed a (type =3D=3D STA) condition. You never send
multicast traffic as QoS frames anyway.

johannes

--=-PAdAY3fi5V39wAjaYjZC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0+iv/ETPhpq3jKURAuI+AJsFpFGLh4iOlg0z8VBdmR04YA9WOgCggTuK
CFBEwP5hYwCw73JAvBWDWbY=
=8R/9
-----END PGP SIGNATURE-----

--=-PAdAY3fi5V39wAjaYjZC--

