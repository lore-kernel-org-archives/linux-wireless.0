Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447AbYIRSbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:31:14 -0400
Subject: Re: ath9k: massive unexplained latency in 2.6.27 (rc5, rc6,
	probably others)
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com> (sfid-20080918_202314_494232_4DDE74DF)
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 (sfid-20080918_202314_494232_4DDE74DF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fAuC24B53vi1NTs8wk0q"
Date: Thu, 18 Sep 2008 20:30:39 +0200
Message-Id: <1221762639.20772.5.camel@johannes.berg> (sfid-20080918_203118_530141_F18CEF79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fAuC24B53vi1NTs8wk0q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 11:23 -0700, Steven Noonan wrote:
> I'm encountering a very odd issue which only seems to crop up while I
> sleep at night.=20

Are you still sleeping well? ;)

> In the morning, I go back to my Linux machine and
> there's a ridiculously bad latency I immediately notice in Firefox's
> redraw which I cannot explain.

It looks as though something is just eating CPU time. Are you sure top
isn't showing like 99% hi somewhere in the top? Like there:

Cpu(s):  5.2%us,  3.6%sy,  0.0%ni, 90.8%id,  0.3%wa,  0.0%hi,  0.0%si,  0.0=
%st
                                                      ^^^^^^^

johannes

--=-fAuC24B53vi1NTs8wk0q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0p5MAAoJEKVg1VMiehFYWNUP/3NQ3CMUPkeiiDEfRQsobCqP
CNTo6+a0Ie4HJdaGT+2OWaEWnjP8l6hgjS71MTZenOVYsEzS3MNdIg0e4jktR2QR
6oG8PlBbhpGbvFtU2DWTmbqR7GEUutCXasT0XMYp/ZUMXIeBhdf1iaqCREXi3wRg
LYRalrJXdVJkWjbmom1dp/Smg7M5x2VYzitt6eahT16WorFkLPrqMKxJgSCW7PBP
6Rw0yMPKtoRsrGhmA3PLvikdosPGPqc3r8E7+e+GTI7dxlXFa5THJOvLr1YHVU6f
sZUYHOgrVNyn+KutqCnmtT1rQGNFSKURt2G4gqQZfmIfoRG3fzsEGPcistU+kbZ6
5gjSb7nr7YdCeOyuXW9/ksMDlWsgrYex6LCobwSFm7YrbceFbp32b6+NWuQTLcCK
PxpWxJjfbbDbcX9PTK6asWfBrwBhXEQ/nkOTM0GfZl6skvNR8IvfNHily88galt5
qMJ/zk4OvJXmfwN/vatQawAvugoIG3Pjsi6T4YUfC1KAB5gt7SwqlFWspRZIiJzr
TYdm4hcmD4wZfKLG1CZnotmGu3JaYZIDgKEJaNhr4YIa3WYWHKlgqrNXTORkPXC9
7Bkxsn0FVModslVxaJLac/C6kM+ozYnv0FnaDiHRGkDW21GhxtREfHbZ5rpvsQxe
qqssFBVx3c2f3ZtIhi2y
=PJ4i
-----END PGP SIGNATURE-----

--=-fAuC24B53vi1NTs8wk0q--

