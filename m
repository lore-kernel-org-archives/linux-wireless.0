Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZGIVs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 17:48:26 -0400
Subject: Re: Problem with p54 driver and ibss mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Christian Lamparter <chunkeey@web.de>,
	Alexander Wenzel <wenzel@fgan.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200907100143.29004.jcmvbkbc@gmail.com>
References: <4A55DB91.2070305@fgan.de> <200907092056.53055.chunkeey@web.de>
	 <87vdm1pr5m.fsf@litku.valot.fi>  <200907100143.29004.jcmvbkbc@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uDa9AYPaulvxKBuQ+pjr"
Date: Thu, 09 Jul 2009 23:48:18 +0200
Message-Id: <1247176098.1905.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uDa9AYPaulvxKBuQ+pjr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 01:43 +0400, Max Filippov wrote:
> =D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=
=82 Thursday 09 July 2009 Kalle Valo =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=
=D0=BB(a):
> > Christian Lamparter <chunkeey@web.de> writes:
> >=20
> > >> These data for sure must reside on /dev/mtdblk1 partition, but
> > >> they're probably somehow coded/obfuscated. I couldn't find anything
> > >> similar to MAC of my own n810 there.
> > >
> > > well, this is c0ffee comes from nokia's stlc45xx-driver.
> > > Unfortunately, they don't say how to get the device eeprom from the
> > > mtdblk1 partition. However, they certainly provide a tool stlc45xx-ca=
l
> > > (available at: http://stlc45xx.garage.maemo.org/ ) which can be used
> > > to locate the eeprom's calibration data.
> >=20
> > stlc45xx-cal pushes the device specific calibration data and sets the
> > MAC address. It's recommended to run it to get optimal performance.
> >=20
> IIRC stlc45xx-cal pushes these data into sysfs entries, which stlc45xx us=
ed to create.
> There's no such interface in p54spi.

Should be easy to copy the code into p54spi, we just never did, hoping
Kalle would come up with a better way, maybe request_firmware() :)

johannes

--=-uDa9AYPaulvxKBuQ+pjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVmWeAAoJEODzc/N7+Qma2MYQAKQCTXdbEZuU1knCbkHy3XQ7
mtWCfqmPeteK7AFJ9zdPIdcOC1fJ66R72b4Jxi2XJJF8a0RjGnmjp3XvBVuc+C2W
Tm+5HlZ57YyKjqPx7Hr9sJGIfvtptZGwlnuW22kUxxB3oGwxAj1ZCRcNk+bIeNHE
IgHkbA2roltBuoiuZWTyOz8j7+m6OvpTR+mXrCjRZEHitNh2p+9FKqjB7/brlixp
kuoHqZAhU+R+SD+V98avwA2EhWotaeJxRM2C4y0DuP2IIRLk30/FWKK5BjIV7mde
t5FtLEF0wNkQBmc7kyWU7y/z9hMeMA1SUMaUfaFI9vCwla8Rf5FoRrOcipdjE5S4
bmVFYq6fvDp/1QWqzbUxqvcYZSXLJu/jLxovkMSQvMp1Nx0G12sC8jcTbCqdRZ1+
NM3G0VV3Z481WCK6OjTud55l9ccBGxsPx4DGvB2cPd3+QG1msoGXdtHQ3e1/YV9s
9/7OqcnPnDBfbOEYfJGZLMnE5n4OXN7YpbK8UsakLwHxjBua5MH2i0t2ML7gdQcq
ETNkLhhlbChe1FEKjRjjz+rRLyHSBp91gKiJVznGqP9Fy7ygvsIaYepo5ZNN01ya
K633WFo1AluudwsnkB40Oe7WEf8mVWF85IEh3maHpYnSoOK/WkPpAa1jYXhSxtqz
FADgiNAnQa2DYu5Au0q1
=1AgK
-----END PGP SIGNATURE-----

--=-uDa9AYPaulvxKBuQ+pjr--

