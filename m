Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:47268 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbYLPNvd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 08:51:33 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: Dan Williams <dcbw@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Len Brown <lenb@kernel.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <1229363984.12163.114.camel@localhost.localdomain>
References: <1228957506.4045.11.camel@localhost>
	 <20081211165247.GA4844@khazad-dum.debian.net>
	 <1229016827.6446.6.camel@localhost>
	 <20081211194734.GA18132@khazad-dum.debian.net>
	 <1229046602.4030.13.camel@localhost>
	 <20081212195331.GA12679@khazad-dum.debian.net>
	 <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
	 <1229172465.4010.11.camel@localhost>
	 <20081213132857.GA11428@khazad-dum.debian.net>
	 <1229274343.6775.15.camel@localhost.localdomain>
	 <20081215115336.GD17648@khazad-dum.debian.net>
	 <1229354348.12163.20.camel@localhost.localdomain>
	 <1229361241.13400.1.camel@localhost>
	 <1229363984.12163.114.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kA9iDojIHnnR12a5JCkn"
Date: Tue, 16 Dec 2008 13:50:44 +0000
Message-Id: <1229435444.4246.11.camel@localhost> (sfid-20081216_145141_223374_D92BF452)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kA9iDojIHnnR12a5JCkn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-15 at 12:59 -0500, Dan Williams wrote:
> > P.S. Did you get my e-mail about the Sierra Wireless MC8790?
>=20
> Yes; it's hal-info commit 8912ec2b5d0a221a74156c047b18a26b2d916e13.

That uses USB interface 0 like on the other cards. On the MC8790 you
should be using USB interface 3. Unfortunately 0, 1 & 2 are duds that
just time out.
You can tell them apart from the "real" ones by them only having two
endpoints instead of three. I'm not sure whether this is a bug or a
feature yet.

> Dan

Regards,
Tony V.

--=-kA9iDojIHnnR12a5JCkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklHsjQACgkQp5vW4rUFj5q38ACgvmM+99HXvS3P9pUfgg+Jev3p
VXQAniIynzn3fg85gTWtX1/8Z0yt0qah
=lEJq
-----END PGP SIGNATURE-----

--=-kA9iDojIHnnR12a5JCkn--

