Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33915 "HELO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753261AbZLMNKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 08:10:51 -0500
Subject: Re: [PATCH] rtl8180: Remove usage of deprecated 'qual'
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20091213012232.GA12937@tuxdriver.com>
References: <4b242f9e.4JOejhV35R7ixmmP%Larry.Finger@lwfinger.net>
	 <20091213012232.GA12937@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kboGyy/fZrZKutdLoVl3"
Date: Sun, 13 Dec 2009 14:10:39 +0100
Message-ID: <1260709839.2442.337.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kboGyy/fZrZKutdLoVl3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-12-12 at 20:22 -0500, John W. Linville wrote:
> On Sat, Dec 12, 2009 at 06:04:46PM -0600, Larry Finger wrote:
> > When building rtl8180, the following warning occurs:
> >=20
> >   CC [M]  drivers/net/wireless/rtl818x/rtl8180_dev.o
> > drivers/net/wireless/rtl818x/rtl8180_dev.c: In function =E2=80=98rtl818=
0_handle_rx=E2=80=99:
> > drivers/net/wireless/rtl818x/rtl8180_dev.c:135: warning: =E2=80=98qual=
=E2=80=99 is deprecated
> >     (declared at include/net/mac80211.h:562)
> >=20
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>=20
> FWIW, I think Johannes has a hunk like this in his patch to finally
> remove qual.

I do, but feel free to take Larry's patch first and then ignore the hunk
in mine.

johannes

--=-kboGyy/fZrZKutdLoVl3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJOfLAAoJEODzc/N7+Qma0BEQAK7foU33QFn5ZF5YNyO6yO5g
fU3kDhJ5h7NDPRaEEIUY7QEYHMWhzcNVI5o+BCZ6hlMuSt23y7BmMZ+ev+8b4qds
m1EVuzlojnWCb8eeGR3xjMI2ES2u+auqjW4+ewH6ru65HtivOJijveLbbiTBb6d9
tslZIfdsvOBUEJiXZXq5wVqVOXKUVqRB7TIBWdGuuc+qJ9emUWdB1W5oRBxj4c4j
ho05puBV7vWmyLcMvwMyb5cHzrc8FggaGKB/kBo+eJ2yG4+yGhl7EY9k7Q/f1pm2
h5k+E7EN+yd1UDjcwHFZCLlCqkkzD+SI3MCK1jGB6ImsHp4SlPocjZ4PtzQFniw0
6R6VLvezv1Cy6TiJX+DhDnYLjdtL5D6feM9SEDeu+0iNEUY1Q5/l1oLOCfpgYwMq
/+nIReO5sChyIUYq7Kr5EIFjXdJYckBd3HpqnHXS0JmRbmzMA86SWvHdwHmskDJj
Kv/OmyPpdylNL9WRTrGx34BIMKuzOrj9DalOapUV39NgcvgHOwHa+pfthURYS7IK
3n6y3ymsa5KqX3UaNddj3iQYWkA0Y3306/yXNapLpLOQIkIxaCUlcpUs/I3AUhXQ
kilsYaCDavPD976WZ3XLL81u+UHO3PPuqjbVDg4P9F1ZgvaicxkNzqpxK0mgeUuQ
pRZ2XoKzw9pHyDRBJlDR
=yiUp
-----END PGP SIGNATURE-----

--=-kboGyy/fZrZKutdLoVl3--

