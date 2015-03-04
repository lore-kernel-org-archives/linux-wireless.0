Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:46880 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbbCDVvh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 16:51:37 -0500
Date: Wed, 4 Mar 2015 16:51:35 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH crda 2/4] allow people to turn off -Werror
Message-ID: <20150304215135.GD7320@vapier> (sfid-20150304_225140_282827_3FE839A5)
References: <1425498714-8654-1-git-send-email-vapier@gentoo.org>
 <1425498714-8654-2-git-send-email-vapier@gentoo.org>
 <1425498807.1810.14.camel@sipsolutions.net>
 <20150304202235.GB7320@vapier>
 <1425501103.1810.15.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
In-Reply-To: <1425501103.1810.15.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04 Mar 2015 21:31, Johannes Berg wrote:
> On Wed, 2015-03-04 at 15:22 -0500, Mike Frysinger wrote:
> > yes, if you wanted to support:
> > 	WERROR=3D make
> >=20
> > but the expectation is that you'd do:
> > 	make WERROR=3D
> >=20
> > in which case this code is working as i intended.
>=20
> Oh, interesting, I wasn't even really aware of this difference :)
>=20
> Heh. Goes to show why I shouldn't work with build systems ;-)

no worries ... most people shouldn't ;)
-mike

--P+33d92oIH25kiaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU935nAAoJEEFjO5/oN/WBGVYP/jhdJqFw0G82Zfa7N7GstJc+
tFA9nIb9/cWd/l17VazXSv9/VPwDSpvYEBr8oIGYE5hDBH5j/TOiRXr/GW+XvuJD
KxdQSum8uLjC8A8L2hi8fqrqc1z5ZgMwib5Yzyjbgykn3qA7Yyg+Z+IediC9rHz0
dajbXSwI0k/VBfSPJui6O5IrKp9h7RIQd3xY1WzaM+vEHBj45D50R9NEcOZHk+Z3
aturCqRlYxCabrTWjFiXQPI+THjyEFYeSbWBDZHsHOACjer9WIaKfthe2b3CLMu5
44yFBw13G0F/d/rI+rq7qDJe70vbOUYVvNmx6lokjWpfNrpxQM6kTr/IPRGN0fWm
sVOADaqc2WcX6KE2WjAoNLJjOb+707DL13y3gLEvjtqncw3HvrS3f9oBJgEiIBF5
q605pf9C0/7g8IgR6y7qiVsq5+pR5vmHpD4kc6NyPtPnEedHZQqkkozjq+PdXI+4
cS1y6wADEgJu5tB5/J8hjAKxZ/NpacPjoNqCeeij7YFg8xkt5H3FdOTS0aRgm/X9
EI+bT+TTdBVMPf0JLbtcXxv5mmmUFEagdDmuAr3kvP9a4cfoGyTNEWdEM5VLrwnM
JymnlBu13g/JLDEwUfC5zwKl54YVwIo/T+ZCRFTmOu0rYmSq0GR0o8SZ9RQwewrx
/g+LQUVpeWwht4Pqi0iV
=d3k0
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
