Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.phnxsoft.com ([195.227.45.4]:2249 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbYGaPWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 11:22:52 -0400
Message-ID: <4891D1B9.70703@imap.cc> (sfid-20080731_172256_192283_E18D72B2)
Date: Thu, 31 Jul 2008 16:52:41 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig991F19F8A4B76AFBF9E2AF1D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig991F19F8A4B76AFBF9E2AF1D
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
2.6.25, broke AVM's closed-source driver for this device:

ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
ID 057c:6201 AVM GmbH WLAN USB v1.1

Is there an open source alternative for that driver, or do systems
with that device have to stay with kernel 2.6.24?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig991F19F8A4B76AFBF9E2AF1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIkdHCQ3+did9BuFsRAk9BAJ9EAfT2Y7wPD8uGV05C9OerG/RtNwCfeScu
6gDS58uOeRykWODwpBfmrb8=
=nbf7
-----END PGP SIGNATURE-----

--------------enig991F19F8A4B76AFBF9E2AF1D--
