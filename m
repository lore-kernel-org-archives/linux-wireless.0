Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXKVPly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 10:41:54 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711221605.55506.hs4233@mail.mn-solutions.de> (sfid-20071122_150536_458314_211D8F87)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221514.37906.hs4233@mail.mn-solutions.de>
	 <1195742483.4149.6.camel@johannes.berg>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 (sfid-20071122_150536_458314_211D8F87)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ta9FUBt5l66QwnvEhvvm"
Date: Thu, 22 Nov 2007 16:41:49 +0100
Message-Id: <1195746110.4149.23.camel@johannes.berg> (sfid-20071122_154157_592128_8A51A962)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ta9FUBt5l66QwnvEhvvm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

So since you felt it was necessary to attack my sanity, let me reply
once more.

> If mac80211 would have ditched wext and would be using nl80211, I=20
> wouldn't object. But it claims to be wext-compatible, but it=20
> isn't.

It is. It isn't compatible to how you expect wext to behave or how some
other driver authors wanted wext to behave with their drivers. But since
wext never specified how this should work we can rightfully claim wext
compatibility. Show documents, comments in the code, anything that backs
up your claim. The only thing you've shown so far is stuff that is just
as well within spec because spec says nothing and deviates from how we
interpret the non-existent spec.

> I'm not aware (from those 6) that behaves that way. When I just=20
> enter "iwconfig eth1 essid MUMBLEFUTZ", no key, and then look=20
> at "iwconfig eth1", then I don't see a MAC address of the AP.

I'm sure that softmac behaves the way I claimed, so bcm43xx would.

> Not "some", but "many" drivers did this, not some. I think=20
> orinoco_cs were used a lot in older days. And madwifi still=20
> get's used a lot.
>=20
> Also I have never said that anything is defined here, or please=20
> show me the sentence where I wrote this. I just wrote that=20
> implicitly a number of drivers behave the way.

Yes. But what you *are* saying that we should make that the wext
specification by requiring everybody else who wants to implement wext to
behave that way too. I'm merely questioning that based on the fact that
wext doesn't define this and it is *much* easier and nicer to implement
it the way we currently do.

> Face it or not, not everything in life is defined. Nowhere is=20
> defined how bees behave, and yet they behave in uniform,=20
> somewhat predicatable ways. So please stop this discussion about=20
> defined or not defined. mac80211 behaves out-of-the-order=20
> compared to older drivers. No matter if this behavior was=20
> formally defined or not.

It *does* matter because the only thing tools and people using the tools
can rely on is what is defined rather than "happens to work with driver
XY so it must be right"

johannes

--=-ta9FUBt5l66QwnvEhvvm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0WjPKVg1VMiehFYAQIoew//TC/KZ1CqB6udTk5mj4n68sPASovCKbhd
cgJgtteaWutoCXTmaK+Wr6429zG6dR7XVuoxqiKLQ7rCEbYJS9hqe7LUGcDG3GuQ
hcqHvdkmA8MaLqm+lfccVajw86e3a2pPiSgYvfTa7tE0/JH+txmEKL2NhFMdrUUh
zVhUmXmE8e7VJ1l/tsGaskl6Xb748udUTnJgY8aqF88+mMqSnKUSSTpZy52SKWVY
BtcFulupN1ElWlZbUbpDH6RuVWC/ds2DdlIy90R4mdFOzUifCfxMpKUNsgX2y7Ra
LLGwWsvD620iW9LTyJMHp7JKcCPGckpb2yK+uG7lPsolHvgvhmZDSvMx1kvs38rS
4C5GIQ7IyAv6+WjSkFTlxDIQ2PmNL1okQIV2JvguNo/ekEmRaGmwlfgyMCXdukqn
/kZc7lGnekXaq6YED9r0HkTiaij/HsTSzvhyTEbtMNASKYLueJqJrJAR2zIiBI4X
P3ggf3LUxgQ3yNU72V339MfAuv9hTcXshIH67mhOfTEVLo78e1wxSluWAfbCTJay
AO/iPoK8GTW1baP4NRy9eJwwUTA+vcFkO0XfbMcbZQszWWim/haBOleTjCiqaJWk
Oz8f2eHUYL+vD70dPhGedp5pPuicAcsdxQQSnMB2VB4kI57lB5CfUZYP42PUECIa
I8lU+Efn+s8=
=NNI6
-----END PGP SIGNATURE-----

--=-ta9FUBt5l66QwnvEhvvm--

