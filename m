Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:52960 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753804AbeBETFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 14:05:09 -0500
Date: Mon, 5 Feb 2018 19:22:57 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Adric Blake <promarbler14@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhogan@kernel.org
Subject: Re: B43 driver no longer works in Linux 4.15 (bisected)
Message-ID: <20180205192257.46400baf@wiggum> (sfid-20180205_200618_810195_967079E6)
In-Reply-To: <CAE1jjefXcbuz5nWxo-BOPBRC7EM6KrXd=G7u-4b74tB5DuYGCQ@mail.gmail.com>
References: <CAE1jjefXcbuz5nWxo-BOPBRC7EM6KrXd=G7u-4b74tB5DuYGCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/J2aicKjT07+LcOHxFU4kEBg"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/J2aicKjT07+LcOHxFU4kEBg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Feb 2018 13:14:28 -0500
Adric Blake <promarbler14@gmail.com> wrote:

> In the time between Linux 4.15-rc8 and -rc9, my wireless driver, b43, wou=
ld
> no longer load automatically. When I modprobe the b43 (and ssb) modules,
> the device still didn't appear in NetworkManager. Comparing the kernel lo=
gs
> between working (4.14.16-lts) and nonworking (4.15) kernels reveals that
> there is zero output from the ssb module, and no devices recognized by the
> b43 driver:


Thanks for your bug report.
A fix for this exists already:
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/=
commit/?id=3Da9e6d44ddeccd3522670e641f1ed9b068e746ff7

--=20
Michael

--Sig_/J2aicKjT07+LcOHxFU4kEBg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlp4oQEACgkQ9TK+HZCN
iw4n1A//RftVm50NGnVnIkixEMD/TjUR76NkS+hSKOKRriBlTdGhlkjBoSeKe07T
MGi2RtyZUMlYwutqcd8k/dQDyHUcP8YAB8OV8TSoW4kLstE8o0wJErcuTQ9PW+NB
Glgh5Zkm9JVeyydzEpTSF6ZKoJwWV4odmzS42K58QUMEr4TzVxVQukWADMW8CmEm
qMWD0FuzHv6aAt2Tr4k/ztayr8LXhkB6vfD7/5twJoNyeiuPfSZCxp9DhF7r54/X
LtVRyNbcWQmMkYyKYLTraE7uPkrfHstJi5mhX1+B+OvtI4VMVbLXbWyYbsecWMCZ
kol3k3kq3uT1+0gU6OhnPT8cbP7q/fi4DPiDIxaP/uKyb2yoifW+bCCVq72OMvFl
RgAFdtBvmFyCLWPzXfhxHbc+pZu5yRRtGGwm0pQEKb/HEH8hZZe4aFRJkSrgveuu
iukwoRPb+C8TDrBpDqO3Yd6WsgSyasMHz5OBdniStWHk8AH5A8l4joNilh1QfnEu
giCWybycpILclz7VgsiyL9C9QgPr0o1pwT+4jPWGoQKukTIFbVynbZ+/jcetivae
dKqvZ6B3bKUIAOb1Iz2Kxyf97VRkGAb80HWLEgYHSUKU6ey6CMry4bmIBlml51vI
vdUSCvOpHbRjJtusbVn9jLdw/O8g5IIykEzSe9w4D59RNKVn4nI=
=5OQo
-----END PGP SIGNATURE-----

--Sig_/J2aicKjT07+LcOHxFU4kEBg--
