Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:44647 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYCGRoB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 12:44:01 -0500
Message-ID: <47D17EDF.4010100@work.ksp.sk> (sfid-20080307_174412_943761_C005D657)
Date: Fri, 07 Mar 2008 18:43:59 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: 2.6.24, mac80211 and b/g switching
References: <47D160E4.3040503@work.ksp.sk>	 (sfid-20080307_165126_594708_1A6A8040) <1204909966.6387.31.camel@johannes.berg>
In-Reply-To: <1204909966.6387.31.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2ABB2E1E9756C3DD12EA1F40"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2ABB2E1E9756C3DD12EA1F40
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
>> Is this a known issue? (I didn't manage to find anything in ml archive=
s
>> so far) Or any hints on how to solve this?
>=20
> You want to develop against a non-ancient kernel that has all the HW
> mode foo removed.

Well, the question is not what version I would like to develop for, but
what version I have to :( Stable kernel releases should be those
versions you want to base real products on, right?

Do you think that taking mac80211 from wireless-2.6 (or -testing or
whatever) would cause way too many conflicts when merged back to 2.6.24?
  Or am I on my own to fix this somehow in 2.6.24?

Regards,
  Vlado

>=20
> johannes



--------------enig2ABB2E1E9756C3DD12EA1F40
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFH0X7fe5Z0y47EufgRAnfVAKCA9UD9Tz/mMYQb6rX72eT7pqASzACeMS2T
quXDv1yeMelzYO5J4iBYDq0=
=7CuP
-----END PGP SIGNATURE-----

--------------enig2ABB2E1E9756C3DD12EA1F40--
