Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:55407 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1KUT5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 14:57:45 -0500
Date: Mon, 21 Nov 2011 22:58:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ath6kl: use a larger buffer for debug output
Message-ID: <20111121195823.GN29436@mwanda> (sfid-20111121_205750_399413_2F3D2438)
References: <20111118140906.GA9685@elgon.mountain>
 <1321625461.10266.57.camel@jlt3.sipsolutions.net>
 <4ECA826F.8010605@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iwjEIfU64POCkTAH"
In-Reply-To: <4ECA826F.8010605@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--iwjEIfU64POCkTAH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2011 at 06:55:11PM +0200, Kalle Valo wrote:
> >>  	len =3D snprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
> >>  					ar->listen_intvl_b);
> >> +	len =3D min(sizeof(buf), len);
> >=20
> > Maybe that should be scnprintf instead then?
>=20
> Yeah, I agree. And most likely debug.c has even more cases where
> scnprintf() is needed.
>=20

Yes yes.  Obviously.  I sent the patch at 5 pm on Friday and lost
track of it for a bit.  I'll send a fixed version tomorrow morning.

regards,
dan carpenter


--iwjEIfU64POCkTAH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOyq1eAAoJEOnZkXI/YHqRWr4QAILJWyuKGnhNL7DilqvGYNHS
r+hDsdrNdQ/q+4Ln2/rFaH58ebWLHMExFglRj4to374Ok6TdndYOS4EUcbobuzZw
LaCxzbl58aPX66Po1fvCQizxOKsNC5t70eiFCPzJS15U1iTirHOq5X0NagRvgSqo
EjUpo/QeGYIavGAH2Ej2TuCJA7p959lrbQ5g8PpO8dpsB0nayNJNhQ8fTWBnlDvE
eushXUtXc/4Woq28whbb0hKk/r5tWrwxV4E4860xmT79YTNdAwKnJi3vqCqvnJBi
BdoYneWMczmtgIMZygYdonHkp/364LxyMBj4lanvadBlfU3UoHccLwZsYEvQ1vmK
dnEvbZ1X+zuKLJNZJE2ojRY/RV/PoJusXAxQucZCk81+xKFUiTIGnVDiQ/DtCpoL
vN0b04lh0UHAWyadAOcSzaonJnZ4ZZHzAqcSuAvnHXI5BIrxc3xGqINYPRzGqYLv
4NbQ7BiwXP3a+it4LWVCHkeQYFlNXZ77XBCtGd6QUJxB1weXYEsF/wMOVHjHOi2t
iHUWaPTdngmJmhGtCJhjCUqPkRxB7rzPl8cdS2xgcG1OqbQHUv7PfwSjvQnzPcMe
e4PqQCxE9ROC113h0isQuH5cSBau3hfrmzwPhIqlcLEjVI1Ivv++KJEXB/ysP/3E
JJXQeAQdgrdCtBI8G9Hx
=gUDp
-----END PGP SIGNATURE-----

--iwjEIfU64POCkTAH--
