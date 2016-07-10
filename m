Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betelgeuse.uberspace.de ([185.26.156.37]:51658 "EHLO
	betelgeuse.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcGJKd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 06:33:26 -0400
Subject: Re: Problem: iwlwifi: Microcode SW error detected. Restarting
 0x2000000
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
References: <57820E4A.3010102@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>
From: Niklas Sombert <niklas@ytvwld.de>
Message-ID: <57822467.30500@ytvwld.de> (sfid-20160710_123334_352787_7841DCF0)
Date: Sun, 10 Jul 2016 12:33:11 +0200
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L0G9IQxSdFRgfc2ejMWrs7deVjOmLjCto"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L0G9IQxSdFRgfc2ejMWrs7deVjOmLjCto
Content-Type: multipart/mixed; boundary="lXqhGwvXofj9vQ6pOpNrO8aKM3cqprxAV"
From: Niklas Sombert <niklas@ytvwld.de>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 linuxwifi <linuxwifi@intel.com>
Message-ID: <57822467.30500@ytvwld.de>
Subject: Re: Problem: iwlwifi: Microcode SW error detected. Restarting
 0x2000000
References: <57820E4A.3010102@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>

--lXqhGwvXofj9vQ6pOpNrO8aKM3cqprxAV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Emmanuel Grumbach wrote:
> Can you please try the newest firmware?
> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git=
/commit/?id=3D72266846faa78b939a864842a2aa6ecd8fe6989b

Yes, I've tried the newest firmware. The problem still persists.

> You should pick up the -17.ucode version.
> Note that I can't know if your device is 7265 or 7265D. In able to dete=
rmine, please check:
> https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#and_7265_supp=
ort

Yes, it's a 7265D.

> Thank you!

Thank you.


--lXqhGwvXofj9vQ6pOpNrO8aKM3cqprxAV--

--L0G9IQxSdFRgfc2ejMWrs7deVjOmLjCto
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXgiRvAAoJEIOFK7hVFsHHSkUH/iZpb/NcOBKHx497PxOuNrW6
oL7D+j1F6rl0bs7E1NXsw/4Hkau+p8KtxZCx5GjkZgZKiWuiUsbX3LbvAbKkiIe8
s2AnUqn89rZVm7TKsJhniP0qDAkxxTvzbBWwUA/OAgJOepVXyeQWudU7p682rgK6
wxXBREAHpKCezTnfv1QRd9usvjzBBOC6zg8fKOuZLmS5uvz1pvG1sRcLuCNnnDlw
uuGbBall00rRsE8oufXufVj/yvxW5xJRFtRq7vS+uh9MEkLSwsCISpm0ai0aMQZX
hLhGfxaegkvu4OG/rlQrdyt9fTvDIIrYpp1Qqzt/b8IFVVdszGpiZSlKMWfJo2w=
=chLx
-----END PGP SIGNATURE-----

--L0G9IQxSdFRgfc2ejMWrs7deVjOmLjCto--
