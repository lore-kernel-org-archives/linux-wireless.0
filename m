Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab0BOJ3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:29:40 -0500
Subject: Re: [PATCH 2/2] mac80211: Improved IBSS merges even if BSSID is
 the same
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1266190435-2355-2-git-send-email-benoit.papillault@free.fr>
References: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
	 <1266190435-2355-2-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SvN1DLum0bRAcR37hL5x"
Date: Mon, 15 Feb 2010 10:29:38 +0100
Message-ID: <1266226178.6450.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SvN1DLum0bRAcR37hL5x
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

The latter (not implemented) case doesn't actually. I don't just want
you to edit the changelog based on my thoughts, I would prefer if you
actually looked at the code to get your changelog.

johannes

--=-SvN1DLum0bRAcR37hL5x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRP+AAoJEODzc/N7+Qma1Y8QALxbdnBu48EtmtLN55tM2IHZ
sY2dastgPLU0TXphYH+CVJ65TsQHSY/jfA26apFGU8jKbz73hVmJQotT52Wxvi1i
EZSM1RAlSAQu5ryutkes66mAwXDcUetWxpke3D68S/uJZas2Rcr9XUzCpdx7WfJU
IsqnsZoMK8APpkgP4mhBOf2SV6qQrwZ2KahAdQhQN2icWShiO+xr1yCo2Ae+Qv9M
V/nxEArIrZ4YdnJ5OX3oZmYNLxl3DhFgABii8kf/XH9VqB5ktslovrhfr0fY4wwW
6MP3prQoanYTQeji//2bnAEuNPFO/t2/Nm6mq1k2f5LcqVvKjcdfFpslaL6myXMV
AjhUvMUuaiqz48xwVeQZ/yzFaOeKFKLhnhxjb+c31RVuQMuAH+SSg90yeLzvnx6o
w6w1HlawMjD1evqjJDgvMLc98ZmRn9PUTR5oS6IwwyK5bShMuOFZld/PM2RgObVK
Ng2qmxqFDgT8gXmLTF/dfI/IElR34stW2ZJveNDm/4zKgdltRhPZsPcBErMWX8qZ
axRMPBnQwl6T5D+Nwl/RKYkMWpSA76qqxG19G/8JPH8yE8PdexxIVIdGf3Xx25K/
76NC5UCJD3HY8m/eMGe7/N+1mA6+ZBgEytCsY9kg/vC6Psa6VUQtRtki0Jg0gWmk
TmxQPgSMFFpw/B+LRrmL
=YUoN
-----END PGP SIGNATURE-----

--=-SvN1DLum0bRAcR37hL5x--

