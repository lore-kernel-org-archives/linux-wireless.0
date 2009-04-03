Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZDCJCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 05:02:12 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238733303.19390.0.camel@violet>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local> <1238733303.19390.0.camel@violet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YVLeGFrUwBkF8PEZNttQ"
Date: Fri, 03 Apr 2009 11:01:35 +0200
Message-Id: <1238749295.27712.0.camel@johannes.local> (sfid-20090403_110216_414079_03400137)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YVLeGFrUwBkF8PEZNttQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> > > The first thing I noticed is that "radio" gets truncated to "rad", th=
us the file
> > > is /sys/class/leds/b43legacy-phy0\:\:rad/trigger,
> >=20
> > Cute. Must be that the limit is 20 bytes (19+NUL) in the buffer it uses
> > in led core code.
>=20
> then this needs fixing in the LED core. We don't have a length limit in
> the driver core anymore. Is this an older kernel?

No, I was mistaken, this is the limit Larry pointed out, and that was
already lifted (bus_id).

johannes

--=-YVLeGFrUwBkF8PEZNttQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1dBrAAoJEKVg1VMiehFYGlcP/34+40F7BU49429znocKYPLZ
fsr8E38O0S3vk89bkCjFn/Pl98mlnbj3J0SdGWUb++/pfmy11w/83IdU3bUyNmMs
OOfdy+VKdImAuVRLo1OuQamhVZDlljnTydwo0HHBVsUPeSPFSgsepJkGGKBpsszg
Qs0zwXZ8cBM3pOWJLAgKlXKgYiIaIZPP+nOcbvqZpMo+7v9kqQEeVeRbMdoByXkc
seKa1dXQWK/qJZZwRI0vY9DL9mkGWqI9dTO0W6K6m1pfTgRTkV6rjvvJCFXGuIPA
1LBdiG6gA1M+bM+/ak++UCpOWcsX5War7X+ntV/IIOEc/c0X4dzTPhXfNPed0Up1
mdiQ0uTIWinHAuWMeaKI3wdufoWq9xkeCnMMZtFhr7EZNZaGdABWLj2gVDdCJZmR
v9xsU0UeEu03qiew4Vmsp2fQkhncuZL6U3LoS6N/dtfAZp7MvZA5rxbEZdmDuLrE
t+DktuMSgJ32FBdEkUdChifOB5BR4nMfADA8hJOCFaYiUucn37FX5mwUe3ec1nDE
ZCVsoPAohgpjPBuJXdecZb+y4V2P1EJSw3NHdAAHWDQW1m68e5v4kq8asm5S4e3N
W3A5bH2YmjOcLfx5pMbpa7r+58TqXelFjyScIw1XKl41GTNMM/+NbuKJiX2555ku
njIivi7PmFuBNWRQHuMc
=WZ51
-----END PGP SIGNATURE-----

--=-YVLeGFrUwBkF8PEZNttQ--

