Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYBTSk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:40:26 -0500
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb
	adapter
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo Couckuyt <iv0co@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47AF79DA.10204@yahoo.co.uk> (sfid-20080220_180121_070641_4FFC2208)
References: <47AF79DA.10204@yahoo.co.uk>
	 (sfid-20080220_180121_070641_4FFC2208)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/23j46aXtosL2ItY+9Xn"
Date: Wed, 20 Feb 2008 19:40:11 +0100
Message-Id: <1203532811.17534.79.camel@johannes.berg> (sfid-20080220_184045_320580_20CB8DD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/23j46aXtosL2ItY+9Xn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I followed the guidelines for a bug report.
> If there is anything else needed, I'll be happy to do all the testing=20
> needed.
>=20
> [1.] One line summary of the problem:
> p54usb driver crashes on trying to associate with an ap with the=20
> CPWUA054 usb adapter
>=20
> [2.] Full description of the problem/report:
> What works:
> modprobe p54usb
> dmesg (displays my adapter correctly)
> ifconfig up wlan0
> dmesg (using the right firmware 2.5.6.0)
>=20
> but trying to associate to my accesspoint (using wpa_supplicant) causes=20
> a hard-lock up (keyboard leds blinking).
> Before locking up it spams loads of 'RX: unknown frame received phy1'=20
> messages on kmsg/dmesg.

Please switch to a VT (e.g. VT 1, usually by pressing ctrl-alt-f1) and
associate by hand (e.g. iwconfig wlan0 essid "your ssid") and take a
picture of the oops that comes out.

johannes

--=-/23j46aXtosL2ItY+9Xn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7x0CaVg1VMiehFYAQKznxAApWz+rjRND3UAq4PJyxw7xcnP80O7u9IU
DI8LlgnT71+AmT8Wmn5DxECg45KTTb/qMfXsLwo83yPYZ29qWpYqAoEwodB77BBY
ItgPvvtg8sly4s10VdYegW2cg2SFP8sNGpP+vy8z2Krr3SGF0JhZY+Tu3jpYf1F/
RIRrKC8OY8RlCAbYDG6NMjjEuWX8qAb9BY+1MqStoRnOaOJkpZ/kw93iJVClgkoY
j411kF/UyXleCmciT1s9S9Y8TpscO+q0QquGAsj5GQTuJmxWmQqln1t7ZaQt8RMX
B0WC0Wib3xFqiRH+sukbFuisF0IP2gQpG3V8ulBaG8O08CVSZ1X3+pJOz4ce1R3m
KLgaSWU2ju18sKjZo5i0UQmBY1v3XKCBGGnidiWwlU/+ZWQA04lC8Ar4ZiY8RWSn
WZ0699mt+vSjptO+PtI3TiyksM3rG2mG/fS62bvAEGVxE/fx0D4F6/YNDEDi6uqm
Oaavu1PBK7YudbvukVdGHmN//SLaWpBdLt+dgSiDJm8q+uzr3S3AYAbYSlnsn3Zt
ihfKjTPcLQCtxjKBK5WQ0dU9+SJDjeCoJ+NPQNYsTGsujxiszOHvwTkn+YbfYVq5
/tCxqyQadceoEmgKEFo1+Dz7bnV7dYYjXGKR2g5U/OPE7TDrDmBV+7C3NCTQyOIu
+X6bQzUiInI=
=BqTx
-----END PGP SIGNATURE-----

--=-/23j46aXtosL2ItY+9Xn--

