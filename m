Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackbox.passys.nl ([80.126.219.73]:35861 "EHLO mail.passys.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759245AbXEPV1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 17:27:20 -0400
Received: from [192.168.0.102] (a6008.upc-a.chello.nl [62.163.6.8])
	by mail.passys.nl (Postfix) with ESMTP id 2263328048
	for <linux-wireless@vger.kernel.org>; Wed, 16 May 2007 23:07:47 +0200 (CEST)
Message-ID: <464B72F3.5090709@passys.nl>
Date: Wed, 16 May 2007 23:09:07 +0200
From: Hendrik-Jan Heins <hjh@passys.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Hermes II driver
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBCB408D532055DE1B33F88A4"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBCB408D532055DE1B33F88A4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Dear all,

I'm not sending this mail because I am the author of the following work.
I am simply the person that tried to find out, who could benefit from
this driver and rework it.

Let me first introduce myself. My name is Hendrik-Jan Heins, I am the
maintainer of http://linux-wless.passys.nl

A couple of days ago I was approached by someone who modded the Agere
driver to also work with the HermesII chipset. One of the things he
changed, was the possibility to add firmware to the driver.
The name of this person is Jan Pieter, and his e-mail address is:
pptp@NOSPAM.jp.dhs.org (remove the NOSPAM)
He published his driver at:http://www.xs4all.nl/~pptp/agere/wlags49.tar.b=
z2

Here's the rest of what he sent me about the driver:

Before April 27 2007, there was no Linux 2.6.* driver for the Speedtouch
110 PCMCIA wireless card. It does NOT work with the orinoco driver
because it needs it's firmware to be uploaded to the device on
initialization. The orinoco driver does not do that. There was a working
driver source on the Agere site, but that is for 2.4 kernels only. I
found a 2.6 patch for that source, but it's HermesI only. The Speedtouch
110 is HermesII. So I gave it a try and made it work for HermesII! Here
it is.

As I understood, his health is not very good, but I guess you can always
contact him about his modifications.

I hope this helps the effort to get more cards supported in Linux.

cheers,

Hendrik-Jan Heins

--=20
Publieke GnuPG sleutel beschikbaar op de volgende keyserver: pgpkeys.mit.=
edu
Public GnuPG key available at keyserver pgpkeys.mit.edu



--------------enigBCB408D532055DE1B33F88A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGS3LzlpzDGKCS86sRAgM5AJ4h94CPp88p7wICheqE7yMyyU0xigCfew94
94a21V4phR22Hz9XDWwdBFM=
=WvtZ
-----END PGP SIGNATURE-----

--------------enigBCB408D532055DE1B33F88A4--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
