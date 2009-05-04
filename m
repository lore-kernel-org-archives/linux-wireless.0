Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZEDIAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:00:45 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241423935.2899.7.camel@localhost.localdomain>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423935.2899.7.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9QOEyIKmC8AfwXRsGtSV"
Date: Mon, 04 May 2009 10:00:42 +0200
Message-Id: <1241424042.8683.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9QOEyIKmC8AfwXRsGtSV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > IIRC the third characters there is a space if it's in- and outdoor, it
> > might make sense to parse it instead of just printing it?
>=20
> that explains why I have seen USI here and couldn't make sense of it and
> just declared that AP broken :)

Heh, no, I think only "I", "O" and " " are valid there as the third
character :)

johannes

--=-9QOEyIKmC8AfwXRsGtSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/qCoAAoJEKVg1VMiehFYGGIP/2PfdsBldd3A5cFAa9NH5mtY
gDGuMjU27Qm+iTXP616KB0dwOAiBUHRBbf1iv0EyY27Br4bc0bZC9yCRcneoeddv
pvqJEx6C+yqPhKQ6/+bK3uX99qezvwWdR4ycVWq/nDPN2MGlNTEzCv9OoK9yVB50
eF1tpG+rAHEU7w7KvWBLRtSqJpcM2U4IuEG/LmNTmAD7rTACHdRbySzZZ9HF1/mt
Brz3jlT56HAnRBF2cLdODNrvhdxKqew3GOtwBhsZ2OegLU3YtHIUApFn+tFbNKlV
wzIH14V4degcxSvyOuEJFcY68roOi3GiCEk61AYDTEiQnK7+q9K+yM0V7OqYYEF5
0FfQ+88geyw0B7g/C88/KH4zj1dBO4h92ACHHmWimvXottvUT3SIlCxB0j4t7xIU
V/IJP5nkMF8pbAoiILlpaVvQU4XpAEB0zCcLjJjXeVQluhJchlzWkBzVkKB8Hdk7
rjrq9HRLdWPtmLojrN3ZzN9wWh9a220svZiGskA8yFTH5yq7KRncjavJUanmbv6Z
J4qzkPMphkIrJsvY7GaBdC0A678/u+7vxG6Cs8KG6A7Hro3atQeketMjpDNOtV6G
UB3smj7KPWB5/Ze09qs5Zg0AYh6xQPGLETB1QzdVb0TuONICzW2FyH557BXctEYZ
dam2/mkJluwyIUzg2ula
=p1AT
-----END PGP SIGNATURE-----

--=-9QOEyIKmC8AfwXRsGtSV--

