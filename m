Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55975 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYIKRAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:00:32 -0400
Subject: Re: [RFC/RFT] mac80211: clean up rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1221133826.6986.24.camel@johannes.berg> (sfid-20080911_135116_233465_55795055)
References: <1221133826.6986.24.camel@johannes.berg>
	 (sfid-20080911_135116_233465_55795055)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b+jhdxy3W6pxIeO4kco9"
Date: Thu, 11 Sep 2008 18:59:55 +0200
Message-Id: <1221152395.6986.36.camel@johannes.berg> (sfid-20080911_190036_383871_B148E781)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b+jhdxy3W6pxIeO4kco9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I have tested on b43 (which should suffice for anything using the default
> rate control algorithm), but not on iwlwifi or ath9k, and iwlwifi fails t=
o
> work on my machine anyhow. I'll see if I can plug in my ath9k card into t=
he
> box and test it, but I'm fairly confident it should work fine.
>=20
> Any test reports appreciated, especially with iwconfig bitrate settings.

Alright, I've tested ath9k, but obviously not aggregation since that is
disabled anyway (and hence the code I commented out couldn't possibly
run on this kernel) and it works. Since there aren't really any
behaviour changes I haven't run any speed tests or anything, I guess I
should, but at least it doesn't crash or something :)

johannes

--=-b+jhdxy3W6pxIeO4kco9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyU6HAAoJEKVg1VMiehFYmuwP/Rt0FXqSo95r/Mf3XxXb0YfF
xWV7p/VPDlCSUcy1bcKij93c+VQb5pA5fGLykdekh+CI1Bfd7HXim2Oxk7gnvzuQ
1Ca8wif39TRYUH/Rm0lHVTUH8zQHuuNo8BQ6OA6+EEh+D+sjd38JZrRva48yEAvq
ktXlL2PyvSDcroWHDBK8ARiDN293/cesbQSNQ/s7eaBXeak85F/87MA35pXBrl1d
GV2pSztpVEbiPidEoBKhM7wqg6M5MP3y/FAe2fb48t2BsqvES5r6nbNj7sX3Qtwd
wJ3YGSi2oooWizMy2jblNNbWpDeEKN6HY6n9FAcja4bavjzX1C09ueESdUhqV82F
K7FHdd9pQbVnDs9XXIVsY6DXLjs7ASY+PhB4zpfN0GRARLHMjE5jSArAO5HOp10l
QnN8PnMd+IZZvk1PW4ry6Fz4zVdUTTui0YnsJJT6wV+SOvJEnpQVehH4IH7amH2G
9gRoxomT8E1MCACUuI+crRCuAl442MUcLwOvexT7F4kXhb4tSi5icnvCnagntZIb
rB7uXSkkS5iw4JOTqUNymTXThJbITW2yypGGcSC24eZ35KJNlUTQepgXC/EaConJ
EMFsEiupUs1ghcBxJSWaVGh3SaacztK43p3qd3hEtqlwad3YFd6G24KYKAJOHhYX
i2jiOqc9E7kYHHaUKQO7
=NJAY
-----END PGP SIGNATURE-----

--=-b+jhdxy3W6pxIeO4kco9--

