Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYFDUQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 16:16:10 -0400
Subject: Re: Regression (?) with wireless-testing and mainline 2.6.26-rcX
	kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4846F6DE.4080009@lwfinger.net>
References: <4846EB9D.1080303@lwfinger.net>
	 <1212607636.14371.46.camel@johannes.berg>  <4846F6DE.4080009@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fY+d0W9wuzogJ6rP5ESQ"
Date: Wed, 04 Jun 2008 22:15:26 +0200
Message-Id: <1212610526.14371.48.camel@johannes.berg> (sfid-20080604_221615_127174_FBA2B445)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fY+d0W9wuzogJ6rP5ESQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Interesting. Doesn't your AP support short preambles? That'd be the onl=
y
> > reason for anything going wrong here to actually break your connection.
> > hmm.
>=20
> My AP works with short preambles. When this situation occurs, whatever=20
> happens causes a switch from short to long. The change in the preamble is=
=20
> likely a symptom of whatever is causing the breakage.

Hmm, ok. Not sure, maybe a driver problem?

> >> Do you have any suggestions on what should be logged in=20
> >> ieee80211_handle_protect_preamb or any other mac80211 routine so that =
I can=20
> >> isolate the problem? I use NM to control the connection and authentica=
tion to=20
> >> a WPA-PSK TKIP network.
> >=20
> > Well I guess you should log what state it changes to (maybe even in b43=
)
> > and at the same time monitor with say wireshark on a monitor interface
> > to see what the AP is announcing. Not sure really, I have a hard time
> > imagining this being the problem.
>=20
> I'll try for a stack dump when the short =3D> long transition occurs. Per=
haps=20
> that will suggest something to dump. I'll also set up a monitor interface=
.=20
> Unfortunately, it is an unlikely event, but I have a lot of disk space.

You can filter and save only probe responses and beacons from that
particular AP.

johannes

--=-fY+d0W9wuzogJ6rP5ESQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEb33KVg1VMiehFYAQL76w/7BZD+swiaPWwD7qLchdQdayetA7qQSFdZ
gp2oRHH7y6xLHPgLuTUtGpNw1X4pQBW02/s1THcha9vvKVeuw/iwXCxH8j20gjEu
ofataUtOx5VKXv5ELriJ8lBKa1rHp8+WbcZq0B1W80MlvG5hKRZq5xa216NpqqCm
ZBSG4t8wEMpK66gCABc7a18dGwg1tepsUc/1M3ZETvNYzBliUw2QEf3GyxT7h4Co
ueBQ5+RiqzxxQFkM2zjSZZ1vstCPL9nU6vJacIO+CpR+StQXoyezd5J+pGdl3hIh
9btwIFho+WrnMnGlha8HM+4ONjbrVtFIXi6DHp38AC2pnyugM4mWc9tVMxRzx46p
7viYxjebTdD2fV0FTHIf3y45kmC25jt/m6LjKk1kEpWQcb2otW45uYoT+6s+tFAA
j2aSVoNKRrnvgPAusP3o60vqGfpN+q4TQ3YsRx23fcpYOriLFhdc4uNsrt3geIkN
oFuutEXZnE1d4iezPKhRNPPk987w2A3Y+cptpeTYi1AnTyPgV0eVOB1ihVk6JOy4
7duKFNbpi1wwLMiw2AWYuU/DT6nflFfY765rtpzqkFpcgJzRCXzjuuKkEU1ggQqb
c8tPOGXaQVBknM1gMTMb/FWnMiVxIBf+BMSb147BJ0vsSIm0R8DlVDMxHyp9Ibkk
07IHziHubMM=
=SbbD
-----END PGP SIGNATURE-----

--=-fY+d0W9wuzogJ6rP5ESQ--

