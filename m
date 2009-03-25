Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZCYI5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 04:57:42 -0400
Subject: Re: Adhoc-demo support in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: ming li <mingli@cs.umass.edu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <c03d7e680903241358ya809dabhcc75eeca14782ff3@mail.gmail.com> (sfid-20090324_215825_944080_2BF8E074)
References: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com>
	 <871vsmrekh.fsf@litku.valot.fi>
	 <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com>
	 <1237928031.4320.133.camel@johannes.local>
	 <c03d7e680903241358ya809dabhcc75eeca14782ff3@mail.gmail.com>
	 (sfid-20090324_215825_944080_2BF8E074)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gmdPo9b6XrDikX037nnn"
Date: Wed, 25 Mar 2009 09:57:04 +0100
Message-Id: <1237971424.4320.134.camel@johannes.local> (sfid-20090325_095745_928776_13B8381A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gmdPo9b6XrDikX037nnn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 16:58 -0400, ming li wrote:
> Yes, I have to disable beaconing. Is there any easy way to disable
> them? Will this confuse the state machine in mac80211?

Not really, it should work, with the expected problems.

I'm not going to support it in mac80211 though -- so you're going to
rely on a patch to the kernel forever forward.

johannes

--=-gmdPo9b6XrDikX037nnn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyfHeAAoJEKVg1VMiehFYicMP/0PYelUsjbwhbMf02F5knE3r
5XpWPfXX9NW34cKcpI9aPxSaOpxmifPadzSHWt57+P5UvALPcAJmmBT985k7sHQf
LKZptaJWnLAoBqd41gEolXvl04aAhbBTHOtFfIBA5dGZdWzSrPi4+iAVpAPiPTQl
+BKEmZ/R07On54nWa7iphxnR84PbXN4P+Kjegb7YI/a6L2DoD+0t8zPwCyoJessy
fm4HgDQ1H14pMQnP8Y0uaIJWgngzXWsp0WpawgtM1vRZZOJijR+3txruHGe/qeiE
07tCOSttLrTFO2AQI1xXJjnbpwcJqmpWXV4+AGFq3SrIcSBsHRuIsoUuRW61ZncW
eYRoGK/fhDSAAaokAs7ManwlZH2na5ZstbYoGNu4fm3OEu/ce1dQURJJXm4Z2X7R
ri10Ea7skQK8MLoaSB8lmL5GjTBoIH3AWEdF3qxNqr10T6iygqbJYV5SpDw6LN3W
WJFZFIRXs6LHhCB7XQMJ0oRPVxLXQZqyw7657aSvWXTYIk65TsPX0X/JUOjwg/A3
cNtvN/hHrpu9RVFGG7ogFQUxEFKd5DwwF7u1purc12PNztwJrJdvKtENy1ez1tOj
MLqZgBzc4qokP76cXlzdu/tLkMMgYGTamwVU7Eu+zqpwFNPuK1bZLYhPVnPbT8pi
qdJ3QRpieOotMwDOY4a6
=fV5b
-----END PGP SIGNATURE-----

--=-gmdPo9b6XrDikX037nnn--

