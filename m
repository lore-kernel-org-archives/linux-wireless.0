Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53795 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbYFMMRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 08:17:38 -0400
Subject: Re: [PATCH 1/3] iwlwifi: adding channels to sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
In-Reply-To: <1ba2fa240806130511i1686bee6m8701614a11a46aa6@mail.gmail.com> (sfid-20080613_141139_436989_456CD442)
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
	 <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
	 <1213343813.3860.0.camel@johannes.berg>
	 <1ba2fa240806130128l433c5b3fxfc7ff13c886a2fa1@mail.gmail.com>
	 <1213346113.3860.3.camel@johannes.berg>
	 <1ba2fa240806130511i1686bee6m8701614a11a46aa6@mail.gmail.com>
	 (sfid-20080613_141139_436989_456CD442)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DXYdw2aKiqcEcfRUoR/j"
Date: Fri, 13 Jun 2008 14:16:58 +0200
Message-Id: <1213359419.3860.33.camel@johannes.berg> (sfid-20080613_141743_576907_9D1A823F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DXYdw2aKiqcEcfRUoR/j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > If you managed to get along without this for so long, why is it needed
> > in upstream now?
>=20
> We didn't run without it, We  were developing HW 5000 on older kernel
> now I just merging it upstream. See my announcement  Try to imagine
> that there is world on totally different planet with different
> gravitation constant,

Heh. But that still doesn't explain why you're pushing this API into the
upstream kernel.

>=20
> > Remember, sysfs is API. You don't get to change it gratuitously, so
> > neither should you add to it gratuitously. And we already _have_ API fo=
r
> > this particular thing which is not dependent on a particular
> > hardware/driver to boot!
> Agree. We've just returned what was there before
> I think you understand what legacy means after your try to replace
> wext. It will take time
> till we switch to new API. Unfortunately cannot fix everything in one day=
.

I know, and that's why wext will stay around for a long time to come.
I'm well aware of that, and I think you're aware of that as well. I just
don't see the point of _adding_ to the problem with gratuitous API
proliferation when apparently you can very well manage to live without
this piece.

Couldn't you move it all to debugfs, which is understood to not really
be API, and change your verification scripts to use /sys/debug instead
of /sys?

johannes

--=-DXYdw2aKiqcEcfRUoR/j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUmU3AAoJEKVg1VMiehFYzjgP/39pZtkyjwNco0s8IREIETtK
lpX0vWaCGEwZ0DR1lEEDv/SqYPDFGC4I7W1OiWob3oUE0fKIiW2+feh4tI477ax1
ZwZIzELA86uaAeP16+n84/WHFeHjMyjU9snQ75WXIe59mtxtlzFcIrI1PH9c+LoH
3Qzp7ZsO8GLEmRwLFwVroFNEw747+cJrBzGlRlDwqMUO6OWTlItdbfuOm4XF6WUz
qaD0AYcbc8Qzd7PBTw/aY9A3+l6E8x9YdQ1lq5RavEEK9gqOmVxjkMmF4W9T8uIA
oXnJxPefvEmJ6JVKRX3EiwpjxVXzNR4T2O2IzriPGBSzlme96vRkfEesZ/xPUUHc
ZAE+VMonwLBsMZ3iDVKo2kCok+MaRTxG+2x2AZaTb8PjHQJFmkJlf9AEAHGjGuoJ
8KmHylL2mzE0mR65/G2q9N1YDUdK11b8c/th4JV+phN0eBXyWXlsvSrkzJaTr3gr
c7/mtAaIGuNnyzQ/ISiSqaQrkDzvfVGKd/5dBdBZroZYnfIiG2dRJqP4+UhrJJyj
63SkDi1RmM/gfJp28DeqDPieMAKTsux3b3t0D5Fu8IvhOA0JOmhsnmFt6nxdFPEj
fRm5z09YRl+EDGFHadTIsQYxAr07Ru6zBNRV5h8VUVwvDJvV8P9gaAZPSeyazXDD
bJ+sIc8VpxaWQDJvWz1C
=VpUM
-----END PGP SIGNATURE-----

--=-DXYdw2aKiqcEcfRUoR/j--

