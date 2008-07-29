Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYG2GyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 02:54:06 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <200807290021.45400.herton@mandriva.com.br>
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZGsNBkNdOLzKjYvAHh6d"
Date: Tue, 29 Jul 2008 08:53:50 +0200
Message-Id: <1217314430.15381.11.camel@johannes.berg> (sfid-20080729_085412_024014_173D17E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZGsNBkNdOLzKjYvAHh6d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:

> [3] /sbin/iwconfig wlan0 power on

I don't think turning on power management (yes, this command is
completely misnamed, it turns on power _management_ not the power, you
may want "txpower auto") does anything on this chip, does it?

johannes

--=-ZGsNBkNdOLzKjYvAHh6d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjr56AAoJEKVg1VMiehFYiLYQAJlEHZIZ/ErIK2tQRNAdEVWY
hINdW8XJ6oR+2sHOD/w3pFlGDI4Nr391asDVLHQJRFUIqS6fbFYyHJIorz/uoW93
CiT3QBJ0c5NxVQwxLeKRQqM2wz3wkyX0R4uxv8DQK3ULh+v49peiQ1SISf/VDuT8
tBpilzj1Ew5VbhMr6m/THaa72vfLKQF7fAqNo7f/kPJON57EjaExWlT56K0cHBxP
6x6FQlFEL1Zj1ePCFqHoVdTwOg9mNELibwhM//tHHl4y1PVwyIEf4HTWQoS4jQBQ
imTN/5ebfH7dN5/l4X8TS+Ac3uN6Lb2+AxW2ZcEAlbUG55N613ow0zeyZ9kRBP5U
vghG+UvnylYn+4/zgDduyjkMXpyePqJGy/mIWvspY0TuBQ1e7xAML1Q4C7D2dpH5
BSpjm1nIq5Ka64QikNrk7JDVJoWfUeXTS+vK3iZMgcvay1H8+QeZ9iMT5SLC/0SM
++xPfSQEF94euemyewI6x82HiDsHu12I1tdGU2IGBTIWa69bf+kJjgw0A1PuuTzH
eR7TDm28Q2mF5+BnXoGXRX+VRjlwWCNmzU8ugz5KgLF5uMIXPhSmp/n1yY3jd2yU
1T9EeTuSpEsRDb3sjqHpFcMucFT8q/ZPgEFnuOO22QdWaK+6x5SQp7zHR+0AUj3+
VuUKmrKi4YwHnaTQhE2w
=MgkA
-----END PGP SIGNATURE-----

--=-ZGsNBkNdOLzKjYvAHh6d--

