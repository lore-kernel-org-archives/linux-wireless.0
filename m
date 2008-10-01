Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYJAJZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 05:25:08 -0400
Subject: Re: [PATCH 0/5] wireless: single escape_essid implementation and
	related cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1222827352-1978-1-git-send-email-linville@tuxdriver.com> (sfid-20081001_042555_515889_ED71740D)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 <1222827352-1978-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20081001_042555_515889_ED71740D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ecAVTEWhaV7uPSSjwVQ+"
Date: Wed, 01 Oct 2008 11:25:00 +0200
Message-Id: <1222853101.7064.66.camel@johannes.berg> (sfid-20081001_112519_297698_3EE2B857)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ecAVTEWhaV7uPSSjwVQ+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 22:15 -0400, John W. Linville wrote:
> This is a repost of my escape_essid consolidation.  Also included are
> some suggested changes from the original post and a few cleanups.  There
> is still plenty to be done -- of course, this isn't really high priority
> work either...
>=20
> [PATCH 1/5] wireless: consolidate on a single escape_essid implementation
> [PATCH 2/5] wireless: remove NETWORK_EMPTY_ESSID flag
> [PATCH 3/5] wireless: escape_ssid should handle non-printables
> [PATCH 4/5] wireless: use individual buffers for printing ssid values
> [PATCH 5/5] wireless: avoid some net/ieee80211.h vs. linux/ieee80211.h co=
nflicts
>=20
> Comments welcome!

Looks good to me, thanks!

johannes

--=-ecAVTEWhaV7uPSSjwVQ+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI40HpAAoJEKVg1VMiehFYAnUP/R5sYxJLEIs6VURpv1Q9ioOe
sY7NJCv8WfbfrqvsZYoJRzhrQgzt508nC91d/AAate8kY5qxYfkZeQv97rAaTvbu
Zd49OYNoPPRyQJORZgK4lVVfeWHorbS7Uye1dvrmBhZPaln0W0kyNJPIuY0bxSX9
UxIL8BvgyR0rySGowBXS1oB7XIak/yng4k/VMSxqqPa3YHRYEefed59D/8mFwMJE
s7E1Oc8jf6P2WnwX63voxe2bA9D4ITk0M19xDKmoZtH6Yg8q4S9E//nQATsd8HZT
Sl0BPvBbJPIxjt63gryHinlnObeuLHa8Eypl9Azz1TE/1GwYqbkJmjnvkTd+BoAN
D5A13/ML6QZjQhp2YHwL4TSKgx9s3wVX4KR5mBUTQskZn+W4vdPv1mf0JnMQbxvp
Rhdsdmo4pm3J2XceMATgTvgefxT1d6hF+WaSgD9eXPXWjj2xLJpxBEs+8XGKQGM7
bYJnQQq6X75r/+DvRDVgTztS91iBo6x5cHmL4FQok4au/UrIwn0kxm0jBi/ZPuRe
pHYxjbUffxw0tDN3hq6syvRju7KqWsLmmDY5lB+Q2khYGeBcvBMulEqIt423dPiS
EEcb9zXNSfrWtWgRgwAqCUSioXQ6DOyuTicwfF2+r+Ex9Ex/O57FKHTuaj+THCkC
VvSrN7y9hW/49acHNvq5
=SH1/
-----END PGP SIGNATURE-----

--=-ecAVTEWhaV7uPSSjwVQ+--

