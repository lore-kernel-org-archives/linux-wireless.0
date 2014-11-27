Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zucker2.schokokeks.org ([178.63.68.90]:57939 "EHLO
	zucker2.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaK0XpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 18:45:24 -0500
Date: Fri, 28 Nov 2014 00:40:32 +0100
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
To: linux-wireless@vger.kernel.org
Subject: firmware loading fails (iwl 7260)
Message-ID: <20141128004032.441c4670@pc> (sfid-20141128_004532_966878_41477395)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-2491-1417131619-0001-2"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-2491-1417131619-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I have an X1 Carbon laptop with an intel 7260 chip.

The automatic firmware loading doesn't work (kernel 3.17.2). I get this
in dmesg:
[    1.615155] iwlwifi 0000:03:00.0: Direct firmware load for
iwlwifi-7260-10.ucode failed with error -2

The firmware then gets loaded by the userspace helper, however as far
as I understand it (and the description of the kernel option) this is
deprecated and shouldn't be used. Also, it takes quite a while
(minutes) till the wifi is available after boot which is quite annoying.

Any idea what I should do to debug/fix this? Is this a bug? (firmware
is the latest from intel's page, 23.10.10.0)

cu,
--=20
Hanno B=C3=B6ck
http://hboeck.de/

mail/jabber: hanno@hboeck.de
GPG: BBB51E42

--=_zucker.schokokeks.org-2491-1417131619-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJUd7ZwAAoJEKWIAHK7tR5CfWAQAIywsunEicFlmKdnwfJq+qZT
jW0sd9QSPjDOtrCXgrmjJ4bhwme0kvLzajS5lbpmCHm08kVpjwDbDYiH7EdN41os
NSCaVBCyLcDZDll3xExmkyEXiZaVijH7LGN2XrTDqTfoakfGk6/kCbKclLD6pMSy
0aFqUioZT29VnQQDYxWSHVX/xq+ifK7Bi6aRNnK4H3xr6oswBs/6v1ecxorhR2r5
0RUteD50jAEVjaVcns9i2YA7tbDoGJRR8j5M8Ahmn3f6DliikgsbVdVm4WDPtoEo
N0AhIwtVTaPv7+wFo998uBm2UnsJ6/mrXiHrEAzmedk9PmU/maXJMgjPr3gTfKGk
tcP5y28VKQaMgJ/zsIK8GJITYzOk9v3vqy9WpjSO5h7o4l2818DwVHwNCOEh00+M
J6ig9o18B0go49PKA3+/s62Q9hSiBtc+3NyXwwZtb+9o6iVT77C82punrPROnwzu
DZHpxvzxma9HPDebhjNhnQL8mBEw5pdt/+jQi+uJi9/p2kYduKBUqBbOwFNBgYPS
jCKt+1a/476wavLYKokOvMtFR5uu6THyFeNEkw6F4s2NEdi0FwzUk20Ju8gwUwlQ
bmitsen2kA5PPYFlx6lJcbX+rod9HW1JJQ+GpFjzzIleftZzbA5ehDnAzLSr6GL0
tsV2JzJpAbAJNqd5yO/x
=r/3h
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-2491-1417131619-0001-2--
