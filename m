Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab0BPHR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 02:17:29 -0500
Subject: Re: [PATCH 2/2] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B79CB71.1000509@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
	 <1266190653-2453-2-git-send-email-benoit.papillault@free.fr>
	 <1266226537.7084.2.camel@jlt3.sipsolutions.net>  <4B79CB71.1000509@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oAY8KGZ/Zv9tKo6nS+lD"
Date: Tue, 16 Feb 2010 08:17:24 +0100
Message-ID: <1266304644.3771.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oAY8KGZ/Zv9tKo6nS+lD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 23:32 +0100, Benoit PAPILLAULT wrote:

> You are referring to "we need nl80211/cfg80211 changes" I guess. Could
>=20
> you elaborate a bit on this? I'm still new to mac80211. Could you tell
>=20
> me what needs to be changed and where I can start ? iw source code ?
> is=20
> cfg80211 the source code under net/wireless ?

Yes cfg80211 is most of net/wireless/.

Is it not obvious to you that in order to use HT with IBSS you need to
have a way to configure the IBSS to use HT?

johannes

--=-oAY8KGZ/Zv9tKo6nS+lD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLekaBAAoJEODzc/N7+Qmay/kP/0dz21t9SxaDHozEP2LyH86r
MquJXmDLJoaaGj6d8yfINznrp9tJd1d/M7UIOp+/79Vch1fEjcrUyaqfJW2lIegQ
APXXI041ywMnnGuwGzHGeeEYfI/uvR3LYh1woScUsO5SswOKBFREkOZeZScsFEJf
EZ+Go6yJ3gJnRIMlLijOazZa9XC5QeNVcdZg+NC3baw2A4CTIHzOBMqW3VisqkO8
SgORpPgRqby7Ux02HuEFkHe+1aXeOUCUT8MCzJNfakF8Y68/riru2IKMqy0Anb/1
AYeygQke3GMMg+BOvkJXyRVND8ReUC9A0sLCSPIqZnNFTFup0heC42Q29IgGbLJF
hZ74IxyYw13C30gXJ210X+aQQK6dNq8QIH4/zRqvAdBtqulGLx2vuPrq/p05SMnS
bk3bqTQJO3bTZ4mSMX1v2iii1r3c1AvuZ8cfkzPv3FdvjDxi/40rmDQzwHOLM05K
lkcbFiwmaRe4NCQpz8KwmYMlrSV3kwCWeww2eUvgLvVtfidWdaD4cIwU4DcdCDLG
MPdyKV2Mvq1TLJ1M6JYrCSl8MbpqxVhGM7yiVNHDivneOZhS1MPzIGwheICb2PuU
YMT6cEdlosMyt4ktiJBJmV9Hq1AH/F6xv8HNDIHCa49zXZ+iQbWVWS5mZEoPqJIy
HWrjsbCDJc4/MmgPCNro
=MKzi
-----END PGP SIGNATURE-----

--=-oAY8KGZ/Zv9tKo6nS+lD--

