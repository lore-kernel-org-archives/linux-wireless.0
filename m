Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZDVMPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 08:15:30 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1240401205.3313.3.camel@localhost.localdomain>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
	 <1240247636.5260.11.camel@localhost.localdomain>
	 <1240248008.4632.10.camel@johannes.local>
	 <1240248385.5260.15.camel@localhost.localdomain>
	 (sfid-20090420_192718_984250_38AB6869)  <1240248773.4632.13.camel@johannes.local>
	 <1240343775.3327.3.camel@localhost.localdomain>
	 <1240348792.17388.46.camel@johannes.local>
	 <1240385542.3404.5.camel@localhost.localdomain>
	 <1240391029.20308.1.camel@johannes.local>
	 <1240391541.10072.2.camel@localhost.localdomain>
	 <1240393523.21978.1.camel@johannes.local>
	 <1240399028.10072.14.camel@localhost.localdomain>
	 <1240401205.3313.3.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FyWd7nilbZ6svqOVEE4W"
Date: Wed, 22 Apr 2009 14:14:57 +0200
Message-Id: <1240402497.21978.12.camel@johannes.local> (sfid-20090422_141534_153467_78700ED6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FyWd7nilbZ6svqOVEE4W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > > I just don't see anything in the kernel that would ever set the
> > > interface down, as indicated there.
>=20
> so I have installed the latest wireless-testing kernel now.
>=20
> CTRL-EVENT-SCAN-RESULTS=20
> Trying to authenticate with 00:1f:f3:fa:58:59 (SSID=3D'HON Circle' freq=
=3D2452 MHz)
> Trying to associate with 00:1f:f3:fa:58:59 (SSID=3D'HON Circle' freq=3D24=
52 MHz)
> Could not read SSID from driver.
> WPA: No SSID info found (msg 1 of 4).
> Associated with 00:1f:f3:fa:58:59
> WPA: Key negotiation completed with 00:1f:f3:fa:58:59 [PTK=3DCCMP GTK=3DC=
CMP]
> CTRL-EVENT-CONNECTED - Connection to 00:1f:f3:fa:58:59 completed (auth) [=
id=3D1 id_str=3D]
>=20
> <starting dhclient wlan0 now>
>=20
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> l2_packet_receive - recvfrom: Network is down

I still don't understand this. Is the AP disconnecting you? Are you
running NM on the side?

johannes

--=-FyWd7nilbZ6svqOVEE4W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7wo+AAoJEKVg1VMiehFYRK8P/10zl02e2XnofHyMUqU4vA/y
NdgTqm6gRx/FiXKKfjJzBp5hqJHe7dzuLYk39Dh0di0UnfY52aJsT7I5Hk+/cSX1
V99tuolFOPqMap/5Zaha10Chl/R8DIDqsEgqc9nBcwfZ1/gzEof1s3Qq+eyExbwg
+ddrQBEsV5sC4GTdu0cmhSOrsno51fdDI9O7BxFx/hmniMro9pslTYDVR6pl34P2
yCOCAUXzp21rPow8U/erF1JcTUsxAukKfU6d6Uyt5TiYfQZP1ZGyKbkKgxzSmZIE
V30cJD66xzTGb9xyYc83ZTxQ0UJm9b57inwexiPmCb6Hq1uSd3cL/CYEH3MTtOjH
cC1Tf7arINDr3a2X/6dNh6+8f28xhxfym5mDMyvr0mknEMXzrEEuqGwKKTApGAYX
hWSTKEn4vfqW0DIJh7GhrY10VzqgULa9rlnhtdAxfY2U7xHz3N9NApK4CDPfkVFr
Hkh7UuMWVS/x2HvadlKtbRd80bqyii/BnCgEBdUmpwtP32im8Fn/ikn9wxSzke3c
TOlQK0/yb4NYHYawKP6gP1VqGIwdkdLAG55mKql26ukGU6LiOFdwF6yTwqLxCPpL
B0Sq+bk2iKokUeDWAqaDfKsoTBCymkY5k1Z1JZN0KyTmFDTLdavvp5KIhiRo+NVB
6IgFrt4p0v65YbR2DS9u
=ek1t
-----END PGP SIGNATURE-----

--=-FyWd7nilbZ6svqOVEE4W--

