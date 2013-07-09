Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:48695 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3GIOQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 10:16:26 -0400
Received: by mail-vb0-f48.google.com with SMTP id w15so4387445vbf.21
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 07:16:26 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: ravichandra bangalore <ravichandra.bangalore@gmail.com>
Cc: Luciano Coelho <coelho@ti.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wl1271 NVS file loading
In-Reply-To: <CAFHiHQ1_-XZkCpiL_dc3MK93pJKTSuwadcxe=iR2vK7YkzhbpA@mail.gmail.com>, <1333356840.16990.29.camel@cumari>
References: <CAFHiHQ1_-XZkCpiL_dc3MK93pJKTSuwadcxe=iR2vK7YkzhbpA@mail.gmail.com>
Date: Tue, 09 Jul 2013 10:16:23 -0400
Message-ID: <87txk395u0.fsf@gmail.com> (sfid-20130709_161629_914269_5DD86029)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

ravichandra bangalore <ravichandra.bangalore@gmail.com> writes:

> Hi
>
Moving to linux-wireless@ and including Luciano Coelho who replied to my
original request. It's often best to reply to the original thread (or at
least include the original list) in these cases so others might benefit
From=20the resulting discussion.

> This is related to your posting on "wl1271 NVS file loading" in forum
> linux-wireless@vger.kernel.org
>
> We are facing same issue while loading wl12xx.ko
> wl12xx: ERROR could not get nvs file ti-connectivity/wl1271-nvs.bin: -2
> Can you please let us know how do you fix this issue.
>
> How to compile "wl1271 as a module"
>
I suspect the bug that brought about the need for wl1271 to be a module
is probably fixed by now (assuming your kernel is newer than
3.5). Luciano might be able to confirm this.

If this is the case, you may want to verify that
/lib/firmware/ti-connectivity/wl1271-nvs.bin exists. If it does not, you
simply need to install the firmware by whatever means your distribution
provides (e.g. Debian/Ubuntu's `linux-firmware` package).

Otherwise, you can try compiling as a module. You can do this by either
editing `.config` or using the `make menuconfig` command. There are
numerous guides describing this to be found online. The relevant
confirmation symbol is `CONFIG_WL12XX`, if I recall correctly.

Cheers,

=2D Ben


--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJR3Bs3AAoJEErkyLZmeNiDozYIAL54WoD33raIvL848RNLObM8
eih8/S15Njm1LczS5ubVgaxR6VKqowIRm6279Dcb0+p32pkTUo1Ztrax7H9SYqEh
SKN2a8wYcDrN6FiL+Pb5sC2nvUEHiQrJ/4ZrFyDOVGgHmCA85WBkuQ1oS8ImNe+i
nHDBwkKoV5IHBHFNH6aDoyBRt8OOmOCwcEVnx7hO+Fvk7mkpaBY/Szvpuc76mKdQ
5RWCagKjQ9reTzWv4easjr6QZjzXCgEjKLRERajsge+wJL2u8BAH9uW+/ye/ftX/
GAnBczYRW6y7dmOLSOkY7uUDRS1ypZ0fQ+yB4MDMRkG1id58fQaROBEQihoTsh0=
=sp4g
-----END PGP SIGNATURE-----
--=-=-=--
