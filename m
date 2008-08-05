Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654AbYHEMXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 08:23:06 -0400
Subject: Re: iwl5000 oopses (was: iwl5000 oopses with Linus's tree)
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217937364.3603.37.camel@johannes.berg> (sfid-20080805_135654_962503_852A6EC4)
References: <1217937364.3603.37.camel@johannes.berg>
	 (sfid-20080805_135654_962503_852A6EC4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vVOIL/lWh5Ab9Ky4C/mi"
Date: Tue, 05 Aug 2008 14:22:07 +0200
Message-Id: <1217938927.3603.40.camel@johannes.berg> (sfid-20080805_142312_551539_9FE6C352)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vVOIL/lWh5Ab9Ky4C/mi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty

Same happens with a newer kernel, I merged together wireless-testing and
linux-2.6 (because powerpc won't build in -rc1) and get this:

[  126.826663] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27kds
[  126.826947] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[  126.828369] iwlagn: Detected Intel Wireless WiFi Link 5350AGN REV=3D0x24
[  126.848680] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[  127.014564] firmware: requesting iwlwifi-5000-1.ucode
[  127.170640] iwlagn: Error wrong command queue 43 command id 0x6B
[  127.170832] ------------[ cut here ]------------
[  127.170884] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1163!
[  127.170941] Oops: Exception in kernel mode, sig: 5 [#1]

johannes

--=-vVOIL/lWh5Ab9Ky4C/mi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImEXrAAoJEKVg1VMiehFYjHQP/2MShBk3KvLE7/XK0uPLM9VS
kSQGYiadHYGUelGZJxY3S3QjPbd8QBVDFn9uGagEZ5eep3eUVxGcMTdVofOt1mlJ
OsjVnj42xyxtG5c7RFJJYZ4ZSegGvCDIdlqROwlDKKvVhwnUx+hjHvJiguFxcCVf
+zm5XBjXa2VHAQE13p0ix41twoJDBRB0Kz5gSo8ZXZ46HKIpn5D3CJbxY6ni6RTT
tRS2R9OWJ7/FISFXi67S0tWorevFRlRxcYp6eMVvM/sbHRNB9MFMF4KlYHPhT6pb
+ZWlKeXIcue6r0vxmwW06i/7lOGSJyZBAA4cs05eg7XEvbS/UdKnCIums5aTSJ55
RFmlvyL0FNwpcYbNO+u4oMNE72FGsEUeDuUZ1famurd2nUh6x4D6jI6wkf91kd9R
EFcaZs/UXr66q9iguNMcDubfGCYuHgHK7WmLNcjYvJwQu63QsnKiYiI1hrKZdSTM
HlIOoyulcRwB7abrwQMzsd8ZzZLfTO5SYtth5KYWMTZv1b5UuCFk1fRziJzlQT1j
7zx7PZsWhgJiaRpinIkBp2+5QekR5ULhamfDkdQtoo4uBlanMQSp5l45Ec8H2+yv
ThS2lnY+/x+4PN+w1SDduDZoZH9I4TgFEyOKY2VWohEVyLxk8i2+euo4cMszYYco
YrnGvMZG4dU1LJf8oydm
=6VWo
-----END PGP SIGNATURE-----

--=-vVOIL/lWh5Ab9Ky4C/mi--

