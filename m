Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbZLALt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 06:49:58 -0500
Subject: Re: python nl80211 code
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87ws166hlz.fsf@purkki.valot.fi>
References: <87hbsb6pot.fsf@purkki.valot.fi>
	 <1259659425.32171.54.camel@johannes.local> <87638r6l4i.fsf@purkki.valot.fi>
	 <1259666699.32171.72.camel@johannes.local> <87ws166hlz.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7QffdAa/sOSGo5J8Dau/"
Date: Tue, 01 Dec 2009 12:50:02 +0100
Message-ID: <1259668202.32171.73.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7QffdAa/sOSGo5J8Dau/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-01 at 13:47 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> >> The parsing of nl80211 seems to fail. If I find some time, I try to
> >> look at it.
> >
> > Oh, that's not surprising, it's over two years old and after I started
> > writing the C tool (iw) I never maintained the comments in nl80211.h
> > that this tried to parse.
>=20
> Ok, good to know. What do you think if I remove the parsing of
> nl80211.h and instead add the nl80211 commands manually as python
> code? Sure, it's monkey code but easier to maintain IMHO.

Yeah, I agree.

> Or have some intermediate language, maybe. Any ideas?

I guess we could use sparse to output introspection information for
nl80211.h instead, but is it worth it?

johannes

--=-7QffdAa/sOSGo5J8Dau/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLFQLmAAoJEODzc/N7+QmaChgP/2XIl66USTD3RDGWACMiydHe
ObyV1377Ka0Z0YW2T3I6J2FEZxXVH6b6Nfaxk9G7AKD3PHEOegpbxcofQs2Bz6oG
wuFLgsi8S/2NQd5zF1YIjhPfGci1Ykvna+rfgC7dnSl+Deyy7tDKc2MjR9J6VJiu
sL3x532L5hkzTXm+mlk3ciVMTCqVT5yNxlz3x7ABEvM1q2YEsA9+ke3PVIpHSpfa
LmvJOwdtMauBfN+5vnzsj4Ercj2YdZGuFWxNEVCkTVEBulnOwZbPA1GmRn2unN8c
HDMWq0+2XKi+NqUgwV+mDKotQEBxZCzlTo04m3ztlYMpuDGKc8nC2iF7+CaJZFkm
EOJDcl2LoPoB8STwzaO5365ezoSiu8bU3Vy2SI9b6k+u7LkB+zV8rcbr10wbycIG
OUC1Fctnmq3A5+0UngaXwXakLkKGMaCspMbaaQff3v1ZGwLYEco4/M7i8Pa+ym70
M69qssYcg8EH84pDRC9otcxXpdEJcEEsVbSLV+yKY6GknYAAOGODzIelHpDWV1uY
wiT6I85qeyYBhRSNo2pOPD6xRwKSY/3dIfqpB8qD8ugClCQ/xcmC62IEvqIUbE2U
lZgCNzda+uTDJR8CCkacgSqKMidGkXw8LKAaYsRY8EjBwcwK09HevMXY/cRpPnsI
PrgMWieiWw5EtUKPZSqc
=Qgza
-----END PGP SIGNATURE-----

--=-7QffdAa/sOSGo5J8Dau/--

