Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXGIFPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 01:15:25 -0400
Subject: Re: Arrested Development
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <46918403.8080705@gentoo.org>
References: <468DE699.9040708@warmcat.com> <46910F3F.8010201@warmcat.com>
	 <20070708181524.GA12389@deine-taler.de>  <200707082018.23045.mb@bu3sch.de>
	 <1183921731.3771.2.camel@johannes.berg>  <46918403.8080705@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AhTKL5oq6VUAgtHWbyg4"
Date: Mon, 09 Jul 2007 07:15:08 +0200
Message-Id: <1183958108.3771.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AhTKL5oq6VUAgtHWbyg4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-07-08 at 20:40 -0400, Daniel Drake wrote:
> Johannes Berg wrote:
> > On Sun, 2007-07-08 at 20:18 +0200, Michael Buesch wrote:
> >=20
> >> I think it's the NULL pointer dereference of the mac address pointer,
> >> if there's only a monitor interface. The address pointer can be NULL.
> >=20
> > Ahem. I copied a whole bunch of people when I audited that and never go=
t
> > a reply (except from you)
>=20
> I did see the mail when you sent it, thanks. I am recording these issues=20
> here:
>=20
> http://www.linuxwireless.org/en/users/Drivers/zd1211rw/mac80211Issues

Ah, good. Thanks for the pointer, I'm not following the wiki closely at
the moment.

johannes

--=-AhTKL5oq6VUAgtHWbyg4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGkcRb/ETPhpq3jKURAlnZAJ9aYZMFHagfbXTX6YqCZt4YRVHrYQCfSSnl
Wp2sz30BU4hRaOoxDcOLnVE=
=3ZL2
-----END PGP SIGNATURE-----

--=-AhTKL5oq6VUAgtHWbyg4--

