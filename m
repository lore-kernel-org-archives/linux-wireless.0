Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbZBHRwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 12:52:09 -0500
Subject: Re: generic ieee80211_sta_commit()?
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090208174519.109630@gmx.net> (sfid-20090208_184550_819004_7F4674B5)
References: <20090207233507.67590@gmx.net>
	 (sfid-20090208_003539_503598_424F18AB) <1234089364.4175.113.camel@johannes.local>
	 <20090208174519.109630@gmx.net> (sfid-20090208_184550_819004_7F4674B5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GuUQMhZlwNiRBS1vwdVb"
Date: Sun, 08 Feb 2009 18:52:04 +0100
Message-Id: <1234115524.4175.173.camel@johannes.local> (sfid-20090208_185212_926376_529D9708)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GuUQMhZlwNiRBS1vwdVb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-08 at 18:45 +0100, Alina Friedrichsen wrote:

> > What if you set the SSID again? I'd think that would help?
>=20
> Yes it only works again if you do so.

Ok.

> > That could make sense, not exactly sure at this point. I'm also still
> > wondering about the other issue with turning _off_ IBSS, with essid off
> > or so, see my other mail.
>=20
> What mail do you mean?

Subject: turning off IBSS (with wext)

> > Sounds reasonable, if it fixes a bug.
>=20
> I think it's a clean-up, too.
>=20
> > I'd have to see the patch, I
> > guess. I'd like to also do assoc/IBSS stuff in cfg80211 at some point
> > soonish.
>=20
> How do you mean it?

Well, I want to push configuration for bss/ibss into cfg80211.

johannes

--=-GuUQMhZlwNiRBS1vwdVb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjxvBAAoJEKVg1VMiehFYh7UP/RohetRfsjp4xWaEiS6QlJSL
X2Uhq23M3lzVixjnYxGchRFy/StgszliSPM7/9ebNDtsDqoyfRTHW2E+zFGOZC5s
+v6OJNIrFykefT9u+pBniSaz8pIvGYMXwmIgXgVwgwSuIT/M3MJOSXJ+pO0fDb2D
tBPizmJJoCo8BKhPnpdlR+XBd73NhflxAr6KXRcMtJIp2hTMwlzpnGEQF8SS3Opj
VuRkgi0dJAQzyUlTnWivuekTLXitosFal868vZctaXdw6gQjgjBqZzD+n43B7uVS
0BnzLPvhlT/r53CU3nzEIG59wIyz5BzZLGC75RDoxLbSm4+e6GEpN0qY5uxNTv3U
OokIKeMF1NIvTdYWIhlW+gUkNhZ+D9moa5MXnTkf63Z01IH/9ITCgyGWsIcBSAjD
f8XwCrEOEPizP/Y40q9vPeozuAT8TOFRiww8Ee6MxqoHlrAv6RQuj2BscvGJuGsQ
vBfCf4lUZj3xO27QsoARMARskLhlCA+fNZDFqliDGuHrPBAfizxXGXOX1BqAiB9Y
bsPjYkXUKXeKc7tkL2pC6grV3KL+5C9p5Ia4uDTp+lWwj5dzhJZ8COUKwvWkdBsG
HCiZOogwBBNLLF7a5W53VWTCZyDE2HPdC5RQjf65n9NnXKI+GEa0VqkjjCaAUN77
SL34cFiIlpBpb4jolwNk
=Mao/
-----END PGP SIGNATURE-----

--=-GuUQMhZlwNiRBS1vwdVb--

