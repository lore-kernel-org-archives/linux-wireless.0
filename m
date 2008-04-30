Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:49651 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbYD3PrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 11:47:06 -0400
Message-ID: <48189473.8060506@work.ksp.sk> (sfid-20080430_174657_956605_FF6D47F0)
Date: Wed, 30 Apr 2008 17:46:59 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] WARNING: at net/mac80211/ieee80211_rate.h:159	rate_lowest_index()
References: <48174652.6080909@work.ksp.sk>	 <200804292042.20500.bruno@thinktube.com>  <48188A3D.70707@work.ksp.sk> <1209567945.18659.35.camel@johannes.berg>
In-Reply-To: <1209567945.18659.35.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBCC9449FF2B53015FAE37041"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBCC9449FF2B53015FAE37041
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
>> Yes, that would be a reasonable option - providing that we have the ra=
te
>> (which we should - there is a WARN_ON(1) in rx-path if it is not set c=
orrectly)
>=20
> the packet is also dropped in that case so you don't see it.
Oh yes. Should have read one more line of code :)

>=20
>> As I think about that, I would suggest:
>> - no sta info is being collected prior to join/create
>> - sta entry is added/updated on each beacon with reported rateset
>> - sta entry is added/updated on data frames with just the received-rat=
e
>=20
> Want to do the patch?

I'll try. Hope we have rx-rate on hand where needed :)

Vlado


--------------enigBCC9449FF2B53015FAE37041
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQCVAwUBSBiUc7rYBI/WS7s0AQIBiAP/cmPX8AxyTBeq9GqQdXnIo3gEKWGPWD4i
SiqpDiA3pnN1zIxKl+rrBzTrJMMFws9y7X4SwHUxyU1xPbNwROzgWjziiqJ+38EN
lpQjddP1XfEO05ySIg1T2JzMxrah8zF+q16lFPzHutp05ATUneN9IdBlmeDSCzvF
Qe8zuYeYXEU=
=ogus
-----END PGP SIGNATURE-----

--------------enigBCC9449FF2B53015FAE37041--
