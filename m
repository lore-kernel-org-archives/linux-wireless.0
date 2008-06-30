Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYF3Pm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 11:42:56 -0400
Subject: Re: [PATCH] p54: Add quality output to iwlist and iwconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net> (sfid-20080630_173834_531803_0FC8E191)
References: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net>
	 (sfid-20080630_173834_531803_0FC8E191)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zdjsuJxDIVC6T6p2UO8b"
Date: Mon, 30 Jun 2008 17:42:10 +0200
Message-Id: <1214840530.5507.52.camel@johannes.berg> (sfid-20080630_174259_747692_687CCB74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zdjsuJxDIVC6T6p2UO8b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-30 at 10:39 -0500, Larry.Finger@lwfinger.net wrote:
> The p54 driver family reports a quality of 0 in iwconfig and iwlist
> output. This patch calculates a quality number as a percentage of the
> rssi to the maximum signal of 127 reported as the maximum signal.

Unrelated, do you have a p54 card? Does it work? I wasn't sure whether
the tx-info sbk->cb change broke it or not after I fixed up some things
there.

johannes

--=-zdjsuJxDIVC6T6p2UO8b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaP7OAAoJEKVg1VMiehFYYBQP/AnmzieVG+8MqUuEh45kMGt1
sSzA1dPgM3irFzNzwLTNpoSWRCIbHzjT6nLk2ibJ92cirn9Q19jP+7m4xIwdHdvQ
Yz0Selw5jHUo27PwcPukHFa9HBilYUNNi8TZ9em89byXQLp05V/lcLyWrzb7r0R8
rElguXTic3qx/ZuW9sLylGPRaLX1KQF2M587uznPS4SuYndy+Va62PQ7LkH2Y9Kl
D841FFb4TGD+VxAxsOuEbxCBRHSTU4MAGQjMWXz9+Yn2yPQoX6nnDoUgJ7tBRj6E
1k5CBWCTwhllHcXpu3w0bQOMxEfSbOAR6iutzMHqvkniFf+l3JJhtHNCH9VjUBVP
ngGtnxH1ItV7P5thok9UsjmxCFgTJ9c3TDjKj2NQdwAag2wz+JEgX9zHc6vTZDL7
kB/D12NuldSpJ67aq8MNIccHn2C0bN9qBV3YnuHMbcHWMlQsBNjmbmIZ2HN5ebFM
xHRX7UyPswKJhuRshVJnMKPPDGm6DWBjfVNeRlFOmitbyKQxhT5g91ypRf6YQzHo
6sWXEHrJnQ3435pMYkCtfG90H7nWktym4EJwRWphRldIKTCEdqHRX3n0/+0vNDF/
6J7CNcbCXq9PX4M02ZgpeqRjiiFfW8ScK3A/DoRhUcUWxtwoKyaFrmUJndPRMt6L
zW9DeHfQX1H+R7EJBHkF
=4/YO
-----END PGP SIGNATURE-----

--=-zdjsuJxDIVC6T6p2UO8b--

