Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYJNQfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:35:43 -0400
Subject: Re: [PATCH] ipw2200: Change driver default policies
From: Johannes Berg <johannes@sipsolutions.net>
To: timg@tpi.com
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <48F4C7E8.4020201@tpi.com> (sfid-20081014_182519_109984_4FB94716)
References: <20081014145708.CAF215A1D8@sepang.rtg.net>
	 <1223998992.3936.28.camel@localhost.localdomain> <48F4C7E8.4020201@tpi.com>
	 (sfid-20081014_182519_109984_4FB94716)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9zMfIhNM7RmuWqPsh7lq"
Date: Tue, 14 Oct 2008 18:35:03 +0200
Message-Id: <1224002103.10113.42.camel@johannes.berg> (sfid-20081014_183547_639614_191A9B5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9zMfIhNM7RmuWqPsh7lq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 10:25 -0600, Tim Gardner wrote:

> >> 3) roaming=3D0 - do not automatically roam to another AP with the same=
 SSID.
> >=20
> > Not really sure why this should be changed?  Were there reported issues
> > with this behavior?
> >=20
>=20
> Its been my expereince that wireless drivers rarely make the correct
> decision about when or where to roam. It also seems like a policy
> decision that ought to be made elsewhere.
>=20
> Frankly, I'm not that concerned about the roaming option. The default
> for 'associate' was the one I _really_ wanted changed. I'll submit a v2
> patch with just that change.

Would that also turn off the spectrum-polluting continuous scanning
these cards do? :)

johannes

--=-9zMfIhNM7RmuWqPsh7lq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9MozAAoJEKVg1VMiehFYoT0P/A0YyLyeoNnuieQmwztbD8yq
IAsdwW/0C7Ut5Y1py1ncrKpTQOjwVR4O3CS/eeo/JF8iJRMgrAWtNad0uYGPoGnK
YRDiKJFzY/rrXg3ky/hfQIIDFiJD/XXZKuEuSM32q+fvGDT4j5xjvGRKCly4H5IX
+HKjazgd5LDiNHTnSSeS5cnCWKNBkxiqbANExUVd7jAzAsvUqAWa76aFjYkBXEQ5
K/xJ4Y+AXl4wXqX7tVh7N1vDXYtejza2XGzkRJfJ9Kdmo6SWuSOBoxIcqjKhd4E/
O579I6D530NsxbHPU7L5wmevTgED3ek1rjbs39sjh8khQsC8t99noGQHm3Zynw4X
+X/pqIqMPLPB7i03+VtNrfBHUr7IysssD0rwc48MAZLDkWhZpC7NUvDmBhRw48hx
1rr01Oo2vSDMtFbVey/ZaNW6luZXUiLEN9UOfkByEXEDqYzvnI5nLHq3pgpQ2LSP
XvDGz9mYeIte5rmXxIL7W7OVAysgpH8N59IA3PeGdQrKZbhj3NlzemVGpv6e3HsR
LOTED64DDNUU+ZHHBqgyMBas6AbNX41/EdeSM56uefRtEB0EiT/6jC96TbNuY1yA
nfuwRTOdv0Qv1Z2muIjLnayyKxeDlPLCNJ5MduVNk3wQ+sB9y4tB2ob0uExRRjzi
OdI49iAoyMmvTCIfhQLH
=EuHT
-----END PGP SIGNATURE-----

--=-9zMfIhNM7RmuWqPsh7lq--

