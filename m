Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZDLHGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 03:06:31 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1239494152.8136.8.camel@maxim-laptop> (sfid-20090412_015626_668863_2CED8163)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
	 <1239395434.13792.3.camel@maxim-laptop>
	 (sfid-20090410_223110_294055_69850902)  <1239449651.17031.42.camel@johannes.local>
	 <1239494152.8136.8.camel@maxim-laptop>
	 (sfid-20090412_015626_668863_2CED8163)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AqUYW7zJSU4Z6fGXhWlm"
Date: Sun, 12 Apr 2009 09:06:23 +0200
Message-Id: <1239519983.4652.0.camel@johannes.local> (sfid-20090412_090635_783190_511B19A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AqUYW7zJSU4Z6fGXhWlm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-12 at 02:55 +0300, Maxim Levitsky wrote:

> > > > [ 1666.298395] WARNING: at /home/maxim/software/kernel/linux-2.6/ne=
t/wireless/core.h:79 nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()

> You mean "[PATCH] cfg80211: convert mutex assert to macro"
>=20
> With the patch:

I really want the line as above now :)

johannes

--=-AqUYW7zJSU4Z6fGXhWlm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ4ZLtAAoJEKVg1VMiehFY8EEP/1ooiTd8rWxPfqk3Eg55wGsW
rth24MdG5WvOa/fMjWFE8RFAPeIn+7hf1FiIFfCGlG5w5jFs3n4hIsoF0mh4INIw
7ewmAgEnJn8thZaPx24J0ivPlx0I4SasWQ0ofU5mRVDJrlV/ws5KA/BQooRXZWn5
1ERY+3I19mtyqtXAxql7fSHoICSbWjX/r7zaV5uEunR/F1PLanoDlnPDSpEs7ob2
BJQxQCNUs3q8phLbbz6fhz5SGiHRIdsp9VsNnFnRcspcZOgwpOgtkwMfDTxWc/0O
e1KS3fqKuDAVWcdsgWyXtKYcg4xrVu77j0+eQk0wuXZzmrrCTLdeSKksX5AQ+LZU
/fat/RcOwnjY3RE22ollg6iIFz64quTo4HMFBinxLr3NbuXycRnn5EUTg6J7HzMd
OuwYT7LFuxk4Ac7iwOailM+5zUruJNvBWfUlAoWW6VcdX1c0dR5SHyMXVcTQRZpO
0fkR748RGm1Z9sZixQKToqAkzeXw+qGlxY2Vbs62hlf+ldNW7QvqSLDxfiBt2tgu
ztyFuwrzjkKAWi8V5s57L/oTTiH3dwQO64XD8XtYKqjcM82z0QNQISuznc4joJSs
TBW6XlPxuOIPfU+1Lb69t/d8rjZntDZAYfu0UXlwMqNoKrT7i2/ux8gga6vpifNR
LBJlu+OjKhpcmqjTti7G
=oAvG
-----END PGP SIGNATURE-----

--=-AqUYW7zJSU4Z6fGXhWlm--

