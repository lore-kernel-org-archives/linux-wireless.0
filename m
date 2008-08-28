Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYH1MSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:18:25 -0400
Subject: Re: iwl5000 oopses (was: iwl5000 oopses with Linus's tree)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240808280439m3524d17cm63deebdfc0d5b9dd@mail.gmail.com> (sfid-20080828_133955_256852_8C36B618)
References: <1217937364.3603.37.camel@johannes.berg>
	 <1217938927.3603.40.camel@johannes.berg>
	 <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com>
	 <1219919760.8434.5.camel@johannes.berg>
	 <1ba2fa240808280439m3524d17cm63deebdfc0d5b9dd@mail.gmail.com>
	 (sfid-20080828_133955_256852_8C36B618)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JxiZiufdnGGYhO+fC4QW"
Date: Thu, 28 Aug 2008 14:17:39 +0200
Message-Id: <1219925859.25321.10.camel@johannes.berg> (sfid-20080828_141829_729449_70C81582)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JxiZiufdnGGYhO+fC4QW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-28 at 14:39 +0300, Tomas Winkler wrote:
> On Thu, Aug 28, 2008 at 1:36 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2008-08-05 at 18:20 +0300, Tomas Winkler wrote:
> >> On Tue, Aug 5, 2008 at 3:22 PM, Johannes Berg <johannes@sipsolutions.n=
et> wrote:
> >> >
> >> >> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty
> >
> >> > [  126.826663] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Li=
nux, 1.3.27kds
> >> > [  126.826947] iwlagn: Copyright(c) 2003-2008 Intel Corporation
> >> > [  126.828369] iwlagn: Detected Intel Wireless WiFi Link 5350AGN REV=
=3D0x24
> >> > [  126.848680] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a cha=
nnels
> >> > [  127.014564] firmware: requesting iwlwifi-5000-1.ucode
> >> > [  127.170640] iwlagn: Error wrong command queue 43 command id 0x6B
> >> > [  127.170832] ------------[ cut here ]------------
> >> > [  127.170884] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1=
163!
> >> > [  127.170941] Oops: Exception in kernel mode, sig: 5 [#1]
> >
> > This is still happening with -rc4.
>=20
> I know, at least one regression.

Well, I guess for me the addition of the 5000 series code to the kernel
is the regression, without it I can use the machine just fine, just have
no wireless ;)

johannes

--=-JxiZiufdnGGYhO+fC4QW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJItpdgAAoJEKVg1VMiehFYW00P/1fkmc2A3XbWcocg+lzz6ZuX
HplEJr455bLAgIIVriyE8rZUJAK5Ldxn7XUerBuwe6IQLwFWCNrmdy2Yo22Syk9y
7Iw4UIKkUOwVptZWoOQwiyGxUOSULxwa7lGdwvq8GLCwDkjRhDjkZX6Um6DHouAp
TwNxAXb6tnjSRrMG/Z3gBjghGoqINIzLEtbU9SgQPweCVLt491E5joFB79m6zynW
jnyg2J/icBO3d6dMWXBAl26Z2rku3bJlFcQgRtPJkhL2l6GQWV6UCwgRxaHwiziV
looLm/lUl5QA79DKjmKX6dqPloyivCsUXOEiUWt8hCIAn17aHwhFFEuiQy/zIcdr
D8trb5mW+g2qgFcKN0u2AiecGlsz6UhcwPcTuEkb8SjNjVAhTrSfw7zfQza9GHpr
6r6PDj6LmQamAqKZgDVe2xSUD9zY0qHrcRtID5HDGDrnUzpW4lh+SMQoEn/Pxxpr
qWOgHY324QzjtQ71mclMfzZGCI7RUyQALdUPbCea8hHovxp2iA88CXr3yTqtPCHS
H5ph6YC9oZHFMVt3pBEbM0pCMV0G6sDB1zUem9wDKUfgB5cb+s60VgLLAWjszLnu
apv6ZpC8xdcFab4bXaOyS4Vv3EjbCHquBMXR+obDnzvfkSzHitLXLbhf4sKGulOj
+7T9cyxjCYNMDbOUXpWG
=oQBy
-----END PGP SIGNATURE-----

--=-JxiZiufdnGGYhO+fC4QW--

