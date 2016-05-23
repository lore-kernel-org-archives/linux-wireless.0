Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.glycos.org ([178.62.217.237]:38405 "EHLO mail.glycos.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbcEWTP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 15:15:28 -0400
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Ruben De Smet <ruben.de.smet@rubdos.be>
Subject: Intel wifi card + TP-LINK AC1200 rev 1.2 = ???
Message-ID: <59296a1e-7083-a131-ec7c-e1833d4b3c38@rubdos.be> (sfid-20160523_211532_339241_534FCC83)
Date: Mon, 23 May 2016 21:08:19 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="EtCtVdWj3rL7MvtsnFp4L2W0tpcjLXrJi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--EtCtVdWj3rL7MvtsnFp4L2W0tpcjLXrJi
Content-Type: multipart/mixed; boundary="ItfOlFa12nJ5vMFm4kVeTNDVeUE5AaNOs"
From: Ruben De Smet <ruben.de.smet@rubdos.be>
To: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <59296a1e-7083-a131-ec7c-e1833d4b3c38@rubdos.be>
Subject: Intel wifi card + TP-LINK AC1200 rev 1.2 = ???

--ItfOlFa12nJ5vMFm4kVeTNDVeUE5AaNOs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

My specs:
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Wireless Access Point:
----------------------
TP-LINK AC1200 rev1.2

PC1 (my laptop)
---

- Lenovo Thinkpad X250
- 03:00.0 Network controller: Intel Corporation Wireless 7265 (rev 59)
- Arch Linux (4.6.0-rc6-mainline, I need to update)
- Confirm the bug under 4.5

PC2 (brother's laptop)
---
Acer subnotebook
Intel 7250 (iirc)
Ubuntu 14.04 stock kernel

PC3 (htpc)
---
Zotac HTPC (BI323)
01:00.0 Network controller: Intel Corporation Wireless 3160 (rev 83)
Fedora 23 64 bit with boot-to-Kodi


Newly Ordered PC (cannot confirm yet, could possibly test windows):
----------------
Lenovo Thinkpad T450
Intel 7/8250? Don't know yet, but I know it's Intel again.
Will run Ubuntu 16.04 or 14.04. Not sure yet


They all have in common:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
- Linux, Intel wifi card and TP-LINK Archer AC router AC1200 rev 1.2.


The problem(s?):
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

When near the TP-LINK access point, NetworkManager needs reconfirmation
of password. On the htpc, this means loggin in on the console, `nmtui`,
activate connection.

On the computers with DE, this means a dialog box opens asking for a
password, which is already filed. Pressing enter connects to the network.=


My laptop, as my brother's, tend to lose the connection now and then.
When I checked `dmesg`, it said to be "lowering the transmission power
as requested by the accesspoint by -xdB" (not those exact words, I can
retrigger the exact error though), before losing the connection some
seconds later.

Other tested (working) configurations:
- TP-LINK Archer C2 (which is without AC iirc)
- Good ol' Linksys WRT
- eduroam at my uni
- any other wifi point I've ever had access to.
- Tested another PC with a lot older (Intel) WiFi card (with AC): same
issue.

Not tested:
- Windows (don't have any Windows pc with those cards near me atm)

I see two options here:
- TP-LINK bug
- Intel iwlwifi bug

Please advice on what I should test, which logs to send, ...

Thank you for reading this WOT!

Ruben De Smet


--ItfOlFa12nJ5vMFm4kVeTNDVeUE5AaNOs--

--EtCtVdWj3rL7MvtsnFp4L2W0tpcjLXrJi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXQ1UnAAoJEPgmWogSE9wQ6ygH/3kgfjSG/r87vmTq3/H8Gv2k
OoQl4R2hDm1e6dQwX9mNlQZSX7hQgDwriqRAmGo1Fiifd1w54x5fTQjCFYeyswWM
VCKyY87H5TkSLBUycB0tZVyEjkneBAVHsfE8/uLsta7pHG2HSCEQzB3TZfy38u+g
MbRX0J9vLQGO9vaAyPYuoemgFAtevzYWZfrfCTxiSJ8ZuXvfY/NzFahGHscJeDG+
yWp1bYtoOfwYcEK845DiEVAFLaGHyHjgD8zzp1NuMoVh1l2tSicNWQ3Riq2mh2wZ
5cLSXdGVju0Pu6/2qpJL2h3208o4XNRCpA6ivFRo9R/OZmRG2nWXjZfMrODSO8U=
=+s6Y
-----END PGP SIGNATURE-----

--EtCtVdWj3rL7MvtsnFp4L2W0tpcjLXrJi--
