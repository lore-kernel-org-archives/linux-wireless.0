Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:50622 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYKZJA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 04:00:29 -0500
Message-ID: <492D0A26.9090801@work.ksp.sk> (sfid-20081126_100034_138731_1E1B1C2B)
Date: Wed, 26 Nov 2008 09:34:46 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Mark Ryden <markryde@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: AP (Master Mode) of wireless drivers
References: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com> <1227633414.15224.6.camel@dv>
In-Reply-To: <1227633414.15224.6.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig700B81955B5D899BF9FB9338"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig700B81955B5D899BF9FB9338
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

>> More specifically, I am particularly interested to know whether Intel
>> iwl3945 and Intel iwl4965 support AP (Master Mode), and in case they
>> do not (as I am afraid is the situation)
>> - is there any intention to add AP (masted mode) support to these driv=
ers
>> in the near future ?
>=20
> The driver announces AP mode support (look for NL80211_IFTYPE_AP and
> hw->wiphy->interface_modes in iwl-core.c and iwl3945-base.c), so it
> might work, or at least the intention is to make it work.  By the way,
> rt2x00 announces AP mode support too (in some conditions).

I've tested AP mode on iwl4965 about 2 weeks ago and a very quick test di=
d
work (no encryption, just connected a win notebook to it and did some
browsing). Just be sure to fetch correct (=3Drecent) versions of hostapd =
and
libnl..

Regards,
  Vladimir


--------------enig700B81955B5D899BF9FB9338
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iJwEAQECAAYFAkktCi8ACgkQutgEj9ZLuzQf4wP9EU9VBFQG+LHjHxqOFUiXcn0S
lB+99p4Z2n5zKRXeIZblHfBtdTwUYu6KMW2MRFr0s6hdB79XSk9a4wHLAaCNMTBB
ELX/AUyKRAV3V2bOQj1SThXW460ipeYEelqMdVzyOizp/sp3RIYD+H0rTKkwyUTy
Rk2w0oEplaUyAHUOoGo=
=MGMI
-----END PGP SIGNATURE-----

--------------enig700B81955B5D899BF9FB9338--
