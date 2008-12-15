Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:41120 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbYLOROs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:14:48 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: Dan Williams <dcbw@redhat.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Len Brown <lenb@kernel.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <1229354348.12163.20.camel@localhost.localdomain>
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
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2SzI4owGFjh74QFngTMv"
Date: Mon, 15 Dec 2008 17:14:01 +0000
Message-Id: <1229361241.13400.1.camel@localhost> (sfid-20081215_181519_153089_2371CFDC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2SzI4owGFjh74QFngTMv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-15 at 10:19 -0500, Dan Williams wrote:
> I plan to beat the shit out of the hal killswitch support pretty soon.
> AFAIK it still doesn't know about softblock, which is part of the whole
> reason for the rfkill rewrite in 2.6.26 anyway.  It also doesn't yet
> (AFAIK) support uevents from killswitches either, which sucks.

Thanks Dan.
Could you let me know when you've committed this code so I have another
shot at implementing rfkill reporting in fujitsu-laptop?

> Dan

Regards,
Tony V.

P.S. Did you get my e-mail about the Sierra Wireless MC8790?

--=-2SzI4owGFjh74QFngTMv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAklGkFkACgkQp5vW4rUFj5o2RACePXjspX64bBTPWFMUwk1hIt5A
+k8AoLI2TYCpxtNg1rsYPtkhBOH3zAyE
=Ykvt
-----END PGP SIGNATURE-----

--=-2SzI4owGFjh74QFngTMv--

