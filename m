Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:34662 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbbEVVNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 17:13:22 -0400
Date: Fri, 22 May 2015 23:13:00 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
Message-ID: <20150522231300.200a2e00@wiggum> (sfid-20150522_231325_882706_53FCB308)
In-Reply-To: <555F8FDC.3040609@lwfinger.net>
References: <20150521214421.15983b0a@milhouse>
	<555E5433.7000904@lwfinger.net>
	<20150522070035.711c6195@wiggum>
	<555F8FDC.3040609@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/NFmjtWFj4ZH+MMCGYSD2Lw0"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/NFmjtWFj4ZH+MMCGYSD2Lw0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2015 15:21:48 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:
> What does lsusb say about your device?
> 7392:7811, which is an Edimax EW-7811Un

It is exactly this device.
Does yours also fail with vanilla kernel?

--=20
Michael

--Sig_/NFmjtWFj4ZH+MMCGYSD2Lw0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVX5vfAAoJEPUyvh2QjYsOC9cP/1o3Sk6LyF0VE/+loSDavCkb
XuLoGs2SWQ5zbfwDNBgpL34Ga2oKUAIs7faUbksXqOt6rLyH8iWKaooX79pAaBbS
9yqj16V0nccOb1KFyZsB8+BlcLamELaLybOvAgqQ96WQ4Wj0dPVBP9910G5sLe3/
aLCRZRTQLbJZfQ3ebJAvBNdBtE3OKTW0cBulEnyi/AiYqkhUeyfgb/8ry0FDopLQ
3ifIN9qEEHR69VNNxljmyvYHQCnz1lWxNC6v1o6rvj8LdjL2zf4yO8R2D7sxMQaP
etzA+SoP4VGZ+JmErWaSYqKyoOZAfEmy2sRM4av6UcKwQ3fuitxPi3CQ1xYlAhmf
e9pRrWmk1T6t2/bxb+C+JAUr66FRXaysJze+CXyV/SyWWXCMMMpKyxBYtGYjzS2B
utIbmmeqM92AN1EHpQgzicnQWJw8rYt1u58vnr4WlxMUiCoRPk1DEvlTIqr5tolB
GLX7n7BN/+1EFvw+7VC1XsVb8cKZeMU58yujvwxnZUGU9QWMBjYuOev3yLIdVJsz
t0va5eEK11UTfIDVicxc0FQTUYYYaT7BDNgmqhbUbMAjW/5tiRBKYfB1oOjiPeDt
i0cmklAfg1zTQPPpn4gL+7F+jbs0BAHnGa/VB9B6jU7hX39vA1Qds+qXe+7Ttn35
DQ+NTMZpMvs2sggT9/II
=RLAG
-----END PGP SIGNATURE-----

--Sig_/NFmjtWFj4ZH+MMCGYSD2Lw0--
