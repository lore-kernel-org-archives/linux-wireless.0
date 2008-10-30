Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbYJ3PJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:09:10 -0400
Subject: Re: [PATCHv2 0/5] mac80211/cfg80211/hwsim: Basic rate and TXQ
	params
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081030145920.233178987@localhost>
References: <20081030145920.233178987@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZLJF9dzkndKK9q9AOtep"
Date: Thu, 30 Oct 2008 16:09:06 +0100
Message-Id: <1225379346.3690.60.camel@johannes.berg> (sfid-20081030_160914_002817_FD380BEF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZLJF9dzkndKK9q9AOtep
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 16:59 +0200, Jouni Malinen wrote:
> These patches add cfg80211/nl80211 attributes for configuring basic
> rate set and TX queue parameters for AP mode. The current hostapd
> development branch has matching userspace code for using the new
> attributes. In addition, mac80211_hwsim is extended to show more
> detailed debug information on BSS and TXQ changes.
>=20
> v2 addresses the comments from Johannes and adds a patch to fix
> kernel panics in certain rmmod mac80211_hwsim cases.

Looks good to me, thanks.

johannes

--=-ZLJF9dzkndKK9q9AOtep
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCc4PAAoJEKVg1VMiehFYPAMP/3075p0ymSkwKisdSdPOxdJm
3TQN/fWGDTirll5Bciby3o2LjEO/rQjUStEoXx9gsIU+djMUwx24yX2t2NAMbKZh
naSL1IXytZTwLkCLyEsT7wc9/qGCiVAKxPmEEAGQuhnog0BNAp0bAMKiHTTimULG
yCBImI2Lv/LNrd9n7zzgNdUI2Lsa/soAMD3+RTj72yc3dYwfqJwmx+GKzAG+RN/d
kTIWTnhd1Gt81IZje1M32gDqgW1v1C3eZBe3fFKlsu5EDanHwRMzPB5CR0PNBFkW
yjnrAk0OsWIRL6QU7nsPIuqO2Ze077c2WZ0aQXC3XLppZSg+E5/sbPDikiNQo5xc
O6RN6qfsSA7f2un7op6aKgSA2oBK0hW7e+MhzYdt1IO7SF2H/YpQcKDyOdj6Unvz
NTQsIIp1OA71it4h+chBE8XoTXS0la7ebDn3oeZUEYnJxAYcUSJDYnGcUPBvnLiK
pzY4Vv19jcljghGfJmhRML+JJnkmob/pfL0/LG8/qF4k0S1jvEsStBe1XuhVngwP
GmVyzK9S+TFsa25KD4GvihkjZaiyUQWsGCsiD1LsDAju8qsDV/BLMGKc7sHmAJq3
fEiI0Gnzfqel1yOGdDHAUrSMLxzx9BayLBM3fgiETi+FzL0yu/ye8OjPDQthlKe7
OufToZuAwkVV9bosyYmx
=PRm8
-----END PGP SIGNATURE-----

--=-ZLJF9dzkndKK9q9AOtep--

