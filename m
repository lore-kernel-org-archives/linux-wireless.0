Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.phnxsoft.com ([195.227.45.4]:3366 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYGaQeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 12:34:12 -0400
Message-ID: <4891E97C.1060302@imap.cc> (sfid-20080731_183416_954226_CB01AFB3)
Date: Thu, 31 Jul 2008 18:34:04 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
References: <4891D1B9.70703@imap.cc> (sfid-20080731_172256_192283_E18D72B2) <1217517915.10489.143.camel@johannes.berg>
In-Reply-To: <1217517915.10489.143.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig61847509C41E9CEC4F22E652"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig61847509C41E9CEC4F22E652
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Johannes Berg schrieb:
> On Thu, 2008-07-31 at 16:52 +0200, Tilman Schmidt wrote:
>> Commit 782e70c6fc2290a0395850e8e02583b8b62264d8, which went into
>> 2.6.25, broke AVM's closed-source driver for this device:
>>=20
>> ID 057c:62ff AVM GmbH WLAN USB v1.1 (cdrom mode)
>> ID 057c:6201 AVM GmbH WLAN USB v1.1
>>=20
>> Is there an open source alternative for that driver, or do systems
>> with that device have to stay with kernel 2.6.24?
>=20
> Never heard of any such driver, what chip does it contain?

I don't know. How can I find out?
(Preferably without cracking the thing open. ;-)

http://acx100.sourceforge.net/matrix.html claims "Chipset TNETW1450"
and "support should be quite easy" - but that entry is two years old
and the "Model" link doesn't work, so I'm not sure how far that can
be trusted.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig61847509C41E9CEC4F22E652
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIkel8Q3+did9BuFsRArDDAJ0VRaTu6xnJ6yjjglfX4Mlln3PlTwCferSs
+2CmLUSOFziwphRRDL+OBUM=
=KEyK
-----END PGP SIGNATURE-----

--------------enig61847509C41E9CEC4F22E652--
