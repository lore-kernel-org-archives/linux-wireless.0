Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760856AbZDBSaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:30:00 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D5018E.6050001@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local>  <49D5018E.6050001@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-023mvZoM2MgWltYsL6Yb"
Date: Thu, 02 Apr 2009 20:29:27 +0200
Message-Id: <1238696967.6137.5.camel@johannes.local> (sfid-20090402_203007_341932_4AD38815)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-023mvZoM2MgWltYsL6Yb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 13:18 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> > On my system that's exactly what it looks like with my patch (well,
> > rfkill4 right now). I'm stumped. What kernel are you running?
>=20
> The problem is the statement #define TRIG_NAME_MAX 50 in include/linux/le=
ds.h.
> When I make it 60, then the trigger file contains "none ide-disk ADP1-onl=
ine
> BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy0tx phy0assoc phy=
0radio
> [rfkill0]" as expected.

Also, if increasing that helps, does it also work then? I mean, does the
LED get turned on/off?

johannes

--=-023mvZoM2MgWltYsL6Yb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1QQEAAoJEKVg1VMiehFYO7MQAJTfsbFrT1Hc2sxBGvOdVz/F
ZXgO4FNnETzFpkqJJySp1gMM7LClLC6gMkmYzxY1OyWjmfQWoTTmpKAzgtqmVQGX
Lv22lJulUrZ6fTsTKOGYc3Gr5hZa14vQc3BUc0YeB72GxVnvB5wnHXlTrjzDXBoH
DWzn8aCu8hrtw15OTOEuMAgobJUHvj57rpg5atJDDTyVvAhyKK2A5ZWGUwxRPtze
eh91YxpEoS4JmiV9Jb/AvbNq0m8Pg0bNDPwVJL0Y/HEry5X5Y5UmgYNrG6TJBc0N
1uTrg5s/+C+qzLYS55f8R6qlOcvqQ15OZ2wV1MGJT3CIwcy67hN5NgxVximAgTem
T3NecRji171+OcYGBn9zhoqzUTur4TV+xHJcWI053u/kXWZumyF31diOaGN3Qibj
Fy9RSXfQkEgiarP57mTs3OuBhvDltOd2ChQ+fmqnXhbwmzFwHuk4mwnDMogSq+9K
dQ9AMvPQ10e0qEeccs2nNAw72fb6Vxw5+61VNGR8MLL5jpBPcTSM+08zY8pnMUXg
zJeXDE89nmVlk4pBKFMo8zYr6lpzUgP9x0Agwq6Y+Ls2JM0o8vFG4hnae8MIkY0k
oX8UlnkknEYc78PyRlrz920o6c2s0i7ipPiMCvwEsciwU1LgZVKwnbmri3uEignR
knEanNoWET5wo6osCXl7
=lYBn
-----END PGP SIGNATURE-----

--=-023mvZoM2MgWltYsL6Yb--

