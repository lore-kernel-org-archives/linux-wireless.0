Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.klingt.org ([86.59.21.178]:49977 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706AbZLIXtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 18:49:50 -0500
Message-ID: <4B2037A0.8080000@klingt.org>
Date: Thu, 10 Dec 2009 00:49:52 +0100
From: Tim Blechmann <tim@klingt.org>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
   in 2.6.32
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com> <4B1CCB81.5060104@klingt.org> <4B1D7A6B.1080606@gmail.com> <hfpa3v$5gj$1@ger.gmane.org> <4B203180.1010204@gmail.com>
In-Reply-To: <4B203180.1010204@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig45689519A4A473C78F75E52B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig45689519A4A473C78F75E52B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/10/2009 12:23 AM, Gertjan van Wingerde wrote:
> On 12/09/09 23:59, Tim Blechmann wrote:
>>> I can't reproduce any boot failures with the patch applied, although =
for me the rt2x00
>>> drivers are compiled as modules. Can you provide some more informatio=
n on the boot failure
>>> that you see?
>>
>> i am pretty sure, that i am experiencing the same issue as described
>> here [1] with stack trace ...
>>
>> [1] http://lkml.org/lkml/2009/12/8/207
>>
>=20
> OK. Can you then test with powersaving disabled?
>=20
> Just do iwconfig wlanX power off on the interface.

difficult, if i cannot boot a kernel ... i suspect, there are some other
issues, unrelated to the rt61pci driver ... i haven't been able to boot
-rc5 (a version i booted before), -rc8 and -final, one backtrace similar
to the other mail (which appears quite unrelated), another one from
within the yenta socket module :/ ... and sometimes the screen was
flooded by backtraces ... i am not really fluent with the sysrq keys, so
i cannot provide details at the moment ...

disabling the powersaving at compile time didn't help, but i maybe it
would, if i could boot a kernel :/

tim

--=20
tim@klingt.org
http://tim.klingt.org

art is short - life is long
  Jack Kerouac


--------------enig45689519A4A473C78F75E52B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksgN6IACgkQdL+4qsZfVssrowCeLpKlKtBIKW9/hTg1UI5hUI9h
AUkAn1qM9irizwiNgWTIcRta1t3tdpVj
=YJxA
-----END PGP SIGNATURE-----

--------------enig45689519A4A473C78F75E52B--
