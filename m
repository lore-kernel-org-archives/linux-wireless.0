Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYKMMH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 07:07:26 -0500
Subject: Re: Master mode in iw
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Mark Ryden <markryde@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <87wsf74z6f.fsf@nokia.com>
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	 <87ej1f6ggq.fsf@nokia.com>
	 <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
	 <87wsf74z6f.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CzthZ+bCvQaxxqTgjR/b"
Date: Thu, 13 Nov 2008 13:06:51 +0100
Message-Id: <1226578011.5105.8.camel@johannes.berg> (sfid-20081113_130730_329903_F04984CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CzthZ+bCvQaxxqTgjR/b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 13:56 +0200, Kalle Valo wrote:
> Mark Ryden <markryde@gmail.com> writes:
>=20
> > Thanks for you quick response. I know that I can set master mode
> > with hostapd.
> >
> > My question is - is there something inherent which prevents
> > implementing it with "iw"? When comparing to the old set of tools,
> > which includes iwconifg, "iwconfig wlan0 mode Master" works on some
> > interfaces.
>=20
> Just guessing, but most probably because there are no drivers which
> use nl80211 and support AP mode without hostapd, so nobody hasn't
> bothered to implement it, yet.

And there never will be since we don't want the whole AP MLME in the
kernel regardless of the driver.

johannes

--=-CzthZ+bCvQaxxqTgjR/b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHBhXAAoJEKVg1VMiehFY91EQAJc/z+c5Xgyk8/EKf+mQ40kz
6kXtC3LdwGLpegITrfVskZfBy1+jvp9W6WLUmjwXK+PCXuPJB0x4hGyE/anQB3SL
TE2bEt0nTVAsOz4Bv9QoHSU0HYyXnTqE67ColWdvZh2xC3cCHeLwXYh6xWVt82e3
8/DOTr1ODe96Wbaro8CEAJeYjnQfFqRc9yICKLOOhsgfElVuAJyW4koDqZEaGd88
mclUmW5NCDsMeIDt38eyaqmG3hNPqjod2TeIMum9e0jgcqWcJdjU/ZfZw3Wtx8b2
ixEflXPIPmkwTZyMwppGOkd/lWS9rH1QjEor/CoY7QCngOlubFiJZ52N+aZAW8sn
+BQaotguEiRponLZxL5ppkiglVDkgTn/NxzA+om/7xG5T2FMOxkcl7PHYxOVCevu
ZV0x+pS2BfrPnWTd9we6xi27a3AKGHa/mPu4t85KWc009YkjBem6JyWqGhTWV8CW
8jnkIlnzLZiX5fLebCHOEIdwfk6hRiyHrcROrNV2lozOQZoFhkC5hFlrmyDTIKhu
vdbCdfVETaAgOq1XdsXIICN4MGQDCLQDVQrNwrR029Vmhk4X+UmOs0Gt/0kGgGMY
v1q2KbO8/rg13+ag66aKnxb2OEVHAXY2oVJ1vr1QQG/WFBpjd1vcM85NtnXVpmNY
f43ebbfrYxiSAll3ydk1
=fwcZ
-----END PGP SIGNATURE-----

--=-CzthZ+bCvQaxxqTgjR/b--

