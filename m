Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYFSV0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 17:26:13 -0400
Subject: Re: Broken fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com> (sfid-20080619_230955_857500_99D66B2C)
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1ba2fa240806190446n4d931e6ara4db156900e59e0d@mail.gmail.com>
	 <1ba2fa240806190457w20dfe2d5pf06829b26d2722a3@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
	 <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com>
	 (sfid-20080619_230955_857500_99D66B2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-URKtuB5P6JkG6Xkk+um1"
Date: Thu, 19 Jun 2008 23:25:34 +0200
Message-Id: <1213910734.8967.117.camel@johannes.berg> (sfid-20080619_232627_627823_D9ABBCF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-URKtuB5P6JkG6Xkk+um1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> Fragments are in the air but the peer is not able to reassemble them.
> >> Something is wrong with the first fragment but I'm not sure yet.
> >
> > Hm, ok. got a packet capture? Maybe that was broken before, I remember
> > having problems with fragmentation but putting it down to the
> > known-to-be-completely-broken AP I was using.
>=20
> It is working the latest problem was caused by the driver, Yet i still
> don't understand the regression
> in the driver. =20

Hmm, ok.

> Would be nice if you can confirm it works also with another HW.
> Sending your patch out.

Thanks, I'll give it a try tomorrow with a better AP.

johannes

--=-URKtuB5P6JkG6Xkk+um1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWs7KAAoJEKVg1VMiehFYdoUP/2Co4bq6Kq8dtwrFz0TKCucZ
HY7pzTphfpe1AxApHkyRKRscNGR6T8PT/027aDpZy1ey2C0sRkGfooYSHRCDAoxE
RoL+t/UVQ48A3GlcdMxnactLKzPKjfEYd2Fxx49qdV8kf+QSK+jpmHy84xMsfxv+
9Gp8TPRIb/cKpvuxxo/I/uzvfgi9xzAjAjd6M+portaw3IfYJinmyAl7AIRAJNpt
4qwqc8wMCDfnWRN+y7IbXmPQn+Dx2gsgxiYZBlb36d6/Lvdkc6AHMDtfyA57ZawR
6gfgRj8CChw8yH3QMkXfrexhEdeCGVR1R3XYtXF89Dz3M4GBdNhSuT32G6jS1DJZ
vxfG50urJgmLmYrJ58nSS8h2BIZaJqxBxaJhMFe1OnERg/VkTxJHNyGp8mkTmIkI
I+W7667rM4d01rM/ll5qey6WbX6Nmx+AFxHOFvX5mEqDxxamPu0QBOedSOR51hII
FhC2p9P9IY+NfYJ4lBPZclggkso5JWX7nq6jxjbafxanS3Clb5C38HbADRVYIFzG
l7MtG5R1SBGGudjkvwxnOn56lTzRLS7+PVBD51hAFewXMS1mtfPdEuDiYW7Z0Vfh
mgcDj1v8CnNArEHtfhFOUqKmZHa7wJIf3tIDyWcMb8jMW5Tyt39sd4D/poKZ2Bfz
ZCZLOJ8lInLJfTjyjVqe
=ANnq
-----END PGP SIGNATURE-----

--=-URKtuB5P6JkG6Xkk+um1--

