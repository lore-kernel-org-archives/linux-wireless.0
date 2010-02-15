Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0BOJ22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:28:28 -0500
Subject: Re: [PATCH 2/2] mac80211: Improved IBSS merges even if BSSID is
 the same
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190435-2355-2-git-send-email-benoit.papillault@free.fr>
References: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
	 <1266190435-2355-2-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-//vxgzOYwSdigznd9Zla"
Date: Mon, 15 Feb 2010 10:28:26 +0100
Message-ID: <1266226106.6052.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-//vxgzOYwSdigznd9Zla
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 00:33 +0100, Benoit Papillault wrote:
> According to IEEE 802.11, we should merge even if the BSSID from the
> received beacon is the same as our since merge can update more things
> that BSSID itself.
>=20
> This is specifically true for ath9k where the merge updates TBTT
> timers
> as a side effect and this is indeed needed if the TSF has been updated
> (if TSF is updated, we need to update TBTT timers as well).
>=20
> However, it could cause continuous merges if the RX timestamp or
> drv_get_tsf() is not accurate or not implemented.

It can't actually. Please do your own research on things like that
before posting a patch :)

johannes

--=-//vxgzOYwSdigznd9Zla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRO2AAoJEODzc/N7+QmaxZIQAM5Lcd2Uf2+lW7pEiXnIV4nL
7Bd2cMx6iqQ/pgqrYkfUX+Y+ntCYTG+UuhBC4Do/NOxKjlhtbvcFstZoqLV5d7J2
NxkHVOnX3tN7HaEvblqIrlj0Nal2qg0HAKZ7YRalf9yLyLPOTG1JYGmNOd/yG4Z0
LJYYh6L+n6CWVxvmMx6jhPYOU+UTPrM40fGKXwKCDG6B/N9Ar3IlgQ7Ifo6IwzuT
xK3Tys5r2B4u4HODCPwfjbP3V/4FmZpAFqMJzH+nLAC5COppHyBgkymm5qrVf9xZ
5Xa12JDrgf77EnwYAOEqxnO8yP+abh6XNNmNhdXwZlGcgQpX2VbPeDFsOtiqIqlk
jxHoVjyd40Nd4aCQEK6dGF9Z5r8R0V6GnEpqX0rvUW5NfVFYikXt6PzvZAqwXt5v
dnIKqjfY65AYltvi10uLTdkdxgG/2kkWVX8PwZImPBzvAP/qt8TvgNUiEPkdgDtw
zcZa+Znczh0AR1etCgVQCE0H8cktCkfziNqfhZ25KpBdYz9BC3i6FD6w3Jp2bvbg
3baQqZicJ4mOHoWvVv1QEvxyQsXg4uK8XCOH5As/LV4ReXyl2zR4fr5OXq/ihnFP
PmeyTj9JnvmXf6v3XZ0zD+J2qBjK7b+2uYt3GojOBNI5bEZsPWpyc27eCLWJqlck
jeGaaeQIQ7TXV1u0iZFK
=UN8z
-----END PGP SIGNATURE-----

--=-//vxgzOYwSdigznd9Zla--

