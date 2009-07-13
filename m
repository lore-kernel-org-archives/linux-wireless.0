Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbZGMRzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 13:55:24 -0400
Subject: Re: nl80211 and wext interoperability
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1247507618.4369.11.camel@localhost.localdomain>
References: <1247139797.2144.27.camel@johannes.local>
	 <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
	 <1247163342.22527.2.camel@johannes.local>
	 <1247507618.4369.11.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LEgPNj9QC41PMsPOYDTf"
Date: Mon, 13 Jul 2009 19:54:37 +0200
Message-Id: <1247507677.4166.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LEgPNj9QC41PMsPOYDTf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 13:53 -0400, Dan Williams wrote:

> Mainly because there's no way to tell WEXT drivers to "stop whatever
> you're doing and just be idle"...
>=20
> The supplicant clears out the keys on TERM anyway, and in some cases
> (iwlagn) the driver will keep trying to reassociate internally

Seems unlikely, ITYM ipw?

johannes

--=-LEgPNj9QC41PMsPOYDTf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW3TZAAoJEODzc/N7+QmaKpIP/R3Y8KGytRS931wKGc7GFj/+
PsQ8MN92ukRTC4KQCA7tsXCFlaAcNfVCEjuOfD8IlniH2XivMEzgc6bAS0Zx8TLi
tw+67klRSlmx5tjJ30liBUc6HqbJKN/0slxP3KuBHOVNj2YP2i3XXPOiy8I2j4q1
uoPepneMjkLN7d2ZsYKEARd38k+iPCrS/R50liPoWfkNy+tOxAcfMsES+ttfkWWP
yLddZgPM/B4J2Esusx+mBimt5SbmEwuon+FF39T5FngJi4Fjtw7kpuN8KCBmkZ+v
ZD+RP70ykfbso/wDmszXaZf4osVyjuRD9C0SVFqsIm1mlJKLUAC7E4Od+wW7dNq7
7bUXe1RcDsDwELfD5RdU1h/GcFfsJ4uqPwZCDylfVaAzsfkQjReuULhfrVv6RIk4
NbOW9mBYiZTsnVlx4V4LUJEd8ZU5wLjz9JWo74Vk2dP1UYsgjP88GccM77j4yGbx
Se7cpTNdsF9UXOsJOqWIz0R67+vA0l5TTM8EWErM/tFgLfcGqCsYxRH05nqwOvJN
Uf+tu+8FC3uXInXCSNLzE5VhoydDofoW2HZnrFDzE1iM7d48sfJQhSkxVRnQcn6B
H1n+RF+pbbC/OcHLdx1JBIiiSHPv199mNjiUYqEERrCGpOV69OsivQJsXqP3ujGu
EQ0TA8BgPpdRvEyX8vvl
=M+33
-----END PGP SIGNATURE-----

--=-LEgPNj9QC41PMsPOYDTf--

