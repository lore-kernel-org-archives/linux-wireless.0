Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48919 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238AbZC0VMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:12:00 -0400
Subject: Re: [PATCH] rfkill-input: remove unused code
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090327143608.GB24288@khazad-dum.debian.net> (sfid-20090327_153635_512916_55398CA9)
References: <1238159804.4452.4.camel@johannes.local>
	 <20090327143608.GB24288@khazad-dum.debian.net>
	 (sfid-20090327_153635_512916_55398CA9)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1arQH5hdNPucUXI2IKU0"
Date: Fri, 27 Mar 2009 22:10:53 +0100
Message-Id: <1238188253.4452.18.camel@johannes.local> (sfid-20090327_221216_295915_46C89C0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1arQH5hdNPucUXI2IKU0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 11:36 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 27 Mar 2009, Johannes Berg wrote:
> > There's a lot of rfkill-input code that cannot ever be
> > compiled and is useless until somebody needs and tests
> > it -- therefore remove it.
>=20
> Just so that you guys know, that code *is* tested :-)

At some point :)

> I'd suggest that the code removal be done leaving a comment in place, lik=
e this:
>=20
> /* Currently, code to implement EV_SW SW_WLAN/WWAN/BLUETOOTH/etc is not
>  * in place since it was unused and was therefore removed.  Please look
>  * at past history to check how it was supposed to be done, if you need
>  * to implement handling for EV_SW.
>  */
>=20
> Because that codepath is _not_ the most obvious thing in the world to
> reimplement without hitting a pitfall, so people better look how it was d=
one
> once in time...

Done, will repost. Do we expect it to be needed though?

johannes

--=-1arQH5hdNPucUXI2IKU0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzUDbAAoJEKVg1VMiehFY7QAP/1s4Orw71XuI6HLq+XltL9Gh
/IQXz/QsxJKZ36RikpHgv+JG6CihGcVPLLsfRrID8QSaRaWdnK2yJKdstEmkX5tU
DphkPMPDhvixtT9Ab6ORmDGs2w8eglvuA/6msR6fD0CfmDQQef5C88YjkYe4SkaU
kt4rpnfPqh8xn37nA7fR4wDq8NkGX0/IkcaQ7NPcsuiMthrj2G6lG5l0UmmZkqTv
WRbpKoL+q4wLVNdtgJRqwVEKT+bnuE6hdtlrGeBKdcGzXo6Rfmft6rNEGclE1yR+
TPIZcdCh8JGPBxd0MHP5dVEO4tpOhas2+wrrxPJcVzmzhTIdqt1GuOkR2EyPCNI3
zq0BVbUvav/Vbstfq+eUDnKOLmza62t4iRi3eD5BX2Q/B/0HbthN32uFXMY45NbK
QeqYMo5NF3ovT3qYySHoZbY9iVY0AM7hUh0/yEq3+gDsQngdz4GUNugBKUMJ4UjK
eC5JzkrNEl5Eftc4kRxauMXnuVMFe0mCQxGX2vrsSb5iCcKhYW620HNdXEExqfss
vvfkeE+w9hjfXgGipD1FJbH7FCSOGSEnMUNAg0/pEyAwAW0d/ebtfgTeumlXVaqp
CHVbgL6NSb5iWLlIuLAAIqb+EESQWd27m22h7QmaFcayIFvHwZZcxGvjDvkQcSxN
XB9UDAIwwvQk4jVAShIz
=8Lqz
-----END PGP SIGNATURE-----

--=-1arQH5hdNPucUXI2IKU0--

