Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60071 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZGMTPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 15:15:17 -0400
Subject: Re: nl80211 and wext interoperability
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1247512206.4369.67.camel@localhost.localdomain>
References: <1247139797.2144.27.camel@johannes.local>
	 <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
	 <1247163342.22527.2.camel@johannes.local>
	 <1247507618.4369.11.camel@localhost.localdomain>
	 <1247507677.4166.27.camel@johannes.local>
	 <1247512206.4369.67.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I4IMok1cs2ANwoQBFQYd"
Date: Mon, 13 Jul 2009 21:14:44 +0200
Message-Id: <1247512484.30003.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I4IMok1cs2ANwoQBFQYd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 15:10 -0400, Dan Williams wrote:
> On Mon, 2009-07-13 at 19:54 +0200, Johannes Berg wrote:
> > On Mon, 2009-07-13 at 13:53 -0400, Dan Williams wrote:
> >=20
> > > Mainly because there's no way to tell WEXT drivers to "stop whatever
> > > you're doing and just be idle"...
> > >=20
> > > The supplicant clears out the keys on TERM anyway, and in some cases
> > > (iwlagn) the driver will keep trying to reassociate internally
> >=20
> > Seems unlikely, ITYM ipw?
>=20
> Nope.  I saw this behavior with iwlagn (both 3945 and 4965) when I was
> doing all that hidden stuff back in April with 2.6.27 kernels.  Might be
> different in very recent kernels?

That doesn't sound right, to the best of my knowledge the _driver_ has
no chance to try to associate, and mac80211 didn't.

johannes

--=-I4IMok1cs2ANwoQBFQYd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW4egAAoJEODzc/N7+QmazB8QAJ8U1Q22XUY1u62ngJwIrT9d
R3rynjdoGMxp7B9mGzUdhzbbupN1MBpgnPsPLMOuEnjLTNMawqP8H+t991F5dSJ1
C2g2NYYE0tE2fa2DLiCIDZu+jCrj7gSv45PmXav/q40QeCtIXtTN7NkrfzDebM/F
3vJLwuAs9EV8RCLeR0ZAE/PWnYNuXw6+Rode7E32OfwLg24nz21snMVSifuXUIsH
XjMkkqvRd0v2qr6RLfmoSAB7vaPmWleMPc4DwrEU4FgfN8VLck1D3SK7XbSVGPiO
BhgdoCvkIUzpm9ebBt+cEQ6whB3zkLNGlb6uhW8B9tRW5Pu5QVH16mfHw7GYjXgm
YnZWukP+2WERaHcVm/byrqFPqerLQ/eMOJV8inAidyHB9h/7fk8NUv6odoftOh9L
2AciwQ0boBRQd1PNFSdndmYu8bG2e/HgfEHkjh2O8xbQoB1hqY+XsXMHfoTOdcCb
XJ5TIbEmYyMk7XAfB4dos5DQ4lIiXzhdTuzqUA9b1Ybpc7x5B08IABxm9uMAZBfM
PN+Cpm97Bo/Sv4y9WRawK5HJp9g4PSaxQwm8W4dNOj9NReCPxKScqrNw+xDX0k86
vSefznfMUCgJuiqRn14lljjObjxo1EJcypHrkareKrjNxtRG49kwzLtRzMQJsJZB
SltwtsAYVmAG+3KU1lni
=R97W
-----END PGP SIGNATURE-----

--=-I4IMok1cs2ANwoQBFQYd--

