Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:40580 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab2BSLu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 06:50:56 -0500
Received: by lags15 with SMTP id s15so4625832lag.24
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 03:50:53 -0800 (PST)
Message-ID: <1329652250.3253.30.camel@cumari> (sfid-20120219_125100_697607_CA97B7BE)
Subject: Re: linux-firmware: pull-request wl12xx 2012-02-17
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Date: Sun, 19 Feb 2012 13:50:50 +0200
In-Reply-To: <1329615009.3258.57.camel@deadeye>
References: <1329493309.21883.10.camel@cumari>
	 <1329615009.3258.57.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pBwXQoVZJquRTnVNI+ZN"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pBwXQoVZJquRTnVNI+ZN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-02-19 at 01:30 +0000, Ben Hutchings wrote:=20
> On Fri, 2012-02-17 at 17:41 +0200, Luciano Coelho wrote:
> > Hi Ben,
> >=20
> > Please pull the latest firmwares for the wl12xx driver.  These are new
> > firmwares that are necessary to use the latest driver version, in which
> > the host/fw API has changed.  We also updated our licence file.
> >=20
> > Please let me know if there are any problems.=20
>=20
> There are.

:)


> [...]
> > diff --git a/LICENCE.ti-connectivity b/LICENCE.ti-connectivity
> > index 085f6c7..da80b62 100644
> > --- a/LICENCE.ti-connectivity
> > +++ b/LICENCE.ti-connectivity
> > @@ -1,151 +1,46 @@
> [...]
> > +   1 TECHNOLOGY AND SOFTWARE PUBLICLY AVAILABLE
> > +   2 SOFTWARE LICENSE
> > +   3
>=20
> What's with the line numbers here?

I don't really know, it's ugly, but that's what we got from legal.  I
saw it but didn't dare change, I'll recheck with legal to see if that is
really required or not.


> [...]
> > diff --git a/WHENCE b/WHENCE
> > index 804c91f..0596204 100644
> > --- a/WHENCE
> > +++ b/WHENCE
> [...]
> > +       Single-role:            wl127x-fw-4-sr.bin      6.3.5.0.98
> > +       Multi-role:             wl127x-fw-4-mr.bin      6.5.2.0.15
> > +       PLT:                    wl127x-fw-4-plt.bin     6.3.5.0.98
> > +       Single-role:            wl128x-fw-4-sr.bin      7.3.5.0.98
> > +       Multi-role:             wl128x-fw-4-mr.bin      7.5.2.0.15
> > +       PLT:                    wl128x-fw-4-plt.bin     7.3.5.0.98
> [...]
>=20
> This is not the correct format for version information.  I'm going to
> insist that for the new files you put a 'Version' field under each
> 'File' field.  Please also convert the existing version information in a
> separate commit.

Okay, I'll use the correct format and resend.  I'll also add a patch to
fix the existing ones.

I'm the new "pusher" of firmwares from TI, so please bear with me while
I adapt and learn the correct rules for linux-firmware.git. ;)

Thanks a lot for the comments!

--=20
Cheers,
Luca.

--=-pBwXQoVZJquRTnVNI+ZN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPQOIaAAoJEKFHnKIaPMX6eKkP/3nck7VuKrQU5hL+ux7Ak8A3
v/qRRACzrJIngKjDYoS4Y1CvxDSH9pqHKdqCveV1TZUFXv5Qsw+HZqHB/1Gv9F0k
nFWMC2p8vWftpXBYHyEoExdd+qaX8IijjHpEfhuP4JbR8uQcGQKBupIeHdzPQK61
XelKySeyYJNrYU88aIpg6kg/95CjavJlCVm0dsQGRTQGVdkivSjhahwS3DsHMtu4
Umve+/3QzBibWlT7XNlsiMUlK4H/Ukbby7DUEPC5MGdAUGuL5fDCKGgxYDL8yT0/
uX4elsWyiufwILN8G/wK2TEpxGmJQd1ayJBReUhP9cxWao/6PkCDzA1xEKX1CffW
sVIbPm1H35B75R+D6X5Pqb0tz5/bi40vvobrmUGd91sD5uCsYjJYF2Zkk73HFYaX
A1xXTqemnyMWFvdBuuhPG8aT/QME98xDkPNxDW7hNYQufZYgHQLKhI1Db+7vMdba
CdUA7kxQLEdaXYTeIj+o5ObH6nDMMpoxlAa7vU0IVSskY+a2xIjuRnYQESW5UwfX
k1xmqgvW65EXV+6o6ojrW78eBd1aRKL0qYmfxPLq1YZjqxREgeOOnJF6pCEsiDlX
MErquMrPd+q4mNVL/CsX50nioYm2AUkel8C4HUiVYdWZuHye0HjI2qG3KzHyUEWk
ErhtWvBdWbyKca7pZHak
=AzzF
-----END PGP SIGNATURE-----

--=-pBwXQoVZJquRTnVNI+ZN--

