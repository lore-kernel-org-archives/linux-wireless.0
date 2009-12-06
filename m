Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:45544 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbZLFT2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 14:28:46 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Sun, 6 Dec 2009 20:28:52 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912061945.53225.8an@praha12.net> <1260125366.3461.24.camel@johannes.local>
In-Reply-To: <1260125366.3461.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1423409.qu2SCLRpYr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912062028.52470.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1423409.qu2SCLRpYr
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 6.12.2009 19:49 Johannes Berg wrote:
> Umm, no it won't, that's only with your specific mac80211
> implementation. Try on rndis for instance.
I looked at the rndis driver, but it seems it could be configured via wirel=
ess=20
extensions only, it does not define cfg80211_ops at all, so I think it cann=
ot=20
be managed via nl80211 and I don't see your point there...

Lukas Turek

--nextPart1423409.qu2SCLRpYr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLHAX0AAoJEEBjvk/UOfYwv3UP/32bxuO1okfcheidxg2DolEK
FdphRPNbhweGliISHU7P4PA0fqfZ8bUy/7Xk2cuYs6APQnmk3WW//lk2+WbU89PY
4ErZGYCuCreKGU3ClVEMTV1f3kiCDM8E0XrIGLQsWEz+o9Pen6oQatHxIvIEHGPN
oMDpK7HqIpuwRoeh7ofjzN9pyWIIIYOfOvcXPu1rxvDWhOZgUomN7oRbk4c08DK6
TFCLfvRXLlyMxhw+/gXVGl8j6fU03W9V1iiJ7DPx0AwKHN/sYjlmEdy4sGQlZVRz
Jgn/beUrvcTGfsepPJyp9kGo2BEIjamsBLa6Tb55TXbfbLkFw2jYetyFVMJW+msV
L/nJ33Qw93i83I/Yd/ciuWN81jlqDzMqWgulM8ofySqLeBbquhSL4euB4ciFeyaS
T++zSgAc9oyHcIH+ys0HXr7WPN8ZEQlsslFlW9I/FZCZqGlqyg3fXY6HU96xqWIj
K58VpS0Fa8komeryZfZfm+q1zgcLYjoOXVeNqk7XLQufuQK/S7BVXBqB9NFiSCcJ
kTdRz4l1fIyvaZEQBSddyBCeHvzMK/A9GmTV/1mbmCR6Pb2u0+r7iJj5Xkwmjkij
YUNVfD83XWld9xwNPaHZijcw0FWfpYxiNRFZV3kDuyBhGhCY9tnPAhEMolkCvFnP
ByaZbqDxuy9CyU7lfdV0
=VfYW
-----END PGP SIGNATURE-----

--nextPart1423409.qu2SCLRpYr--
