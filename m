Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:52959 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaDKHFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 03:05:14 -0400
Message-ID: <53479407.7050005@open-mesh.com> (sfid-20140411_090520_117867_CAB2F5CB)
Date: Fri, 11 Apr 2014 09:04:39 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [RFCv2 6/6] cfg80211: implement cfg80211_get_station cfg80211
 API
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>		 <1396211704-4677-7-git-send-email-antonio@meshcoding.com>	 <1396951582.5936.20.camel@jlt4.sipsolutions.net>	 <5346C0B3.4050704@open-mesh.com> <1397149960.4757.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397149960.4757.22.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tvdTR3IE0ars1bBCSIH2PaRWocJRHa0p1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tvdTR3IE0ars1bBCSIH2PaRWocJRHa0p1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 10/04/14 19:12, Johannes Berg wrote:
> On Thu, 2014-04-10 at 18:02 +0200, Antonio Quartulli wrote:
>=20
>>> Any thoughts about clearing/filling/partially filling *sinfo when
>>> returning an error?
>>
>> At the moment this function relies on what rdev_get_station() does and=
 I
>> always assumed that in case of error the content of *sinfo should be
>> considered "undefined".
>=20
> That's fine, maybe add a line of documentation?

Oky! will do.

Cheers,

--=20
Antonio Quartulli


--tvdTR3IE0ars1bBCSIH2PaRWocJRHa0p1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTR5QLAAoJEEKTMo6mOh1Vd2cQAIY+P+77gDuJAvatIvE6hS/n
pTM71eivxQnhBNZ6WNfYmBLcuB/eateCgJcdDRJEexwyrKvk7dayTqLpjwTCuijv
jKspvOWW27kOxlN2LOMeg+qCd9Y4nhRIG0+F00wymdJwy6kE4Kos7yhCWbBF/6Rs
IUjFOte1ZMQshEjfWtgRbEjn3zMDyIB/nJVudvRfWzJ8JsUrn0+OqqwyTvtVp06m
BWoQiL5R1IgBgk7PB5BRwNlGYfgDqGgN/zz7Vhsltlt5tdG9778Q9UyGzJRmtl2y
vI9+8NTtNm8VSkL3aNIwWJ0PueAmCRFemfPebNsQCUsyJBNmS6AYJj/EA5g46Frq
yVFZenL4lfmz/XfVxQUMuSRE/D9MY+Gjt8H5aMFs/eGhlCbKbj5JkNQ1XD9Tsrdr
YVSSNs10Xlz061mtmBsFE5y+6FLgRFyKZsnvTMZUlN+MDfGL2A2GAuTMGjxDYB07
gCFo7tgFPvGKOypXchs+XJEUuDWS99tP+4jfJCOtFAaTMN/I9uucMausd0sG6SnC
GEntuyCKgT71+ROgFHmcUc8uthY4uWH1UueIlEJ7PVG5AsE7YvQLGjhlExTOCHkT
weMp2aSPorlkrLcNFGO152PUkJckTQzPA+/fxrPMX9WjK+VJT2ZV0yqdSY7raRvu
TRHXRkj8V7EPSeKQ2Mm6
=1U8I
-----END PGP SIGNATURE-----

--tvdTR3IE0ars1bBCSIH2PaRWocJRHa0p1--
