Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYKYUrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 15:47:21 -0500
Subject: Re: RFC Patch: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200811252131.30161.hrogge@googlemail.com> (sfid-20081125_213139_680674_17E7A0BB)
References: <200811252131.30161.hrogge@googlemail.com>
	 (sfid-20081125_213139_680674_17E7A0BB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SqJMz9qwpnTQhKf6w7cw"
Date: Tue, 25 Nov 2008 21:47:17 +0100
Message-Id: <1227646037.4613.46.camel@johannes.berg> (sfid-20081125_214725_256455_1E0F3C70)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SqJMz9qwpnTQhKf6w7cw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-25 at 21:31 +0100, Henning Rogge wrote:


> +	NL80211_STA_INFO_SIGNAL,
> +	NL80211_STA_INFO_NOISE,
> +	NL80211_STA_INFO_QUAL,

Sorry, no, this WEXT junk is just too undefined to put it into nl80211.

johannes

--=-SqJMz9qwpnTQhKf6w7cw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLGRSAAoJEKVg1VMiehFYbVMP+wcsQRQoQniZE+KzbIn80K3C
vnZa4TrnLIaImB4ew2ceO0IigThA/rVrwpbBaMzRITewDLvicCSIWALihxx7VhqT
CuxCCbeD8/meIg9TzC1euJ3+M3AciQ9dS4h9kG8/2+Cm/pa40+Ry5aa2JbFWTOH2
/qIGTYXp2MqK7v0G5klIdqOJaoq3jM6WU0gV3plY3iDI6YKDWWRuUSCrennxtJag
lfua6MQSnt1jIbrEhMYAMZcUF7dktJTwnVv9AZw+/HFmB/rh+j4lxvW65rBavJw3
JPnQi09HZ9pu7tTEPQWcfwZ2ghu4WFbaPTcY7vkaG3SmJoas49eumKbrmiAO9Wz4
MMsKlyjAwwUCokpAlrnmaks0EB7bcXZebAh4YltpULwtQeatg3bTHssA+2t+NhJ6
7ucidmWAvs3IzwT+fYbxmyMriqBdGA2n/MwiFjiLbeljJ8wSHHpro/mLxzlPZyge
GDmnXT5EnEcXv8RZtw7ZYfCj+xhouKvtzL3w2BeJogB6na1YPyVeJO6NsFTyC7/7
cE4PbupJ/JUxgqJziLMKrsoB7PIpe/wWXryrMpiHioY4ifx4NQRlcgmezwthw0QL
PK2neSz6M9Tik2tFVji3qrnq9t883GG4SZmQlGpsFe3rV7f6Ih4zvy+XjWbZtt5E
vTsZDmK2ipDaCsizcETT
=FA3I
-----END PGP SIGNATURE-----

--=-SqJMz9qwpnTQhKf6w7cw--

