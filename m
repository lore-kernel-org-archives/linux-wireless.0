Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from czlug.icis.pcz.pl ([212.87.224.95]:42318 "EHLO
	czlug.icis.pcz.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbYEGOhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 10:37:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by czlug.icis.pcz.pl (Postfix) with ESMTP id 26FE8115D83
	for <linux-wireless@vger.kernel.org>; Wed,  7 May 2008 16:18:30 +0200 (CEST)
Received: from czlug.icis.pcz.pl ([127.0.0.1])
	by localhost (czlug.icis.pcz.pl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jbL8TGwbtj7I for <linux-wireless@vger.kernel.org>;
	Wed,  7 May 2008 16:18:29 +0200 (CEST)
Received: from [212.87.226.113] (unknown [212.87.226.113])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by czlug.icis.pcz.pl (Postfix) with ESMTP id 3E481115D80
	for <linux-wireless@vger.kernel.org>; Wed,  7 May 2008 16:18:29 +0200 (CEST)
Message-ID: <4821BA14.5080609@czlug.icis.pcz.pl> (sfid-20080507_163653_261328_0F3BE219)
Date: Wed, 07 May 2008 16:17:56 +0200
From: Daniel Kubiak <sor@czlug.icis.pcz.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Conflict with b44 ethernet module
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE8A535A17B52D7C9847B5425"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE8A535A17B52D7C9847B5425
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

I have problem with b44 driver after install compact-wireless=20
(2008-05-07). I can't load this module. In dmesg I can see:

[   86.398935] b44: disagrees about version of symbol ssb_device_is_enabl=
ed
[   86.398947] b44: Unknown symbol ssb_device_is_enabled
[   86.399064] b44: disagrees about version of symbol=20
ssb_pcicore_dev_irqvecs_enable
[   86.399069] b44: Unknown symbol ssb_pcicore_dev_irqvecs_enable
[   86.399277] b44: disagrees about version of symbol ssb_bus_may_powerdo=
wn
[   86.399282] b44: Unknown symbol ssb_bus_may_powerdown
[   86.399560] b44: disagrees about version of symbol ssb_pcihost_registe=
r
[   86.399565] b44: Unknown symbol ssb_pcihost_register
[   86.399997] b44: disagrees about version of symbol ssb_dma_set_mask
[   86.400002] b44: Unknown symbol ssb_dma_set_mask
[   86.400290] b44: disagrees about version of symbol ssb_device_enable
[   86.400295] b44: Unknown symbol ssb_device_enable
[   86.400720] b44: disagrees about version of symbol ssb_driver_unregist=
er
[   86.400726] b44: Unknown symbol ssb_driver_unregister
[   86.400984] b44: disagrees about version of symbol __ssb_driver_regist=
er
[   86.400990] b44: Unknown symbol __ssb_driver_register
[   86.401154] b44: disagrees about version of symbol ssb_bus_powerup
[   86.401159] b44: Unknown symbol ssb_bus_powerup
[   86.401570] b44: disagrees about version of symbol ssb_clockspeed
[   86.401575] b44: Unknown symbol ssb_clockspeed
[   86.401706] b44: disagrees about version of symbol ssb_dma_translation=

[   86.401725] b44: Unknown symbol ssb_dma_translation

Kernel version 2.6.24.7 (in all 2.6.24 series I have this problem. I=20
don't use 2.6.25 becouse it has ACPI bug).

Network controllers via lspci:
02:0e.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX=20
(rev 02)
10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG=20
Network Connection (rev 02)

Greetings
--=20
z powa=BFaniem
Daniel Kubiak

jid/e-mail: sor@czlug.icis.pcz.pl


--------------enigE8A535A17B52D7C9847B5425
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkghuhcACgkQjvzoNej1O7YZPwCgmXHOGIEPmMtYblAenAbzz9H+
PyEAn0NFHlUMfpGH0Cgdk+hMe03fAL96
=Rq4h
-----END PGP SIGNATURE-----

--------------enigE8A535A17B52D7C9847B5425--
