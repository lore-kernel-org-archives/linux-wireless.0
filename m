Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:48989 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab3FQWD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 18:03:58 -0400
Message-ID: <1371506626.5980.2.camel@mattotaupa> (sfid-20130618_000401_234465_2CB02271)
Subject: Re: Connection not established with Realtek RTL8188CUS based USB
 device (EDIMAX)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Jun 2013 00:03:46 +0200
In-Reply-To: <51BCD7BA.1040900@lwfinger.net>
References: <1371326265.9845.54.camel@mattotaupa>
	 <51BCD7BA.1040900@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1I4duDxb+1YAwIZsuAj+"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1I4duDxb+1YAwIZsuAj+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Samstag, den 15.06.2013, 16:08 -0500 schrieb Larry Finger:
> On 06/15/2013 02:57 PM, Paul Menzel wrote:

> > hopefully I am contacting the correct list. I am not able to use the
> > Realtek RTL8188CUS based USB WLAN device Edimax EW-7811Un.
> >
> >          Bus 002 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW=
-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
> >
> > The device did not work with Debian Wheezy with Linux 3.2.x, Debian
> > Sid/unstable with Linux 3.9.x, Ubuntu 12.04 with Linux 3.2.12 to 3.5 an=
d
> > Ubuntu 13.04 with Linux 3.8. The person, from whom the device is from,
> > claims the device once worked with Ubuntu, but I do not know which
> > version and what WLAN type(?) this was with.
> >
> > The behavior is always the same. The device is detected and the
> > NetworkManager applet `nm-applet` is also able to detect the available
> > networks. But wanting to connect to one and entering the correct
> > password, the connection cannot be established and I am asked for the
> > password again. I tested this with different systems and different
> > networks and also with wpa_supplicant. A Ralink based WLAN USB device
> > works just fine.
> >
> > The Realtek RTL8188CUS WLAN device works also fine under Microsoft
> > Windows, so the device is functional.
>=20
> Use a compat-wireless package from 3.10-rc1 or later. If that fails, then=
 I will=20
> give you a debug sequence to run.

I resorted to installing Linux 3.10-rc5 from Debian experimental [1].

        $ uname -a
        Linux myhostname 3.10-rc5-686-pae #1 SMP Debian 3.10~rc5-1~exp1 (20=
13-06-11) i686 GNU/Linux

The error is still there.


Thanks,

Paul


[1] http://ftp.de.debian.org/debian/pool/main/l/linux/linux-image-3.10-rc5-=
686-pae_3.10~rc5-1~exp1_i386.deb

--=-1I4duDxb+1YAwIZsuAj+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlG/h8MACgkQPX1aK2wOHVgu+QCeIbtf8J7J4siVCo49Zn0+9esc
VXcAn1H5YU4cZG07m2VyJ2lZMXeFcMeI
=qG25
-----END PGP SIGNATURE-----

--=-1I4duDxb+1YAwIZsuAj+--

