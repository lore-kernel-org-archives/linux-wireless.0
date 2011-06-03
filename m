Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:53388 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab1FCNDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:03:16 -0400
Date: Fri, 3 Jun 2011 10:03:09 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Arif Ali <mail@arif-ali.co.uk>
Cc: linux-wireless@vger.kernel.org, larry.finger@lwfinger.net
Subject: Re: r8192se_pci or rtlwifi/rtl8192ce
Message-ID: <20110603130308.GB2379@nautilus.holoscopio.com> (sfid-20110603_150319_706441_5961C44B)
References: <4DE7D5FD.2050707@arif-ali.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
In-Reply-To: <4DE7D5FD.2050707@arif-ali.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2011 at 07:27:09PM +0100, Arif Ali wrote:
> Hi,
>=20
> I was asked to post to this list wrt the problem I have with the wireless=
 on
> my new laptop
>=20
> I have just bought a Thinkpad Edge 15, which has the following card
>=20
>  *-network
>       description: Wireless interface
>       product: RTL8191SEvB Wireless LAN Controller
>       vendor: Realtek Semiconductor Co., Ltd.
>       physical id: 0
>       bus info: pci@0000:09:00.0
>       logical name: wlan0
>       version: 10
>       serial: 5c:ac:4c:bc:27:1e
>       width: 32 bits
>       clock: 33MHz
>       capabilities: bus_master cap_list ethernet physical wireless
>       configuration: broadcast=3Dyes driver=3Drtl819xSE
> driverversion=3D0019.1207.2010 firmware=3D63 ip=3D192.168.10.51 latency=
=3D0
> multicast=3Dyes wireless=3D802.11bg
>       resources: irq:18 ioport:d000(size=3D256) memory:d0500000-d0503fff
>=20
> I have then tried to re-compile the drivers from realtek, with no avail,
> having similar problems
>=20
> At the moment in Ubuntu 11.04, I am using r8192se_pci, which seems to be
> very flakey to say the least, where my connections from remote servers
> disconnect within 5 minutes. It was suggested to me that I use the
> compat-wireless drivers, of which I did
>=20
> I tried loading the rtlwifi with rtl8192ce, but that didn't work and didn=
't
> see my card, but then I guess that would be expected as the aliases were =
not
> there for my card. although the DID is mentioned in the pci.h, so I was
> wondering would this driver work with my card, or should I be looking
> elsewhere?
>=20
> Any input on advice on this card would be appreciated
> thanks
>=20
> Arif Ali
>=20
> --=20
> Arif Ali
>=20

Hello, Arif.

I have a RTL8191SEvA card, not a vB. But I guess that should work. The
vendor and product ID are 0x10ec (Realtek) and 0x8171. It's working very
nicely with rtl8192se driver from rtlwifi from 3.0-rc1. That support
does not exist for 2.6.39 or previous versions of Linux.

Regards,
Cascardo.

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN6NuMAAoJEEWxSg7udFZIDj4QAMYywuoTT/D5twqOuis84qRW
7kblWCIZpEtZ9D1+XcDelFuOtbbXegsWxRKv5dqo4n+MwLbk00t91S+v+ihCJ8B2
lKLlS5xOSH1Z2PJTwAwGh2yStHbtS0lMG5+vDRdQZ08aUh3GW2o4CV6ChjpZki0V
Ad62sMbw8BWKZDu/+5M8W2JWcXNiDbr2jNipp5KVCC/oJkvYg5sBWOAydfcs0x/G
Phy0VrlqPb3/5EYhdzLLvSWZ2OmvZHDC4gV5KfY0aCZvlKThSIG6IO0seI7yGpDo
KDFF1usq5NTm74o7Y2ljZ0ggrpCBGQwRtGZ7FFkOY2dZLsF96hjg8C+aFXO7SMSg
kUS7YccXPxmq7+Gq9SyUcpazdrgoDPf1IHXHm+TJpcTZ1Bbwrs/7mTM62ys3Gmn+
oRGBs0ez7AlBGGa/mvyGEEk1rDFimA+wDgV1+iOi7mUpWMZH/U+AxqbH9AIbES0L
Oh26H7N+qU3GJnlYLR1b5JAPa8E+liL+CjwlRjM3dd0B9cSkqRI9QyrqQ4mqgNGy
reIgDMwTDmXuD8CsL0nHHxciVujOrwS2L5P6DL2Cp3S26OwpSoTPebbWhiK31aW3
XOVFzxHNAS8l9ULvnVKFOogRfJwR8ew96THvQbFKbKNcWxTZRBrDuDT1a0GtZkdZ
ZFca9knC9VtHBxowplhi
=+Y31
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
