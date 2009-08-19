Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZHSNFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 09:05:00 -0400
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) working
 (partially)!
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Huijgen <mark.sf.net@huijgen.tk>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8BF35E.1090507@huijgen.tk>
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
	 <4A8BBB02.4020203@huijgen.tk>
	 <69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com>
	 <4A8BF35E.1090507@huijgen.tk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cf9pNowYfuDom40fMdUo"
Date: Wed, 19 Aug 2009 15:04:26 +0200
Message-Id: <1250687066.1067.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cf9pNowYfuDom40fMdUo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 14:43 +0200, Mark Huijgen wrote:

> After running the included python script, patching the cutter and
> extracting firmware, I now get ucode version 478.104 in dmesg. Next test
> is also without the 2 patches. Following log is from modprobe+ifconfig
> wlan0 up:

Not really surprising, the firmware is for the MAC _only_, it doesn't
really ever touch the PHY, so it's very unlikely to matter.

johannes

--=-cf9pNowYfuDom40fMdUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKi/hXAAoJEODzc/N7+QmaApMQAMXjeKUMxGFEf1QlT70xr/e4
MJLm7G616ZSC482yQBbgBhBkX/w/+z8hPnefdtpEyTboVq5wcfHBYp8EOuQ98S89
XVcWqkhxCgmdvMWLYpkYunZAU6XjhD7UZBrtBdMkZ78VnaEAqmWJ3fy8H5V+MiHa
91WkWPo+xcR3rWzuQVoB4Ppxr8aDIoqRqI1UpxcQaaIeER4FsvoJkbRJBrKle3kN
+PJ7EZmlcHfIrayyvyNRrmT5pjPDvv9SjJmWbX5UOdF8+LWIiP7oDhIrXo1iSK18
0beEyj9rYACEZvekXRiOmLJzUQ65/LJkCp3+Y+rtXV31Z992c0dl0+97qIZ8spnJ
VC3tj0IYp5u4zQ83qomtMSz7nKpMujlG5frzMDAEJmVELntCaRq0D3SxDfguBEeY
/Vs08vdFsqvTLFgfhUxtayuv9OjmngQiLwLOgfn33qmZNp7Wf/gj2uTGPkQpKfY5
m45l4LtN79ELICpMZDf+cWk87ANGYmczJEMYBW7OreGj+exKAUkq1x2G97l0Ki4O
HWNqGkia3L+7csSHjRascixNAdqWTHmbKvNZTyrjrXHvxWCfecvu0F7IjdKEDVFi
z7ssrLz8D3SXKYLGImvrYBw6Pw4bj43d7MKTUlzO1t8GJoWSwDfvrsPa7dD8fAog
h1CZNBkXbLJmhZelcZyS
=DR0k
-----END PGP SIGNATURE-----

--=-cf9pNowYfuDom40fMdUo--

