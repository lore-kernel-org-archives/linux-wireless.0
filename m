Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52593 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaBBJCY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 04:02:24 -0500
Received: from [192.168.1.221] ([93.196.93.204]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MKZLb-1W8W1z1Zxv-001x9J for
 <linux-wireless@vger.kernel.org>; Sun, 02 Feb 2014 10:02:20 +0100
Message-ID: <52EE0997.1060402@rempel-privat.de> (sfid-20140202_100230_883030_E4C41C80)
Date: Sun, 02 Feb 2014 10:02:15 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ath9k_htc: avoid scheduling while atomic on sta_rc_update
References: <20140131133707.GA7648@redhat.com> <52EBEA45.5090606@rempel-privat.de> <20140131193850.GC7648@redhat.com>
In-Reply-To: <20140131193850.GC7648@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KDi5Aa9Gkfko4rDD1StsUwImIK1MKmhg1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KDi5Aa9Gkfko4rDD1StsUwImIK1MKmhg1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 31.01.2014 20:38, schrieb Stanislaw Gruszka:
> On Fri, Jan 31, 2014 at 07:24:05PM +0100, Oleksij Rempel wrote:
>> I have different HW. How can trigger sta_rc_update?
>=20
> Below patch should trigger it when any management frame is received
> from know sta and print information about it.=20

It seems to work,
a least it didn't crashed. I was able to trigger it only in IBSS mode.

--=20
Regards,
Oleksij


--KDi5Aa9Gkfko4rDD1StsUwImIK1MKmhg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlLuCZsACgkQHwImuRkmbWlYWQEAhB/wsRIy4nO+zcI4lHPeA5oH
Ih3fiwliOU9Jj0nS4D0A/jgk8thGmPofqijqHmqM6xvegMnEol5Q1hApVMazCG3R
=R7MS
-----END PGP SIGNATURE-----

--KDi5Aa9Gkfko4rDD1StsUwImIK1MKmhg1--
