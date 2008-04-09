Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbYDINmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 09:42:36 -0400
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Alejandro Grijalba <sud@latinsud.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <200804081025.39645.mb@bu3sch.de> (sfid-20080408_092609_909502_698A80A4)
References: <47FAB829.9010304@latinsud.com>
	 <200804081025.39645.mb@bu3sch.de> (sfid-20080408_092609_909502_698A80A4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VnkK0pVA9IJC1y4A7T17"
Date: Wed, 09 Apr 2008 10:00:37 +0200
Message-Id: <1207728037.7442.7.camel@johannes.berg> (sfid-20080409_144240_410977_558E1405)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VnkK0pVA9IJC1y4A7T17
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This does not work, since we use injection for other types of frames. For=
 example
> management frames from hostapd. We don't want (and can't) make hostapd ke=
ep track of
> sequence numbers.
> You'll have to contact radiotap people and add a flag for this. This woul=
d also
> solve the hardware counter problem then.

If hardware is capable of not overriding sequence numbers. I expect much
hardware to just always insert them.

Wasn't the original goal to control fragmentation rather than sequence
numbers? That could possibly be done with fewer problems.

johannes

--=-VnkK0pVA9IJC1y4A7T17
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/x3pKVg1VMiehFYAQLAng/9GhWI6doqjy7ArVyubi0uP87ywdcH5PpD
ibU2nS2XnwSdizjthmBYdiTaJ2SscwO0ReZVuRoWVafjAu0wsqjsN5zDlAi3i9qC
7Ra6ZnP4IVEdEsriEOSqHeb3rtQKLQ5bJItV3WYlInH/axkgQs30KeNvc8RzUrEH
s1I6QfFEK007eItNuo+4+t0N+Ec7NzbbWMEYdXcfY55GPnuH9bWIyeAubx8fnUgL
dYHeLZ7sJRtJeWMb62QhHUapDvz9O3FvH3IZdBo/lLD72eqwy16fqA7Px+DMp8GT
staZasbUvYWtnbvgXXG0VaFGn4uI84SDv1EzuN0FFkwl5rkwPl0+sp4WC6dEbH7n
ue6bfvW1DLeKj0kUtvMQ9wVexhoKZlol4qIKjdpz/7Dch2xdK/+MpkzCwYAuSenV
KS1FJaKHk4KB7P8/yLfYtKz+w9B3cuYxv2rNcV6V1VoAvbI/apAotZoCR/fbtlD/
fdDpKr4r4RhyqAHrYHMRCP/r2cRE4bNC5nycgP0YCbVvLUl3HAxcJgowU5ZnQLFg
VLPBmfg4VrOd9rbx0wHn9yXm6N5ZnSSbDo86H8vO4ecxihHuXBLNPNPOsPHEA/F+
U9RtR6TewfXOxfmYGQN6ZiQcOWEZ4h9KHI566C/Gt1vO4IhHr4oZ79+zzcnAetTg
I5Cf5LlHOAU=
=crdz
-----END PGP SIGNATURE-----

--=-VnkK0pVA9IJC1y4A7T17--

