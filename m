Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZFIONW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 10:13:22 -0400
Subject: Re: [PATCH] mac80211: Fix the way ADDBA request count being
 modified
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090609140847.GA4459@vasanth-laptop>
References: <1244536906-22335-1-git-send-email-vasanth@atheros.com>
	 <1244556118.4672.10.camel@johannes.local>
	 <20090609140847.GA4459@vasanth-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GYMgVlbplz7RjkaDulQU"
Date: Tue, 09 Jun 2009 16:12:48 +0200
Message-Id: <1244556768.4672.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GYMgVlbplz7RjkaDulQU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 19:38 +0530, Vasanthakumar Thiagarajan wrote:

> I have seen this happening with most of the 11n APs around when AMPDU
> is disabled (configured to deny addba) on them.

Makes sense, I don't think I ever had an AP that supported that specific
setting (rather than simply disabling all of 11n). Anyway, thanks for
the testing and the fix.

johannes

--=-GYMgVlbplz7RjkaDulQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLm3dAAoJEODzc/N7+Qma+ZIP/2MmsTUHISC3/sq9IJqqjCcj
hf7pduTTkRrn+0bX+DRtDg+KJJNEAI+fXCx+vvtd87c0nIRideZbkuWyB/TzUqli
BfNrutZPDEw7XbWKz7HSrbYr/YWbhaQe6Inr43cLJM8MqqDicpTpoTpoxMs/z4cd
ODkB3ZP/UAnyWYAbqAt+110z8irlajPJ01DURLCSk38mgA8OicYtRdupfZYhZM78
p9IDzWL0jh+sAt6eeWABAIOHe2F9w821IAy8FdIFk1gzbV6K5EcdSpKIYPjECf+f
UbEcpW3YZMtmjjlAa+h9OBIG5ILXHfY2UP1RedABBcLAlRHkS0V6iT3lkUCjkaoi
w+DFg8RNQwGoBesrOac0YehUZRJUVExnsW95rHbDPTedq7CV+YP6W8zWBvhmG7vT
5/qI//07GXi5K3PW1t2jSAaaD18DVRMAp5ufIjE4w1uf7dlebc03dQVLvM106nDj
3r5ynnXths3KpqVvrzT/Wxh/nJwcChIJs/GGuhUODG8ggFOjEGU7QWv1Phrub2Ka
tyDzxBoLBRMtp2uXJpwYS/YzoY8tgnva+BFV2JSlOCp5Lf+NFDvEtR8/wI0uWInQ
1J1LpYm2sbIiO1VZyWhwbP853L6e59K5RdPQonyzQ0QSoPDYkI7jtukUnLhZ7zQp
FcQnjg2DD8Zx53gMRgpg
=ODYZ
-----END PGP SIGNATURE-----

--=-GYMgVlbplz7RjkaDulQU--

