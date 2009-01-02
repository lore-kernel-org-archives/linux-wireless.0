Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbZABO2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 09:28:31 -0500
Subject: Re: mac80211 (ath9k, ath5k, etc.) set fixed BSSID + channel Patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: berlin@berlin.freifunk.net, linux-wireless@vger.kernel.org
In-Reply-To: <20090101224144.232020@gmx.net> (sfid-20090101_234215_262569_45D2D4DC)
References: <20081230025651.6500@gmx.net>
	 (sfid-20081230_035657_768921_742B8565) <1230633565.3850.7.camel@johannes>
	 <20081230223611.163110@gmx.net>
	 (sfid-20081230_233642_601178_E4AB42EE) <1230676811.3850.22.camel@johannes>
	 <20081230230751.163100@gmx.net>  <20090101224144.232020@gmx.net>
	 (sfid-20090101_234215_262569_45D2D4DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-anhLhQVASuO4GCPiwHRG"
Date: Fri, 02 Jan 2009 15:29:06 +0100
Message-Id: <1230906546.3586.5.camel@johannes> (sfid-20090102_152837_070890_981495F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-anhLhQVASuO4GCPiwHRG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[dropping openwrt list, it ignores non-subscribers anyway]

On Thu, 2009-01-01 at 23:41 +0100, Alina Friedrichsen wrote:
> Hello,
>=20
> here is a new version of this patch, that fixes a bug that manual
> channel setting in the ad-hoc (IBSS) mode doesn't work properly, too.
>=20
> It would nice, if it can be committed, before it's out of sync.

You need to provide a proper changelog that explains the changes, a
proper subject (don't mention any drivers) and a signed-off-by, see
http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
please.

johannes

--=-anhLhQVASuO4GCPiwHRG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJXiSwAAoJEKVg1VMiehFYE28QAKPVyX04YthnGnBOPw2QHnwq
m+Eqa99YktkRzhS43pTMKzMI784SrFhFtkxQGUCwIkbA6Vtn5qdcnO8OJ624C2nZ
L4EvxUuvDo/dWOXY4iP4urXdfegAeB+9asySAtQh794vPPLFDuqh71rWffQ9IEOR
cCWIihSf4shFeGB7YhqJvMxSRpY7Tw/i3nbE3Ym3vGhmxoisotc3mrFpGdCXed0d
smzt7rNd60c6mnWwp9yEfbm162pwT++M84zYqE9OkmgGUw3RuGBbN2BMJyEADxSV
sg0dQqc3iJGN7gFddUaY6ReJflHACIOshxK1rbdZeUArFNNf56LMPL2JdLzrHuZV
ATuwUyCAhog4vjg4zqFRLsPBgg221Og7z2pldyfa+DU9QtEJEpHyS/KKJ4CgPZ5e
4C3kOoNkBcJJ5Jv2YR5276SjVN045rqrBZtVIvufPBC0D/NbB/m/j0bx/CwMRFcv
b1swcbe/teHl0k4h5q2JR93K/D5OFsEeheZ6ZYsLSJB4PIMJX89apv9YcIV8O4GN
/CWE0NDfKRG82K7zFWEtrQBlmEIjS5Gul1s6F7qVa7pqLIRWZWDdf6P8SInKdsm0
Qz3ToXmFYnQbHhQmPEyYG5MI3aLm3DtiDJH8shCXKDPQQ+i0rbiBz35kRj2L/pWo
LwfwZKu2DjezZoB8bYD6
=PzuC
-----END PGP SIGNATURE-----

--=-anhLhQVASuO4GCPiwHRG--

