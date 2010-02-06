Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0BFI76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 03:59:58 -0500
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <20100205165726.GA1496@holoscopio.com>
	 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pA29LmRgTei6ZH4yX0Py"
Date: Sat, 06 Feb 2010 09:59:52 +0100
Message-ID: <1265446793.4041.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pA29LmRgTei6ZH4yX0Py
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-05 at 09:47 -0800, Andrey Yurovsky wrote:
> Hi,
>=20
> On Fri, Feb 5, 2010 at 8:57 AM, Thadeu Lima de Souza Cascardo
> <cascardo@holoscopio.com> wrote:
> > After doing the "station new" command, I can do a "station dump" and ge=
t
> > my newly added station. So, I think this is ready for commit. And then,
> > we need to sort out both the WARNING and the panic for the Minstrel in
> > other patches too.
>=20
> Just to be clear, what are you trying to do here?  Are you manually
> populating the peer links (stations) list?  If so, why?  Thanks,

Andrey, thanks for chiming in!

I do wonder though, the commit (155cc9e4b1d60161ee53) I referenced was
yours, and now you're asking the same question as I am -- "why even
allow adding stations?"

Should we just refuse it (again)? Clearly it would be safer than the
current code that's prone to crashes.

johannes

--=-pA29LmRgTei6ZH4yX0Py
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbS+FAAoJEODzc/N7+QmaQ9kP/22pTViOuwOCS/WlaxxMjxuJ
GqkTJbQDszS4elxPhSE2nRFVXIDE+dnvzwHBOqblqIt5TjVk/0MSRih6HMKuTY2J
7IgnyZA2YJFEnb66OirLTXTzLqI6wcbZOcPjCR40dpoisdqv+cd3YtrWs9nPKxha
DwO0Ywh/oU+Oqjc5UywHBAWRv9AHoUhruM3w4k8sWERAO2OvFFhc+C0ajYClOaXf
gGB9PM7adbBPZ11lGj/ILGYhu2gWVASYAvoDuoDXhKGj3EGhSDwr3N8st5S8i4Qm
wtY86zyiarokewYkv6R8/As4xaofyXwMYl+sfv6LUT6NYJkBehAqw75+2Ey+8fvp
TZqz5h+EK8hpVpQTmb5PjAvJFLbMGvrWceoQZm3LJ6Q+ykpo11XHfZs1qKEcgRoT
LTn83FNQAK+cxu96IU/meHQTlhbU8fOtlUHuvGbUzosZWRfeZuXeUolQdDIHiwSB
KPK54WqPhbvV/pNzSVmOEgqsa/MQYUIm3ArAVtvVHI1OPJQobR+LHAKXYkeVcywW
fr8kHjuJoLqrU/gvOR5eBV6w4xAVnAVYkAX+IVq1L0a/CK+4/GM2+01eH6z23N0b
EzG04/sFWUOCrudiF/tFNF2lTM94gM3SPKUP50hxibmKisN7RXuUds+FhyzDifFU
DU7ZU2SnxUGHlCN+QiHe
=2fn6
-----END PGP SIGNATURE-----

--=-pA29LmRgTei6ZH4yX0Py--

