Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZBOQOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 11:14:04 -0500
Subject: Re: cfg80211_wext_siwmode() strange behaviour
From: Johannes Berg <johannes@sipsolutions.net>
To: Kevin Wilson <wkevils@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <55c333c0902150543m6bc92789n3d299cf26e65236@mail.gmail.com> (sfid-20090215_144331_648583_009E8672)
References: <55c333c0902150543m6bc92789n3d299cf26e65236@mail.gmail.com>
	 (sfid-20090215_144331_648583_009E8672)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HICbDZtrh6ZH9VuQtwtL"
Date: Sun, 15 Feb 2009 17:14:00 +0100
Message-Id: <1234714440.4219.72.camel@johannes.local> (sfid-20090215_171409_297299_AAA226C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HICbDZtrh6ZH9VuQtwtL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-15 at 15:43 +0200, Kevin Wilson wrote:
> I had tried to set an rt73usb-based nic to work in secondary mode
> (NL80211_IFTYPE_AP_VLAN)
> by "iwconfig wlan3 mode secondary". (according to "man iwconfig", this
> operation is supported).
>=20
> I get:
>=20
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan3 ; Invalid argument.

This is intentional, since you need hostapd.

johannes

--=-HICbDZtrh6ZH9VuQtwtL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmD9GAAoJEKVg1VMiehFYQ+4QAJaNQU4v1nPHnVARJ1SeXEHp
NWsEzTAzkEeKT/CG0ok7qmIJ8HRKUigE6DPulnCyp8TIDOzU4Te9+sc87qTxvB8Q
oqjQJo4xxdtSXrunhX7MLOkk2YaI3x2zN+dSX4YwxVoWwSgLl9eZqh0mSR7HVDOB
4pbngcGJfiTWZ651umLiKa7u1rhzLCDHxNpeqmBGuealKpuo/ay6fYD6sXZbrvWl
qBlgI7uzPdQvTfh0HuMlnw+aUgBsv+flMbDWIuTnWEixzrRLOmxSOMIsqSjtVlpt
/lNgHGY9Dnz8OQjJ5I/rW8jWO1/5YnmogCr+YCLX+kEEOGmN3O/nw+4l7oXLHepJ
VUrkJkCaLELo9hrdrnaRf7/5ldKI74URhOyw4DXy5Af43NaKOQiFqdch67wW0GLw
0kSieGvVLbPk8Ha4ZFFKTnpdmUDBLUoWPXlrs1W8YDW1L9WdQQWLkQpH5lxQudBh
UMP4WGz42URXN008dCoB/57KM+WZL5oWaEU8kUwtSJM9TcEWty8meh1BIrD7+kjc
ZU8QJSAywf8GywhTC2IgeN5E4czFXmKx+XTBdd75QfN2qHJDv/ct6lj9r0EFoaye
7gf1B6NzGf98x+STGaRCGV1mREVrfu8LcqDok/FQPmGk/fGeV1nWFc5J5nvUKals
W6lbKDYqe0L/CuCEb1lE
=gu3W
-----END PGP SIGNATURE-----

--=-HICbDZtrh6ZH9VuQtwtL--

