Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZI0S1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 14:27:18 -0400
Subject: Re: [PATCH v2] mac80211: Fix [re]association power saving issue on
 AP side
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Igor Perminov <igor.perminov@inbox.ru>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090926183446.GA10898@jm.kir.nu>
References: <1253564744.4477.18.camel@sunlight>
	 <20090926183446.GA10898@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jqzVNULPjgTEfNaAy2LF"
Date: Sun, 27 Sep 2009 15:07:20 +0200
Message-Id: <1254056840.6583.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jqzVNULPjgTEfNaAy2LF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-09-26 at 21:34 +0300, Jouni Malinen wrote:
> On Tue, Sep 22, 2009 at 12:25:44AM +0400, Igor Perminov wrote:
>=20
> > At the step 4 the AP "remembers" the STA and considers it is still in
> > the PS state, so the AP buffers frames, which it has to send to the STA=
.
> > But the STA isn't actually in the PS state and so it neither checks
> > TIM bits nor reports to the AP that it isn't power saving.
> > Because of that authentication/[re]association fails.
> >=20
> > To fix authentication/[re]association stage of this issue, Auth, Assoc
> > Resp and Reassoc Resp frames are transmitted disregarding of STA's powe=
r
> > saving state.
>=20
> That looks fine to me and should be applied.

Alright, I'll take back my NACK then, just thought it'd be easier to do
the cleanup in the same patch but I can also do it separately.

johannes

--=-jqzVNULPjgTEfNaAy2LF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKv2OFAAoJEODzc/N7+Qma6vgQAI+oDlPDrBZTQAlLxiGRjSzt
Kfv8DLxoXTFsUPzoX/DR9V2kZCHx/G+G8AN/SRkBqErNRAZQWy5+f895K20ANVD7
FlW1FOZEWi9IJe6JcePS6j8feDzE/QzsGfqLXKoQC7eP+gaOCGXP6Chliuhw7ePw
YnxwJL0/cUwEjlu9D/bmCg0qxk+7WjtIks5T0Kw8hpht35I2dezc34iL03GmlCFY
p94yVJM50zN7Eyj8segpmhoLPMIdqNTZ1DjmftgfXDElVD748dlnzllGbHkIATJX
YfptjjLNAlirzFP3nj+brBasXtkqP41NOjNLs7egsu5nDmJNNiVEffgxiT2oruQp
xbT2OhkWebnJfmOODfnMhEHXYJ4P4DrBL0nerc7+KUSS2ENUUnqAgvYdRYx978rr
BkY/+wL4ZyCwg41zogi+TyZErPXoSx5sFtdbPhUVI4d8mVQ3/Qz94m6CWOF5Ib7C
JdaA5FWtoTHmt9eZ7F/Fe2IReMqXQAO5BuvZ4KOmL5IZnrVasG5zr3AMOBZ7mlls
QfZv6cb8E+oIcqmHANANnZTN91OY2WK8w3JYFDUaHjJks9TKDpsSdpET3pFunmw2
8CenB8WEdO4Dhw0KQi2/Jju7NTNccKftzaKa/Jda4AvbKYaB3nUNj6WWkeJtSAxJ
NHafVU6Yl2TIw6jB7WfW
=ds0p
-----END PGP SIGNATURE-----

--=-jqzVNULPjgTEfNaAy2LF--

