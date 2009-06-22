Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbZFVLYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 07:24:24 -0400
Subject: Re: [PATCH 3/3] ath9k: serialize ath9k_ps_{wakeup,restore} calls
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A3E8EE0.6040609@openwrt.org>
References: <1245599268-2441-1-git-send-email-juhosg@openwrt.org>
	 <1245599268-2441-3-git-send-email-juhosg@openwrt.org>
	 <4A3E8EE0.6040609@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WJ3RRO90msmd5tqS7XvW"
Date: Mon, 22 Jun 2009 13:23:41 +0200
Message-Id: <1245669821.4180.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WJ3RRO90msmd5tqS7XvW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-21 at 21:49 +0200, Gabor Juhos wrote:

> Please wait with these 3 patches, I got this while the interface is in Ma=
ster mode:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.30 #37
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (&local->sta_lock){..-...}, at: [<c0252f3c>] ieee80211_beacon_get+0x148/=
0x518 [mac80211]
> but this lock took another, SOFTIRQ-unsafe lock in the past:
>  (todo_lock){+.+...}

I don't think this is related to your patches, I think I got the same
error with hwsim. I'll look into it, but it might take a bit longer.

johannes

--=-WJ3RRO90msmd5tqS7XvW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKP2m4AAoJEODzc/N7+QmaHbMQALaW/LbVvvKnHlDnAjjik/j8
OwIJR8PdhYIhcoG1nXBlYaGpv7Hs5E9BVSz76H2VS1cCkZO1fuiqtNfcQ/+R/OVY
9cIkMvJB56RdZw4Fjuvj8COjne4Rq7GfEnlrKiPImMKnJR+TGVt5xDt8IyYp8thl
meKDtQ3aC1QduWy93Z610LZty/N8hdzo4ocQv6aXIj+Jr4oHHiNawKCv302ragdG
50dZiEyKFGYmi3V6xXt1OlPhPRd7cSGqQLgoIqkIusA2/iP2AHkQK0ib/OR38iZb
857DwaBgsKwdeP9q+8zbMK9Vo8CUIWIpBa2POKtIlJ38RKj7kNlCQXuEypTQkEtd
L0GukTalgqadx//TeIN2Ngl5auKxqz1ZOINxfAKmgvkppq0jouCnX1EPYRKlLTZP
nxfuxMYUvkur9sCdTx4gGxTPBFhBrHAdeUV0GL9+L/JqX5t0rGJuX4lRRXZqpEGW
VFuZfvC3LXBjVPrhss2PGrL7HC+ZWmFFZuaHeiFywQT5iK2eutChAT8LvgXfaGb6
aW2dPnnNlWKSP+Tjk0bDI3+KXW5smlrZU+K9NmSeekUzMtEPgeW5/vZqxrgLd0r8
l4x3Aoxnx3Gwz5YqgFvgOeLw2ciaMQjaSqcOiJTL8gzry5f0YDL8RzmOs9uS0ADe
lf1wPzpN6EcotBQ0Bo8J
=aPW2
-----END PGP SIGNATURE-----

--=-WJ3RRO90msmd5tqS7XvW--

