Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaLUIAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 03:00:47 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: firmware update for iwlwifi (3160 / 7260 / 7265)
Date: Sun, 21 Dec 2014 08:00:42 +0000
Message-ID: <1419148843.2316.8.camel@egrumbacBox> (sfid-20141221_090052_564064_E65FE9FD)
References: <1419148696.2316.7.camel@egrumbacBox>
In-Reply-To: <1419148696.2316.7.camel@egrumbacBox>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-ZiDyMiAtNmrD5v4UfK4q"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-ZiDyMiAtNmrD5v4UfK4q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

with the correct address of the linux firmware maintainers this time...


On Sun, 2014-12-21 at 09:58 +0200, Emamnuel Grumbach wrote:
> Dear Linux firmware maintainers,
>=20
> Here is new release of the -10.ucode firmware for the following Intel
> Wireless devices:
> 3160 / 7260 / 7265 / 7265D
>=20
> This release includes bug fixes only. We fix here firmware assertions
> and association with buggy APs.
>=20
> Please pull - thanks.
>=20
>=20
> The following changes since commit
> 38e5405c96d10bb42b629b45210c46166461fc21:
>=20
>   cxgb4: Update firmware to revision 1.12.25.0 (2014-12-01 15:48:02
> -0500)
>=20
> are available in the git repository at:
>=20
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
> master
>=20
> for you to fetch changes up to 571ad1ab9f6c85ba859387166f528a70ee1aa151:
>=20
>   iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D (2014-12-21
> 09:52:07 +0200)
>=20
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update -10.ucode for 3160 / 7260 / 7265 / 7265D
>=20
>  WHENCE                 |   8 ++++----
>  iwlwifi-3160-10.ucode  | Bin 610168 -> 610064 bytes
>  iwlwifi-7260-10.ucode  | Bin 672480 -> 672372 bytes
>  iwlwifi-7265-10.ucode  | Bin 736968 -> 736864 bytes
>  iwlwifi-7265D-10.ucode | Bin 740636 -> 740456 bytes
>  5 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/WHENCE b/WHENCE
> index 44c41c7..df2dffa 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -816,7 +816,7 @@ File: iwlwifi-7260-9.ucode
>  Version: 25.228.9.0
> =20
>  File: iwlwifi-7260-10.ucode
> -Version: 23.10.10.0
> +Version: 23.11.10.0
> =20
>  File: iwlwifi-3160-7.ucode
>  Version: 22.1.7.0
> @@ -828,7 +828,7 @@ File: iwlwifi-3160-9.ucode
>  Version: 25.228.9.0
> =20
>  File: iwlwifi-3160-10.ucode
> -Version: 23.10.10.0
> +Version: 23.11.10.0
> =20
>  File: iwlwifi-7265-8.ucode
>  Version: 22.24.8.0
> @@ -837,10 +837,10 @@ File: iwlwifi-7265-9.ucode
>  Version: 25.228.9.0
> =20
>  File: iwlwifi-7265-10.ucode
> -Version: 23.10.10.0
> +Version: 23.11.10.0
> =20
>  File: iwlwifi-7265D-10.ucode
> -Version: 23.10.10.0
> +Version: 23.11.10.0
> =20
>  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
> =20
> diff --git a/iwlwifi-3160-10.ucode b/iwlwifi-3160-10.ucode
> index 8cec7bf..241bd4e 100644
> Binary files a/iwlwifi-3160-10.ucode and b/iwlwifi-3160-10.ucode differ
> diff --git a/iwlwifi-7260-10.ucode b/iwlwifi-7260-10.ucode
> index 9e5b930..c7d8532 100644
> Binary files a/iwlwifi-7260-10.ucode and b/iwlwifi-7260-10.ucode differ
> diff --git a/iwlwifi-7265-10.ucode b/iwlwifi-7265-10.ucode
> index 488ddd0..bda8dff 100644
> Binary files a/iwlwifi-7265-10.ucode and b/iwlwifi-7265-10.ucode differ
> diff --git a/iwlwifi-7265D-10.ucode b/iwlwifi-7265D-10.ucode
> index 01194db..ebda04c 100644
> Binary files a/iwlwifi-7265D-10.ucode and b/iwlwifi-7265D-10.ucode
> differ
>=20


--=-ZiDyMiAtNmrD5v4UfK4q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJUln4rAAoJEC0Llv5uNjIBzFcP/3nw26vT2Z7sVFSsTsRFuyZg
yE6czjftmXljKs20zC6im4XhUuf+V/cdrymQOulCnca3cGVeMZU+/1GBN/qQeeSE
UYepX/x1se6i4ZPzqIvctxu6CyZOnltQmxN012E/tZkb+zZFDywWIFxKjF0n7lvd
N3ysMUTNddxAh9M6DaLi2MDi69du6e+HPKWeaspAs0kkBzVH9Cyt6cEZMoq8tGBC
7Q6i1U2tjU4GRygWR8Md9151AFz77hpvTcXELVubEAG7/9ons0uMmkSVGoJXNNbf
obFuCKPT3d4eiXBF3n6sbOBdde81HbHUSDPROfYVfSUkDrYmZ6RvkL8Ro/pSZtBW
3oc1nUkkIJBHAGMiC3/vZNRvz3sVEJ2Z3ql+x+fqe/8TgfGuoNxf/ZTM9kJWd0gC
vasZJJUBoz3A0CX4VUZNwubmNA9hniGf1NmKHSP3yOtpkfW05nrLfom+d32Yj0RR
nnFo50//dm85SLwFdYHIxj8ntBiZc3UAlCxDc8oH0+aJCHMPTo9Z/zBm7ThhFzLS
XywUuEuN0s6rkgIb0iQ3ac2sSGjtF5Bt5dpYnNvy8JXJyq6OYFVOA/8RbIUjajIC
2S+eRZlNhQ0mEo0tK4mw9FCI/EabEmm8DRkLqxhn82xuUYh39KCnnwIPKuVTqe0C
aehpMqaBpP5sixXZfdQL
=lhIz
-----END PGP SIGNATURE-----

--=-ZiDyMiAtNmrD5v4UfK4q--
