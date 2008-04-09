Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYDIOia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 10:38:30 -0400
Subject: Re: [PATCH] mac80211: fix key hwaccel race
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200804091639.24321.IvDoorn@gmail.com> (sfid-20080409_153547_539824_75C658CB)
References: <1207689103.7442.1.camel@johannes.berg>
	 <200804091639.24321.IvDoorn@gmail.com>
	 (sfid-20080409_153547_539824_75C658CB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BzBfg/OZRVs7jWMYSgX2"
Date: Wed, 09 Apr 2008 16:38:13 +0200
Message-Id: <1207751893.7442.23.camel@johannes.berg> (sfid-20080409_153837_354487_8BD43B10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BzBfg/OZRVs7jWMYSgX2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-04-09 at 16:39 +0200, Ivo van Doorn wrote:
> Hi,
>=20
> >  enum ieee80211_internal_key_flags {
> >  	KEY_FLAG_UPLOADED_TO_HARDWARE	=3D BIT(0),
> >  	KEY_FLAG_TODO_DELETE		=3D BIT(1),
> > -	KEY_FLAG_TODO_HWACCEL		=3D BIT(2),
> > +	KEY_FLAG_TODO_HWACCEL_ADD	=3D BIT(2),
> > +	KEY_FLAG_TODO_HWACCEL_REMOVE	=3D BIT(2),
> >  	KEY_FLAG_TODO_DEFKEY		=3D BIT(3),
> >  	KEY_FLAG_TODO_ADD_DEBUGFS	=3D BIT(4),
> >  };
>=20
> Just to be sure, but the duplicate BIT(2) is correct?

Eh, no. Wonder why it actually worked.

johannes

--=-BzBfg/OZRVs7jWMYSgX2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/zU1KVg1VMiehFYAQLoZg/9GLMVeyu5jKEJrFHsJs3aISwoluKQDy78
TrTxtsp/iAeGrYswqgphwyxRaS694FOOqsWbqlF5XZdcQlUbMQaD62PU+1Wri/uD
knldfUPpyhRMfyAXZTd7JKebxSyVM2ktm4+57HJucQvnxCNlz9RP7nB2Q3FigfCN
MZNGkiDcqd095w1gsznJ1V3jMACggpeZAcciK86tz7iXann/kszt9NeJhltapQFC
su2HC4gZjPaL2nKFfgpnJzDTwXXWz7oeX4nxHGsdEcqa7qqxnq2PSfOnB+SKQ1DY
7xqPlJ/8g08QaaRFhPutnrTU1WEUQpgNVJ6o5etsJlMWYX+8kWZlK4rVyNEvHiI2
kQqgd202hjUavsMTFZf8gHy9MyOuYBuMWrHFQ9P6uAoHD6362gmGHjk1Vz2mn+zO
R4Efgm/nLyV36arr9ga6RkGfSQmkbxqR1xKo+KIFkObv7Gj8G8NDDUdpilViZtZi
EVRv0TNOhddODC65dD6TbiAbjYwt8PNovb0X/AecGA60s9fby/V3PMVnfYyihZOz
DQWVKA58Or0veacKMDsdbV2SKr5kG/2NQLA1B9FqfikxKOXe1aNw4JqyZSZ8dbW8
gMTFWN5jRsFu/DO3XTvvCFEQgMiztW+7DPkbkpev+3zPnts6oe8qVWbPtRrOJCWb
QCpAUUpiXIY=
=41HP
-----END PGP SIGNATURE-----

--=-BzBfg/OZRVs7jWMYSgX2--

