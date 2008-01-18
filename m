Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbYARMh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:37:28 -0500
Subject: more iwlwifi merge fallout?
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hZOAncxyo4txGtDsCcfk"
Date: Fri, 18 Jan 2008 01:22:24 +0100
Message-Id: <1200615744.5716.5.camel@johannes.berg> (sfid-20080118_123732_327005_58E628D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hZOAncxyo4txGtDsCcfk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Declaring

inline int iwl3945_eeprom_acquire_semaphore(...)

is a bit weird for a function that is actually declared in a header file
and not static.

johannes

--=-hZOAncxyo4txGtDsCcfk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4/xPqVg1VMiehFYAQITfhAAhKl5RRXm/5YBiEzBGiyzTXKkkGU/loEV
UTNE9CFL//WAOxU+hfGBO9NWkDE/48Ef47tycCuS/9qcmYHcS8FOCJou2VMriCfM
uPgBcD6IsWBipc3uACx75k+snt/OAvpq8+rMQt/4vCyoPKTOByKiXVZRLl2xS3qd
FavKRvsl5iVrjRttwScROTgnpOAoSnmB/P+sNvYMFpqI7PME1hpCOXDQKcOWsA93
+7cMP/VzPxFhjU/eO2m2hhd88g7j9SnnAZif5vU0RB+PLzXrGEdYSivUPTA2Zfyz
DcbwfJQBtjq9fYk/HCk4JntOIlfvCQxLYFLSnfu/SmTl9KSvj/hqHRZqkkNfTMB7
Y991A0Z2SyMJs2zLObRMki45QXuHmJbwL7H0MsolOmMkBSfx9rTiRrwYU4JNvhDt
C7snRrPiqfuolpiX1T/AFAB6HHYbJSGzTEiefkMhBHweWCiEVjGZ1Z8EiBgYs4A/
93TqggPUADvCmWZq0Ia3aaHLJp2dtL/3x8G5zwt8kt+Jy2DC9wZk+voFiVinI3lF
A/MbgQFELQY/fn0QYoXLClqY9EvRY6b2N152qCp5vlC0O+6V0ob0pVw/sHQwWZy2
ORg+qddaAurXUMhCcR2B7x7N5lBDUPhVk1zi26z3vsKaiGnhL1HWB+bDITEKb2+N
MH26nRThGGs=
=Mheh
-----END PGP SIGNATURE-----

--=-hZOAncxyo4txGtDsCcfk--

