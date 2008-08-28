Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYH1Kmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:42:47 -0400
Subject: Re: iwl5000 oopses (was: iwl5000 oopses with Linus's tree)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com> (sfid-20080805_172645_224949_17EFCB0D)
References: <1217937364.3603.37.camel@johannes.berg>
	 <1217938927.3603.40.camel@johannes.berg>
	 <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com>
	 (sfid-20080805_172645_224949_17EFCB0D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8/YZDC6AaIHETmlGlt8G"
Date: Thu, 28 Aug 2008 12:36:00 +0200
Message-Id: <1219919760.8434.5.camel@johannes.berg> (sfid-20080828_124259_765644_0EBE32FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8/YZDC6AaIHETmlGlt8G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 18:20 +0300, Tomas Winkler wrote:
> On Tue, Aug 5, 2008 at 3:22 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> >
> >> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty

> > [  126.826663] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux=
, 1.3.27kds
> > [  126.826947] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> > [  126.828369] iwlagn: Detected Intel Wireless WiFi Link 5350AGN REV=3D=
0x24
> > [  126.848680] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channe=
ls
> > [  127.014564] firmware: requesting iwlwifi-5000-1.ucode
> > [  127.170640] iwlagn: Error wrong command queue 43 command id 0x6B
> > [  127.170832] ------------[ cut here ]------------
> > [  127.170884] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1163=
!
> > [  127.170941] Oops: Exception in kernel mode, sig: 5 [#1]

This is still happening with -rc4.

johannes

--=-8/YZDC6AaIHETmlGlt8G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJItn+MAAoJEKVg1VMiehFYsN4QAMBG4w3uJ3iN7fyhaM526WcC
UDaTa+v8QJY7Hk1IXPfBP3MBmOFyzmAuIL8bWaov+1ZmN+4u5dou4ZSZqZkR4oUR
qSzDSV71T3kR88l8ejEUJ2hVnFUEMgTjiTH7GDUQcn8ZYPbQlbFD2so3VfSkupvS
xyhG4qDg9qiRV8g0tE3Ss3TInj7qYDn66m4rZIncPqU1ljNJ+XZn+nixRWHQ+TI7
OI8IBQeTUtV5xx+ABe9iObr9GFW7OBPaKqlsbevqTWaz/K56wnAxtFqIwq5/JX6l
kGezfofFsn2DR4nAkTERCpAhsFTxfamvsvWP3q+5R1PDJVBy6WpQSCsbkhAe28Uv
PfYvfVxKp1zFaw+yPXMacaL2h71A7FlMpKK8a0gpSnNlG8G58gu0thYtWhwhs7FN
dq7k/Z6Ft9l7WKVTkPYCS6VsXm/5ASnOcl93KJRYlrKPlgEPQkdr0QZvdvXNL7VD
lNgLPKhkz3sXfmu6KICJW/qrF1uN5nzFUc53G18/Heq8zVa1YO1HoYieyAuYOS44
BOih6akyNqUBFc5AtJkJwLdBEvG/SAwNAs2t0RDP9wf2u96qgHzUx78gB7daaWCa
i76ckObUJWw+Bn+/LeTsFE2A2B47zOKxClV324bDy+NLNHdhyVtCWMCxOtWx8sFd
Y9QYlUtH/aBQw0fPlG2E
=rI99
-----END PGP SIGNATURE-----

--=-8/YZDC6AaIHETmlGlt8G--

