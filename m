Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbYCEXfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 18:35:08 -0500
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Franz Apeltauer <franz.apeltauer@gmx.at>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <47CF2BE1.2020305@gmx.at> (sfid-20080305_232553_041904_D869E5E2)
References: <47CB3B5E.4020701@gmx.at>
	 <1204504331.3917.31.camel@johannes.berg>
	 <20080303035222.GP28995@ruslug.rutgers.edu>  <47CF28F2.6050509@gmx.at>
	 (sfid-20080305_231328_405485_4CF10539) <1204758941.25502.93.camel@johannes.berg>
	 <47CF2BE1.2020305@gmx.at> (sfid-20080305_232553_041904_D869E5E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AUFLB/AN6O0JBqM2a0+b"
Date: Thu, 06 Mar 2008 00:34:49 +0100
Message-Id: <1204760089.25502.95.camel@johannes.berg> (sfid-20080305_233511_889096_F0B9C44A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AUFLB/AN6O0JBqM2a0+b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm sorry, almost the same result:
> # rmmod b43legacy
> # modprobe b43
> =3D> messages: Mar  6 00:18:36 af-nb-3 kernel: [14393.692000] Broadcom=20
> 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
> =3D> dmesg: [14393.692000] Broadcom 43xx driver loaded [ Features: PML,=20
> Firmware-ID: FW13 ]

Huh, ok, I see.

Edit compat's compat.mk and add

SSB_B43_PCI_BRIDGE=3Dy

to the end and rebuild.

johannes

--=-AUFLB/AN6O0JBqM2a0+b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR88uGKVg1VMiehFYAQKBuhAAqdGhn5Wyl4hzdUxMS3uVgOatFRrXXVC7
phGQsCZRxv6InW6pPa+R9hzkCVe39u2cyE4Ms5XBUFuOefdtNhrG+0WZmyvLRe2D
7EXGF7rqN6wW7FTaCCrwiDW2VSP3iFuDvB4xkw2LPi1O12TkdikFWbTWfMtqLVnU
4FBXhSgIJCEJF4XFSQbj5feMdV1WVGqZIMH089r9s6yOHZ3o7gMds6RErsHASf/t
nE3KKKh3pczYRm/KwnZBkZq2Q6uxgHkL32cf6ZzsVpfZEjB7Ccp2e1F2O1iFnmZ3
B43rL/jtSsyuGZYT/Jo2LEIrHZgLVXZ90hro1SbtZ3GUVYL0qZKYo5qkMndkOSva
ehrC30C0Bd0mSIBqsk1ZtqtboCfbglEZ6fgRRgZmvL7sK4lQX7r60Oa3hRVOnZWu
ZDTdo+nG4FR8H3K/t88A9S0WBt9FlZ/sb4tQIpOiGmhqFwAvRBiGJjOn55FG/WBP
uDn3+bRgxthnaVgNViAYMnl+0bi+3uLR1zGYQDlNWmz2lGrBwB8Hqm/rOgzTVolf
OXorX/vxpQJsuFDsamRn9QYk8/tsu7+8/JWzcqGYm8ttxvbyd63hn/czpOANNVv/
zgCh+kajDNv5/FfC8PCvntxg14CtxiYUBzi89iAjIlLwXFyCz0ceMcpldq2PdQAK
Gcl4sjDCNsI=
=mDzT
-----END PGP SIGNATURE-----

--=-AUFLB/AN6O0JBqM2a0+b--

