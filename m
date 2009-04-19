Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548AbZDSPZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 11:25:06 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419151629.158790@gmx.net> (sfid-20090419_171702_263242_9A8C16F9)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net> (sfid-20090419_171702_263242_9A8C16F9)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/5X2nf/XrJAmHmCFbfOV"
Date: Sun, 19 Apr 2009 17:25:04 +0200
Message-Id: <1240154704.898.18.camel@johannes.local> (sfid-20090419_172511_582901_44444F5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/5X2nf/XrJAmHmCFbfOV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 17:16 +0200, Alina Friedrichsen wrote:
> Hello!
>=20
> > Anyway, I think you're confused because cfg80211_assoc_request looks
> > like cfg80211_ibss_params. Trust me -- that will change.
>=20
> How much?

It will pass in a cfg80211_bss structure instead of all those parameters
once we move all the stuff into cfg80211.

> > Either way I'm not going to argue this with you anyway, I've already
> > decided to do it this way. You'd have to find many many people who agre=
e
> > with you to convince me otherwise.
>=20
> That is not an technical argumentation. That is only plead on human hiera=
rchy. :/

True. But I'm not much interested in technical arguments about this
point since I and others are convinced that this way is better.

johannes

--=-/5X2nf/XrJAmHmCFbfOV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ60JKAAoJEKVg1VMiehFYPwUP/j5cum45rOCFj1/gKd69IoLL
6DZTyYX7wN08dKnP+WqvUmk2JnCeQzYIOyWSJnZ6/ld+aUOmjELEVfkuWAueApSQ
OgxL3Fmtc7FhyegejW3UcLqZKyJRKOnt6H+Kp/2s5XRgBvVLInUFqXSi8CDQypXr
M5c09Xb8ZYiYLT+K8WoFhLILRt03ALBeEaaQJ54GN2nQcjBw9G+icLXwBZzP2LlS
heUj9XMSwZwqIORGJFX+2akeulRxThOrXrpbHcpXsaSy4hvIsYlHL5OcSfTeYZsy
2N8N29QxYJhtwkt1a8sk46gysXBwo/QcX9eraElmPPN37dxBYWNnI6pq/crzmRUp
hjl8OJY2/xeTgQZKRtQDNs5StKNxn65wr2SPNyBwHMe3Yd02zt7ZCHR4FL+p0brq
Q6I/FDr0ILnkeHfaTQmMHy5s1rNW4/mYgjQi996/tDzEycSrNcq9nFOHFBJlqoPT
GroUGegMd9ysjSkfGpB7QwIKGRNiFpbEMIeU/nVfBqWaXCrg/pOewLrIL/xjId/8
H0Dv9rqWF4DFSh10pStjZ/Qgzu0kPX2+0VJMldmmlR96PcMkZc6P7cPlNEL5MWeO
BMBqyJimuM7cYZEH3gl5aWWyU5OX/RMGeHLhMpykd4OTB9/rIpz2LjnXmjKVcsKb
URD9I/bPzcCupRYpuMUv
=0I05
-----END PGP SIGNATURE-----

--=-/5X2nf/XrJAmHmCFbfOV--

