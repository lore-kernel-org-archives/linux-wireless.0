Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYEMKSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 06:18:42 -0400
Subject: Re: dynamic wep with mulitple keys
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Volker Braun <vbraun@physics.upenn.edu>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <f6ca9fed0805130313j62857b77iad18ecbba58f6b1b@mail.gmail.com> (sfid-20080513_121323_057415_125F3AD4)
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <8704f27d0805060514i59db36f0t9801fab7543b8655@mail.gmail.com>
	 <f6ca9fed0805120447wf6c1c38mea24ba587dc834d4@mail.gmail.com>
	 <1ba2fa240805120507r2914d23dt6826a732730fea49@mail.gmail.com>
	 <f6ca9fed0805120510yec6ba9fge41c46d2d01c236a@mail.gmail.com>
	 <1ba2fa240805120522m26904f72l45941b1beb411e60@mail.gmail.com>
	 <f6ca9fed0805120538k75a953acrc1cd251efe9bbe1b@mail.gmail.com>
	 <1210670668.3646.56.camel@johannes.berg>
	 <f6ca9fed0805130244x648325a3k2ae7b77fa610ca6d@mail.gmail.com>
	 <1210673228.3646.60.camel@johannes.berg>
	 <f6ca9fed0805130313j62857b77iad18ecbba58f6b1b@mail.gmail.com>
	 (sfid-20080513_121323_057415_125F3AD4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KbwmT9b4wIMDRLFvpw9b"
Date: Tue, 13 May 2008 12:18:28 +0200
Message-Id: <1210673908.3646.64.camel@johannes.berg> (sfid-20080513_121859_307830_BFD1FA5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KbwmT9b4wIMDRLFvpw9b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  I haven't got a clue. Are those identical networks?
>=20
> Judging from the settings yes. The only difference is that he is using
> PAP and I use MSCHAPv2 for phase 2. But this shouldn't make any
> difference.
> I don't know which kind of information I should provide to diagnose
> this ... wpa_supplicant output?

network capture, wpa_suppplicant output with lots of debugging and
kernel logs, but those might not be verbose enough, some printks in
wext.c's encryption handlers would be good too.

johannes

--=-KbwmT9b4wIMDRLFvpw9b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClq86Vg1VMiehFYAQIZlQ//fj1njlpnoDin23y4P/yEr+OiksYKFk9O
xObDrrlHQrUFVCGvjYssVkmMKumt7WxYY7iiZIrV7F6m/L6c1xJd+B6Pdqi+doho
36MR16LnVIf9uORaAsThRQPFj36i2jMMzLUFEz+Kvk8wGFL2hmWxWIdn7JqEBK+m
VEl/VlFfRMuXvbodp/DOEq75704gogztWSSf5tVFKtwW+SboCoY+mxI4OGmIZz79
JYyL2c6BnqAWrNCjKAuHM9gmo4tSACGdOwznJsy+3vcTo/nDjwnk3VaOF+dhdTt7
g0Yc20RyQGnF+NGRSbdewvJ/IUv4yvoZYzZ1a8O2oPi4yCz+6Uvv97okICudzWef
3P1+RCBuMzlAKfnb005qLJaLQoLX6skFGN0pM6x4KzZXrDSmHeW8d2RZ49Q+IqKC
44WYrv/qwAtsrx8bm1BSF32WOTN70XQhk7IpW77CMpZCtFQy31pwM9WoV44Vw3ln
+8eIA7AZBEQMtbHWQgxStChYy8WGHKrjxF4xzT2LXIO7wDbZco2I4YlGh/Mt+YDc
CKsP4P8M33fpEo1aGMW9XzUthL/QRVc0fpHzeI6ZiOEfuIoSuuCe9PgT2OvBTPj1
3MczEIjjeQIZ6OZZbjoUH+DGDTXfbYXkA/s0H8MZuEpYRxXtyJuum/DlEx3Y3jyW
kbPvbZ+KXdo=
=iEau
-----END PGP SIGNATURE-----

--=-KbwmT9b4wIMDRLFvpw9b--

