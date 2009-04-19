Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbZDSOho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:37:44 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240151621.898.13.camel@johannes.local> (sfid-20090419_163346_662878_5F0F1754)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419142631.158790@gmx.net>
	 (sfid-20090419_162703_506410_10175D69)  <1240151621.898.13.camel@johannes.local>
	 (sfid-20090419_163346_662878_5F0F1754)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QP+RYCpP8hgKof0OWdlc"
Date: Sun, 19 Apr 2009 16:37:42 +0200
Message-Id: <1240151862.898.14.camel@johannes.local> (sfid-20090419_163746_719531_29EA15A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QP+RYCpP8hgKof0OWdlc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 16:33 +0200, Johannes Berg wrote:

> When you want to create an IBSS on channel 5, what do you do?
>=20
> I think you have to
> 	iwconfig wlan0 essid test
> 	iwconfig wlan0 channel 5
> 	iwconfig wlan0 ap off # clear fixed channel bit
>=20
> which is ... weird. OTOH with mac80211 you can also say
> 	iconfig wlan0 channel -1

Ah, there's "iwconfig wlan0 channel auto" as an alias for this, I guess
that's an acceptable way to do it.

johannes

--=-QP+RYCpP8hgKof0OWdlc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6zczAAoJEKVg1VMiehFY3bUP/iaT7bz2G5Nm/Z7voK9MWY0+
6082bVWjy7+UNC78EP0JngLEU7eOBAdS5Ao7gJ6ZUV1ioifmk9sPd68VuKOOPMcE
LzK0Wzs2ZiYkJvFIms9f2e7izdBui/QUVq5ypn/75vaPNAm+7Mha35R915PkviHC
ZRWA8lhCOSecmLoU8oXRcxgOJFXCNDjupNGCFkUFX+9NUZvN+WFGQ7hpDVR2w51z
CU2mix1tmpR6WV+k7U2dBauek/rFqp7FwVXZD0HIZsnln6Wc77Rzo7heK/BjcAAZ
1TxeZSb7KJ/xTDxeNc32hFbK1uVqgx02X+pvP4SpOaMqYCKgzKG00PSFEeqkosvw
onaFaTiN1iURBz/9fTkNWaf8pGVdJxxZzRG9mG8aTOcASoUrDYV8bcW+xgjL4uCa
UOfkDf/6LYa9UzyQypVhukLkBC+vVqPO20l7xmSq/NcDBhft8CTM9WnA7oF6XZpO
YkVogMnw5sY4J2azbvJf8TxVwGTRS8LVkpEYG++F2cbJjHGdd2+fXjAElA05L8Yn
aINc1/AQvmIVuhER+COpRZmPd1ao4AShxBymq8HBkxEISrSVgoBPVyJYq7AhWqO+
XkmWPSEa4AUmVWxzqzkGsyChDznLxBCL3hPUX8Z2HSCCWI2gQZ+cPmucTazfz7yP
mpZnq1SPE4hbGtorNeAr
=D3qc
-----END PGP SIGNATURE-----

--=-QP+RYCpP8hgKof0OWdlc--

