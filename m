Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbYHEMvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 08:51:25 -0400
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080805124814.GA32675@khazad-dum.debian.net>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <1217864565.3139.17.camel@localhost.localdomain>
	 <20080804223052.GG24927@khazad-dum.debian.net>
	 <1217890611.17793.17.camel@localhost.localdomain>
	 <20080804233525.GI24927@khazad-dum.debian.net>
	 <1217927541.3603.32.camel@johannes.berg>
	 <20080805124814.GA32675@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9e2zCTlKR1ppJ3EpWklq"
Date: Tue, 05 Aug 2008 14:50:34 +0200
Message-Id: <1217940634.3603.42.camel@johannes.berg> (sfid-20080805_145128_598896_D6AEFF76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9e2zCTlKR1ppJ3EpWklq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 09:48 -0300, Henrique de Moraes Holschuh wrote:

> Maybe on net/wireless, but I am really not going to trust that one for,
> e.g., serial and USB drivers (USB being a bus that is often not shut down
> during suspend because there are USB wake devices), unless you clearly st=
ate
> you DID review them all, and which ones.

Look, this is _clearly_ the wrong thing to do, so unless you want your
patches blocked over it, just rip it out.

johannes

--=-9e2zCTlKR1ppJ3EpWklq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImEyWAAoJEKVg1VMiehFYorYP/0gesJt5Zs470nXphH6UqPHj
2vek9If3w3YLjoSh+Y/WOB+uShs7mXXiMo8nsid/PTD0Tb71wnei+GaDP7YsIRSs
Zl3Hi1kujwsqW7Mri8qGD8hyKObnb/eQn5x8mw1/oQnp20/05QeWA4K3DkZ7kkuA
lgsyWJXsKOz5u2I3muPog7b3sappbb3s5dZmhsoLVeH1ZB8wsskilFq+cUtRhe3n
ExM3gNrEg6Qiod+I3+wYGOtH25mwJp5EU8qnUzC7jcPinD2eR5bjE/lq8rd035qG
67tT/rsB7hIRQRK8pq2I6CV6btTU6WcsmPtw6OU9g+I/vWCMh3eihKUZRoD3SMfR
lkEZlCJ3X6EikhsNLOdN7tenKbHm1bUioZSubjQ0owKpb5MrTC10uPo72YBJeUBQ
bkM0lwVLV4LLS4u73Jhj4euMPYhmq625daBrDY+8svKnDuxatpoBzcrWLdk7yi8b
j9mV2DKjmNwX0qDpRokdWCNvxQkgaB/blO/ePqGFKoebFJQa7Kw3XBSeodadrByh
vUuGg2nx8v930yrssTN1Fu4qw2FlkiF+YFUwyd71o+ujnLxl0T6yJ3cl1jXFNSB9
iFFpajk+cy694Z8h0d4TrcDUW2L/TnmuffDJ+LGlPAZY65PWfLrc8zOe7uKI06U8
XPLiHamK/bMtXlziwVkk
=Ki/d
-----END PGP SIGNATURE-----

--=-9e2zCTlKR1ppJ3EpWklq--

