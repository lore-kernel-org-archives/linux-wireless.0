Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab0AWMrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 07:47:12 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <1264206170.7208.8.camel@wwguy-ubuntu>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	 <1264189560.2593.14.camel@johannes.local>
	 <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	 <1264205494.7208.7.camel@wwguy-ubuntu>
	 <43e72e891001221623v477b9fady32237c1a3aededda@mail.gmail.com>
	 <1264206170.7208.8.camel@wwguy-ubuntu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Yw6UCNAc6Cj0YjY+2USd"
Date: Sat, 23 Jan 2010 13:46:54 +0100
Message-ID: <1264250814.2593.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yw6UCNAc6Cj0YjY+2USd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 16:22 -0800, Guy, Wey-Yi wrote:

> > > We are doing Power consumption test with different DTIM value, the te=
st
> > > is based on test scripts, so we disable the NetworkManager to make su=
re
> > > we can control which AP we need to associated with. During the test, =
we
> > > notice when AP change it DTIM value, a lot time STA will used the old
> > > DTIM value in Power Save mode which cause problem.
> >=20
> > Ah I see. What if there was no old dtim value before?
>=20
> I am not sure, I believe the default is "1", but I might be wrong

Yes, since 0 is nonsensical, we would use 1 instead.

johannes

--=-Yw6UCNAc6Cj0YjY+2USd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWu+5AAoJEODzc/N7+QmaNlUP/3twEt6PlIOHLK4c42P0wf2F
w+pQCCpjOU52FxztaRWK6CgCGIPF/E9dbJbspOythP1eOP+JczikImKVeq4xaYQO
+xnmKtV4C8xaXO3Ok26s9qy0RWMnWOAY1w7O3A0CHK0M+X4nBR+c/E6Mm5fUXGJI
2kNXAz+AeaI4x4VzLsFLm6DieVMppkE8FtHt0vAh8TaphUbiEvI4t/WESUQ7iKA8
cXZLNvn98iByY1q60fYVMqyPd1pRZo6HatP+Rr14wfhu4YfnZg0xpy2QRODG8D49
kx9C/yNDdcinkNaMo0sCybZIfcj7hJjB4qwcNDkEQFgNVauUGKVNmGANi67DIxwD
5iMeVdkZXLcYLwpaVybyZfiEfHZRCkgSQrsP7DlrTmm8JeQVks+G062ig+AaqpYR
srNefY9T+w6WFTPbfsdbR6v5xs21hvjlOmi+uthvO+8ESWpHMKektbMLN9y1Mdwn
c0ozDLNklO9buF9/alDUObISlXDs5tJrpvz927NdNcl0DM+j8DrB0AVK1syi8Zlp
m9stGp9SlT2abdbn8umgvn/tB2E8YrwWC5hiTmQ56Bg/ziJAHfWj6HLa1C9ZXowR
ZL2YqMRNw4P1XFZVvtFxbRoGtGBJBq/Z4Dw3ROlJhfDl+zcsdxrLmtYbZOQFuS8i
VvRQIFg/7VDFNwIVESIl
=aGSo
-----END PGP SIGNATURE-----

--=-Yw6UCNAc6Cj0YjY+2USd--

