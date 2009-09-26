Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZIZOD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 10:03:56 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <1253970049.5122.31.camel@johannes.local>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
	 <1253813740.3868.324.camel@johannes.local>
	 <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
	 <1253816614.3868.406.camel@johannes.local>
	 <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
	 <1253856038.3868.500.camel@johannes.local>
	 <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
	 <1253868214.3868.713.camel@johannes.local>
	 <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
	 <1253970049.5122.31.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1YIYbLBrM69ywI4fZbro"
Date: Sat, 26 Sep 2009 16:03:51 +0200
Message-Id: <1253973831.5122.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1YIYbLBrM69ywI4fZbro
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-09-26 at 15:00 +0200, Johannes Berg wrote:

> Well the problem appears to be that wpa_supplicant isn't getting started
> by your distro any more. Unfortunately I'm not familiar with opensuse.
> It seems it thinks the device isn't wireless but wired, since it starts
> ifplugd. OTOH maybe it wants ifplugd for wireless too? It's possible in
> theory.
>=20
> I'm downloading a livecd to figure out what might be going wrong.

It appears that just uses
	test -d /sys/class/net/wlan0/wireless

but that should be ok, unless that's actually a link now for some reason
-- can you verify what happens there? And double-check you have
CONFIG_WIRELESS_EXT_SYSFS please, the config you sent me did have it
tho.

johannes

--=-1YIYbLBrM69ywI4fZbro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKvh9DAAoJEODzc/N7+Qma5QkP/07EEtvsjqlIDalO1SwtM32n
sz5BGy0cTvfHDHjtdHJodeirOlsLXeCA6t/MLntZR150/bsCs+7na3oCzRMCMLPV
l2xu9Bnce+Q9h3Sw0kJ4YbtDg114k1VeGKGW6QW8LX6bypWGcYJF7YyJCHC6FlUB
jtVnDw1iMWbNeZFXLdiaKMb5Z1U3XyBSjSUU3gSg6fdM77M1yTc/OIocrk4zVO9E
gC+ELNHakMqz+J3y0AHFb33sxvji3Zb+h4pcMaIwVYu+na5UiFTuc2h++0rmSU9u
1+aolOkEKXCDLZJzJN41t0c7+FGuHN4YV0VLEZbQb7IZEVaIY9DV7FNnjuUYsPLY
J+hEgMVR19SMxRf9+F4ZR29tl53WxTaCd2kICtPuLaLysHGCVH71CladcTizQLTd
VHGMemLza/Co8mqZkFTk35iDn8fJ1lgJjlz9aq1Fy2dyJyuIZbjPhdI+iBobGX+x
qcHqvFm1YHyqQD237Y83x7V7AWN75+K4UBECavnmmtMGud6JHgsMQxyPESkl+bjp
UWDhkfFt2gDf+YpdRCZ1DTy/4AmIPEsIZJ5cEgEAwIXwkI6yJzJtsI17olSqIfVB
wr8LooqfJJ8c+wy4othjS4JNi4qO/vNvOurqUb1matvvFS/6fwQ5RN38F8Lj/y6P
HAw/q6kvLfDRkNfMEDAg
=YETc
-----END PGP SIGNATURE-----

--=-1YIYbLBrM69ywI4fZbro--

