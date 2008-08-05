Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693AbYHEJNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 05:13:12 -0400
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20080804233525.GI24927@khazad-dum.debian.net>
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <1217864565.3139.17.camel@localhost.localdomain>
	 <20080804223052.GG24927@khazad-dum.debian.net>
	 <1217890611.17793.17.camel@localhost.localdomain>
	 <20080804233525.GI24927@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5fK/lWKqQUibMKlMCLKv"
Date: Tue, 05 Aug 2008 11:12:21 +0200
Message-Id: <1217927541.3603.32.camel@johannes.berg> (sfid-20080805_111315_400900_90ADDBE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5fK/lWKqQUibMKlMCLKv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 20:35 -0300, Henrique de Moraes Holschuh wrote:

> And it is already damn clear that what we currently have (rfkill always
> blocks on suspend) is not the correct way to go about it.  WHAT I want to
> know now is whether there are any drivers out there which need the curren=
t
> behaviour.

No. There are no drivers that rely on that. Seriously, all drivers
implement some form of suspend by simply turning off the hardware.
There's no reason to believe that rfkill is needed to turn off the radio
in any way when drivers except libertas turn off the hardware anyway.

johannes

--=-5fK/lWKqQUibMKlMCLKv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImBlxAAoJEKVg1VMiehFYTPcP/jBTMZrTBlYxbRbzg6dhVG8f
qbZXASyp/qu9jCUwN9N+20hAJKKELgK3tBHyVOa247XWpa2TDaCpiLIoH6mvqLjh
tb/wJrs6KGLkpUE/RBRG5y6YFUc+PG68S54RL1BAJh5SLV4+BhKa7Rp0rfNhG2Hw
HHEUFtOjORvd5cx/psk4pkhtvKUWIVu7xCXSjX2p9VfQ2MdphbMMd9aPnZ4HJ73p
GK8jFay1EvoXeCLcqDq/oUgfTK9TTwpXRihAvQkUsGkZXcEBy7f4ayZwrcP5O2q4
p+NcDOn4gFzNeOxHEz525+FMw1aLbENpzDbYS+xjj8Y1Km3FJy18/3aT4NNbAIbN
HXCqa6eDzf302xhvOSkkRArA4Zlu0/m9NYyR8n2QR3ffeHC7pxLqBTYQze3GWenY
oBF27PuHQzGXd/RdoKSfQEcg43u+fP1bYrv1umFUxVViJpmdKGKqm/tPm3TWDymC
yXU0d6Qc3MxhI1Gcd6tbHkqK3HI4dM0Fv9HZ4MZReEHI7hiZTnGz5GGORbxgHenJ
LVJRAcPz8JyqixTbyUHhB0mZAWpsGm021zV1s3mOj1zp7Nn3s76CW4cJwVJxix4S
XJe7LRRSNlu+qUbR+27M4IrW9y1wQVyvBwNo+Ot8GsUj8AUzcP2dCVbrUg7YOJgG
t0ZAWQLUof0ivP/dKydz
=igPr
-----END PGP SIGNATURE-----

--=-5fK/lWKqQUibMKlMCLKv--

