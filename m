Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYBYLAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 06:00:43 -0500
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203937042.13162.81.camel@johannes.berg> (sfid-20080225_105732_203616_A9BE06D8)
References: <1203676145.26341.39.camel@johannes.berg>
	 <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com>
	 <1203933096.13162.54.camel@johannes.berg>
	 <1ba2fa240802250252x753796f7ob071c12c72aec172@mail.gmail.com>
	 (sfid-20080225_105254_843501_AE739B69)  <1203937042.13162.81.camel@johannes.berg>
	 (sfid-20080225_105732_203616_A9BE06D8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TA/AncKLCQ8T8irfqi2c"
Date: Mon, 25 Feb 2008 12:00:35 +0100
Message-Id: <1203937235.13162.83.camel@johannes.berg> (sfid-20080225_110046_243803_AA76DEF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TA/AncKLCQ8T8irfqi2c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > >  > A disconnection can happen due to
> > >  > device resume or internal recoverable error. In this cases I would
> > >  > expect mac to try associate again upon such trigger.
> > >
> > >  I guess that's just missing. You can stop the queues but you can't t=
ell
> > >  mac80211 that you reset the hw.
> >=20
> > If there is no objection we will introduce some notification
> > mechanism...suggestions are welcome as well.
>=20
> I have no objection, though I'm unsure what precisely you want. What,
> for example, if you're running hostapd and your hardware resets? Can you
> keep station tables etc.?

I mean, if the hw simply resets quickly then I would expect the
association to withstand that, no?

johannes

--=-TA/AncKLCQ8T8irfqi2c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8Kf0qVg1VMiehFYAQKuTw//Wdz5QgpFXB1MgqSBMTqGJ8x9ejhskJTp
RTX5ZpWh5Yezn6nYF06IuCdMCa27cFEkifG/Vr9Kx+AdUcKj0ND2U/M1nnnSiPpL
rwdcae95x+CCHzKECzS8evT1QHnf2pt/i6hysQ9jl/2IPBMzu4l9Psmw491zAcWy
MJTa5wa33dgJHlBbWCKXA1pzsxej3eUQiq9IPl9DGl3tEGy7QKT1a13G5WEE4z5k
53YBdftb4BDPKk7AeOU+kJMsiM2V/L9JzQA5pXpycdiQPw3/slXH7zD+MF2NDGjI
LCZg9bb4o3IAOJPq975b/SD9JkFq7+i7p8QGnysEb4oEU1bQF24K7cYTB29bofsN
Ku/6lEuz8ZGwsnRd6UWl3Vo6ZdENC+/C/5j2k6LLFJIJUy3nEVv17+Z4dm94tJn5
ROt3EuCeaVxgeLuGc613L/rDRuiqocYLYFnfOxhKp7CN/NZtnk5/1lFlOlVBjxhl
bYb0auh+mun/oTW6MBp4DC/4PHqNTmQejf9CSKRN+VWROYIqmFzYLbw3xE4MyRhM
eVI/Gm3WNgYIOt2RF9qaW+vLwsXKnlgoGZ/VpwUJ1Nvaw8H5/8dfkeTKD0feoaFt
maM/NaU/2CewG0WMKxPGEWJ3icOldW/YlwrjFAytqsEpF9SEPPcPSHPlGBWMm9H5
IHeU/RyaXyU=
=VtDp
-----END PGP SIGNATURE-----

--=-TA/AncKLCQ8T8irfqi2c--

