Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYFZS2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:28:38 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Michael Buesch <mb@bu3sch.de>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	cs010101@gmail.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1214504482.3783.20.camel@johannes.berg> (sfid-20080626_202226_010344_A79E9A49)
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <200806261821.31643.mb@bu3sch.de> <1214498071.30722.22.camel@dv>
	 <200806261846.17962.mb@bu3sch.de>  <1214501000.3783.0.camel@johannes.berg>
	 <1214503403.18039.6.camel@dv>  <1214503739.3783.14.camel@johannes.berg>
	 <1214504288.18039.12.camel@dv>  <1214504482.3783.20.camel@johannes.berg>
	 (sfid-20080626_202226_010344_A79E9A49)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OEobATuQECW30eChIxh1"
Date: Thu, 26 Jun 2008 20:27:54 +0200
Message-Id: <1214504874.3783.25.camel@johannes.berg> (sfid-20080626_202842_550670_4D34CAEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OEobATuQECW30eChIxh1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > The fact that we cannot limit the rate like that that?
> >=20
> > That shouldn't be hard to implement.
>=20
> Go ahead and post patches then.

Mind you, I'm thinking of patches that actually address hostapd's
incapability of setting rates to use/basic rates etc. in the kernel, not
a two-line workaround that only enables 1mbit for AP mode interfaces.

johannes

--=-OEobATuQECW30eChIxh1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY9+nAAoJEKVg1VMiehFYMR8QAI0u1ibFlMyZ8vn8BdGQlU/9
1LvxAtF8H35xUtnrIJYPM0cshHH6u+CpTSrNoWsLFYKR1b6MHLwYTTKFHybjsMF1
etTHEmSrYb1u0W6qNkg/XWmNX9HRKXjQ4g69y5DDPKHoyL1wXuWsyt/J1ioD7km/
wDvj0FV7fI/6ew6Dq+67PQzCoIy8YdIOhmICZRP3PJGcArQ9i15RbOfQr5iP4T3S
0hgYod9uS4AGQ3Ix9S75M7fE8AwYcnBTspfPkbWhQZBDYFKINGxVcpD5znGiu9Xq
eq5MmBCZVSTP8UEerEyzN7WDaqfjHl+7CtDdAFgzbIjK1XXUyY+O8B9Le/7zMUdJ
9x8O3R5EGqAgNFshGGKf74Lpd5RZAAIABbkxin0riUp//lKyx8do2mmFeoDb5Aoo
P/4folpNuRkfAD0MRE8D90S4IGAGbb9LJJzUwCQGb6sRCi9JDD+PFqRkR5pN6i/f
d0hcpN6QPR/3i+F1d0M13AYBAzIbUvcq/okaoWJMkjypvGtRA/t3GTAYrkXBFT7c
tMfWnuQ6AVqknIOczB2DSKE0WlxS7u+U2CnSfUsiUr2jmpzovAxRuqYRKrdxos1o
uO7bA4qMvts/JdIE+tZuj1qeKM/Fjy7mE5Og7RWGHCk20EAqrmoCuxJiK0+s1mg1
pYWUAHGuSou4INo7F1GM
=u6SD
-----END PGP SIGNATURE-----

--=-OEobATuQECW30eChIxh1--

