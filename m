Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668AbZAWWVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 17:21:33 -0500
Subject: Re: SIOCSIFFLAGS: Name not unique on network
From: Johannes Berg <johannes@sipsolutions.net>
To: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <49788E88.5000608@telecom-sudparis.eu> (sfid-20090122_164716_230276_D922DB9D)
References: <49788E88.5000608@telecom-sudparis.eu>
	 (sfid-20090122_164716_230276_D922DB9D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yjnvxU+vhFnH1Us6uQWf"
Date: Fri, 23 Jan 2009 23:21:28 +0100
Message-Id: <1232749288.3977.14.camel@johannes.local> (sfid-20090123_232137_546763_1DE11378)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yjnvxU+vhFnH1Us6uQWf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 16:19 +0100, Chanthearith HUON wrote:

> This wireless card is not listed=20
> in http://linuxwireless.org/en/users/Devices=20
> <http://linuxwireless.org/en/users/Devices>
> but the driver is in the=20
> list http://linuxwireless.org/en/developers/Documentation/mac80211#mac802=
11drivers=20
> <http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211dr=
ivers>

But it's listed here:
http://linuxwireless.org/en/users/Drivers

-- as not supporting mesh.

> The OS is ubuntu Intrepid Ibex 8.10 with kernel 2.6.27-9-generic
>=20
> After creating new interface for mesh "iw dev wlan0 interface add mesh=20
> type mp mesh_id 100". I turned the mesh interface up by "ifconfig mesh up=
".
> I got following error message
> " SIOCSIFFLAGS: Name not unique on network "

That's strange, it should not have allowed you to add the interface in
the first place. But then, you're using an ancient kernel anyway...

johannes

--=-yjnvxU+vhFnH1Us6uQWf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJekLlAAoJEKVg1VMiehFYBQ4QAJN7MejcDBrAgaXcqtuW+htV
OjQ6TJ9a+/xru1ves1dRq7lsiJ/WrqS5QJ77fux+/u3wwEYGUxzvcFCQGjO3soWl
fwXxt+ZeVIgbjZdTmZQPXwUi+itXICXollQLpulB6sbOM3DXfh1O+PknhgPZrYTz
WKb6BrmCq3BP7J+HPBBwwLr+pWh6fXOtf4vhuHmphC2/O9vzX70L4puVITTsOk4B
WxiWka+R8TLPBlhJH7IRgdL9Eg1aWiq2mro4qVWCinCfYuYUK+Gv6wr6ytbk7V03
ICAOrv0Oq7inmG5n2ct7PauphRaTECmF8lPUW35FbDHWFpHSyY1pQySjpd0/Lalr
au2qh+OshgS4en2BGh8Xav9WIFAbR7GRsYCU5qEY3S/qUB+PA0YujkhbGgiAAbfl
lRQHUcfuWQTGpaKJtMoh1Ej5vwxOIqkeAGisrSIvmZsxlM1hsa5E5T//vjWZvhYH
hoZujAvgbtVKZ7tIaJPWPRei7myOsse4qjX8Dnn0+LnB7N5PiMLAQN63LZclUn5m
Vo6H+eKZjY+JnzbhRjuiT4FTh+YkK2zINps99V/r5E0Xu1P0UeyM1/6NIsOgtTVd
jhe9RssLlQVXvcrysZGOii7y4k26lG8gzOxUDPUDTZGWYF3a4PaUJZ/oMOc8QNgc
XJS7WZNGnaS1D/kvBPkj
=h6bd
-----END PGP SIGNATURE-----

--=-yjnvxU+vhFnH1Us6uQWf--

