Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:33126 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZKHNvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:51:42 -0500
Message-ID: <4AF6CC02.8080204@web.de>
Date: Sun, 08 Nov 2009 14:47:46 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170 in AP mode
References: <4AF6C7CD.7060108@web.de> <878wehf85v.fsf@purkki.valot.fi>
In-Reply-To: <878wehf85v.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig55921DDC9C740E17C3AC764D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig55921DDC9C740E17C3AC764D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Kalle Valo wrote:
> Jan Kiszka <jan.kiszka@web.de> writes:
>=20
>> the ar9170 is not advertising its AP feature. However, hacking in the
>> bit allows me to run an AP on my D-Link DWA 160A with the sources of
>> yesterday's wireless-testing. Works mostly fine so far, just device
>> startup (firmware loading?) is sometimes a bit fragile, and rate contr=
ol
>> seems to jump more than needed when the connection gets worse.
>>
>> There was some telling the multicast transmission would not work, but =
I
>> just tested it and cannot confirm this. Did something change or does a=

>> specific multicast scenario still fail? Otherwise I would like to see =
AP
>> mode enabled in the ar9170 so that it works without modifying kernel
>> sources. Would post a patch then.
>=20
> Did you test with a client which had power save mode enabled? That's
> the tricky part.=20

Probably not, ath5k on my notebook doesn't support it. Now looking for
some station that does.

>=20
> IMHO AP mode should not be enabled until it's confirmed that power
> save mode works properly.

How common is the combination of powersaving and mcast in practice?
Given that quite a few useful scenarios are blocked right now (unless
you know what to patch), I would at least vote for a config option or a
module parameter. That gives a chance to warn the user about this
limitation without locking out people that are no hackers.

Jan


--------------enig55921DDC9C740E17C3AC764D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkr2zAUACgkQitSsb3rl5xTiFgCgjGSJUZvdMA9ong7hwDT6HV1R
ORAAnRBfSB+8T0DDUpdqZkKS30lvM3tT
=FPoe
-----END PGP SIGNATURE-----

--------------enig55921DDC9C740E17C3AC764D--
