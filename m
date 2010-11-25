Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gerolde.archlinux.org ([66.211.214.132]:34415 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133Ab0KYN7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 08:59:50 -0500
Message-ID: <4CEE6BD1.7010204@archlinux.org>
Date: Thu, 25 Nov 2010 14:59:45 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [ANN] wireless-regdb: master-2010-11-22
References: <E1PKkCh-0005Ay-R2@sipsolutions.net> <4CED4464.2000106@archlinux.org> <20101124170639.GD7435@tuxdriver.com> <AANLkTin2n7ofZ0oom_aD+V4aFZ3dti1P77Mh6bpZOE6Z@mail.gmail.com> <20101124175035.GG7435@tuxdriver.com>
In-Reply-To: <20101124175035.GG7435@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigAEF493818B48753473F7B6A6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAEF493818B48753473F7B6A6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 24.11.2010 18:50, schrieb John W. Linville:
> On Wed, Nov 24, 2010 at 09:33:36AM -0800, Luis R. Rodriguez wrote:
>> I see the same issue:
>>
>> mcgrof@tux ~/devel/crda (git::master)$ ./regdbdump
>> /home/mcgrof/2010.11.22-regulatory.bin
>> Database signature verification failed.
>=20
> Alright, looks like I mislocated a key file when I switched laptops.
> I think it is corrected now...give it a try?

The latest version works fine here, too. Thank you. Will you push out
another release tarball?


--------------enigAEF493818B48753473F7B6A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAkzua9EACgkQEda5KzHP/VCHpgCePkxx3g5D1fD1amhaEUDBBFU/
oWMAoM0I8JXBbucsnLuissCSLLfq1JQE
=hjQn
-----END PGP SIGNATURE-----

--------------enigAEF493818B48753473F7B6A6--
