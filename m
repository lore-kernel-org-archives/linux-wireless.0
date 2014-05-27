Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58030 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbaE0UTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:19:02 -0400
Message-ID: <1401222183.2586.6.camel@deadeye.wl.decadent.org.uk> (sfid-20140527_221907_135097_D6D9AF7F)
Subject: Re: pull request: firmware for iwlwifi 7260 / 7265 / 3160
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-firmware@kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 27 May 2014 21:23:03 +0100
In-Reply-To: <537B295E.7080307@gmail.com>
References: <537B295E.7080307@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JdgrfWSzULlmy/ODodZe"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JdgrfWSzULlmy/ODodZe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-05-20 at 13:07 +0300, Emmanuel Grumbach wrote:
> Hi,
>=20
> I am sending (yet) another pull request to update the firmware for iwlwif=
i 7260 / 7265 / 3160 devices,
> Since a few users have been using the new firmware even if it hasn't hit =
linux-firmware.git, I didn't amend my commit, but rather added a new commit=
.
>=20
> So we have here a firmware for 7265 (this device has no firmware in linux=
-firmware.git yet) and updates for the three aforementioned devices.
>=20
> Please pull (please).
>=20
>=20
> The following changes since commit dec41bce44e0dff6a2c3358a958fadf22bf588=
58:
>=20
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/=
egrumbach/linux-firmware (2014-03-16 18:12:54 +0000)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware.=
git master
>=20
> for you to fetch changes up to e2844339cb779c00f856c554958e16beca99b462:
>=20
>   iwlwifi: update firmware for 3160 / 7260 / 7265 (2014-05-19 14:45:28 +0=
300)

Sorry to keep you waiting; I've just pulled your changes and will push
shortly.

Ben.

> ----------------------------------------------------------------
> Emmanuel Grumbach (3):
>       iwlwifi: add firmware for 7265
>       iwlwifi: add new firmware for 3160 / 7260 / 7265
>       iwlwifi: update firmware for 3160 / 7260 / 7265
>=20
>  LICENCE.iwlwifi_firmware |   2 +-
>  WHENCE                   |  14 +++++++++++++-
>  iwlwifi-3160-9.ucode     | Bin 0 -> 666792 bytes
>  iwlwifi-7260-9.ucode     | Bin 0 -> 679380 bytes
>  iwlwifi-7265-8.ucode     | Bin 0 -> 690452 bytes
>  iwlwifi-7265-9.ucode     | Bin 0 -> 691960 bytes
>  6 files changed, 14 insertions(+), 2 deletions(-)
>  create mode 100644 iwlwifi-3160-9.ucode
>  create mode 100644 iwlwifi-7260-9.ucode
>  create mode 100644 iwlwifi-7265-8.ucode
>  create mode 100644 iwlwifi-7265-9.ucode
>=20
> diff --git a/LICENCE.iwlwifi_firmware b/LICENCE.iwlwifi_firmware
> index 01c32a0..b168a60 100644
> --- a/LICENCE.iwlwifi_firmware
> +++ b/LICENCE.iwlwifi_firmware
> @@ -1,4 +1,4 @@
> -Copyright (c) 2006-2013, Intel Corporation.
> +Copyright (c) 2006-2014, Intel Corporation.
>  All rights reserved.
>=20
>  Redistribution.  Redistribution and use in binary form, without
> diff --git a/WHENCE b/WHENCE
> index ca0f30b..e174b52 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -812,15 +812,27 @@ Version: 22.1.7.0
>  File: iwlwifi-7260-8.ucode
>  Version: 22.24.8.0
>=20
> +File: iwlwifi-7260-9.ucode
> +Version: 23.214.9.0
> +
>  File: iwlwifi-3160-7.ucode
>  Version: 22.1.7.0
>=20
>  File: iwlwifi-3160-8.ucode
>  Version: 22.24.8.0
>=20
> +File: iwlwifi-3160-9.ucode
> +Version: 23.214.9.0
> +
> +File: iwlwifi-7265-8.ucode
> +Version: 22.24.8.0
> +
> +File: iwlwifi-7265-9.ucode
> +Version: 23.214.9.0
> +
>  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
>=20
> -Also available from http://wireless.kernel.org/en/users/Drivers/iwlwifi/=
?n=3DDownloads
> +Also available from http://wireless.kernel.org/en/users/Drivers/iwlwifi#=
Firmware
>=20
>  ------------------------------------------------------------------------=
--
>=20
> diff --git a/iwlwifi-3160-9.ucode b/iwlwifi-3160-9.ucode
> new file mode 100644
> index 0000000..7b18779
> Binary files /dev/null and b/iwlwifi-3160-9.ucode differ
> diff --git a/iwlwifi-7260-9.ucode b/iwlwifi-7260-9.ucode
> new file mode 100644
> index 0000000..0239740
> Binary files /dev/null and b/iwlwifi-7260-9.ucode differ
> diff --git a/iwlwifi-7265-8.ucode b/iwlwifi-7265-8.ucode
> new file mode 100644
> index 0000000..3b69247
> Binary files /dev/null and b/iwlwifi-7265-8.ucode differ
> diff --git a/iwlwifi-7265-9.ucode b/iwlwifi-7265-9.ucode
> new file mode 100644
> index 0000000..0a3f674
> Binary files /dev/null and b/iwlwifi-7265-9.ucode differ
>=20

--=20
Ben Hutchings
A free society is one where it is safe to be unpopular. - Adlai Stevenson

--=-JdgrfWSzULlmy/ODodZe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU4T0LOe/yOyVhhEJAQrzExAAt3xn7FU4ine1ZrUkIwSnEVaBwTta8gjS
v5h7Zq4N+sGtxjoF5LnFjJkCaPJYMfvZ2g2LnA1zuVLPHAQYzh3s5O50aoAQHtd8
3SWcrhZdFwAExYp5yCnvNJ5wtepPl4y9vB7iMofPkYrzMIJSPz4wm9lCaLJ1kiBA
VONiI4bQH2mAf9s2VcsDblGc0nD7mPTe+Fk0EsyPlzuIuQwQVYZp8MTCv6lnUHc5
u2kIPRX49r1Wf9EYk3KNeCLYfPF1Jp8sWRpncIQwU0+D60matk3W+1wtRxBnuDC/
G7CUV+tVqPTJZqHHWoDjcMfcy+SZZtYlpwcWksmfmccDZG9/gKMVFN3I17kaoOdb
I4lJKeQ+a42UL2oU4g2dl1T9ar6PK5KaRTkOjo9Ay5NEsKU2hEpl/+viyhqIQoQK
vU9kp+++da4beIKILqF/Ly76ipxpq256Ap5HotigAcyXJllHw3rdV0V185dGXKJc
Ssd3lmTVbLQMushcDamQAVzRXtH2ZGJBHe+TjADsCKV2Pj/V/fABoQsSNwVYqWBX
0968Xj/VNuCviEas1ACdn9/Zqr2G3Pmu5bB7NccMfRrfIc7lr2Lc/tS/qBdYfzYR
FNkvNw/Dkol8BzF+6vfwxOh9miVrXLdAY1SG5K63DwuwZ1dwO41hMMopdZLNQDug
wqMQwy1eCs4=
=akkP
-----END PGP SIGNATURE-----

--=-JdgrfWSzULlmy/ODodZe--
