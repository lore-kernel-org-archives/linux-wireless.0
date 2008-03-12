Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYCLOvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:51:10 -0400
Subject: Re: Q) after loading rt2x00 driver, can't set 'ifconfig'
From: Johannes Berg <johannes@sipsolutions.net>
To: cs010101@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <001d01c883e2$ddf6b680$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080312_014626_399185_C6728475)
References: <001d01c883e2$ddf6b680$3b0aa8c0@39fb6b6b6f434b3>
	 (sfid-20080312_014626_399185_C6728475)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BoOssVs176MXQgo8xuLG"
Date: Wed, 12 Mar 2008 15:50:50 +0100
Message-Id: <1205333450.15910.3.camel@johannes.berg> (sfid-20080312_145115_478487_17756F04)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BoOssVs176MXQgo8xuLG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> iwconfig wlan3 essid kkk mode ad-hoc channel 161 rate 18Mb
                           ^^^^^^^^^^^

> when setting 'ifconfig wlan3 100.100.100.100', dmesg is like follwings:

> phy0 -> rt2x00mac_add_interface: Error - rt2x00 does not support Adhoc or
> Master mode

Can hardly be more explicit, can it?

johannes

--=-BoOssVs176MXQgo8xuLG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9ftyaVg1VMiehFYAQLQEQ//YtMXDYLyu4DCsoKbLg8B7HfDcROXKKqv
4RtijBcmOGBVGArHXYNHcxlIbXVBqOSHkqnWbudRlStDGA+EbddMFqReQNeBVKgm
RbwRdxZT8Tl9lJ9Ajtfv8QBB+FhNyp26KkeV9TWzlUTTG7zpfKWVM4nNAenx2mY9
eSpt/hHTZEnzy5G13LnGBSjZu0eNtFhK/df4rJ1IPo+CyRRrwcBFvo3QeHk6fGYF
mR6iA2gy/Qlo6JEa36qK5sBAyto6lYhQHQM39c27dCNEVwHHu1lgmmoCYXudskl2
9JHW4OO7AEuseLkWFb2dDLk/+JXlKSr7qX1FVYGIYjsmco4H5PJUP3kCgzKVkO7A
7iD3XgWCgDxObG1ZsCm+rpuUi4vGtqzt6kBfMtDhgWmWXm7hZJresCldCARkOeWX
wkfaDjGuO6znLK4dIhv/P2U6To/E5bKkPk5z063/8arMNpoAwGOqSKecKJCkw0kZ
D5oVnRg4RwsWpDvvGR8r1FI6uXSTSgCF4eR4vEupfTPm9F0P8vlbf3wQQPud/k7n
4Cclrco/Ngwc/ka6s5WQN95LHJEOy2Pk6lMDtp1Oy2B6ihZs9A+GPdUEkhhwUHR8
+okn0vyyPbRYT/kjVCVCfCR5DT1WZ/aYOr6V+/J81Uq385/KUpEewcMqaywkWtEi
mxoZFriaGVU=
=Mprb
-----END PGP SIGNATURE-----

--=-BoOssVs176MXQgo8xuLG--

