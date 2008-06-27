Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYF0GgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 02:36:07 -0400
Subject: Re: mac80211: Question about beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Iwo Mergler <iwo@call-direct.com.au>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48648130.40402@call-direct.com.au> (sfid-20080627_080216_985183_62D87AE6)
References: <48648130.40402@call-direct.com.au>
	 (sfid-20080627_080216_985183_62D87AE6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u8JEhJZNfwqgX7Ez6x+A"
Date: Fri, 27 Jun 2008 08:35:23 +0200
Message-Id: <1214548523.3783.46.camel@johannes.berg> (sfid-20080627_083612_105724_1853440D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u8JEhJZNfwqgX7Ez6x+A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-27 at 15:57 +1000, Iwo Mergler wrote:
> Hi,
>=20
> I'm trying to debug the AP mode of the rt73usb driver. It works OK,
> as far as I can tell, but there are no beacons in the air. Not even garbl=
ed
> packets. The AP is happy to respond to SSID broadcast requests though.
>=20
> Now, when starting hostapd, the driver gets three rt73usb_beacon_update()
> calls (struct ieee80211_ops ->beacon_update()). The SKBs passed in are
> identical IEEE802.11 beacon packets, with the sequence numbers 0, 1 and 2=
.
>=20
> I believe the hardware is supposed to be auto-beaconing.
>=20
> Here is the question: why three calls? I would have expected a single=20
> call for
> such a device.

That's because hostapd sets various parameters and the beacon changes
every time. Don't worry about it.

johannes

--=-u8JEhJZNfwqgX7Ez6x+A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZIonAAoJEKVg1VMiehFYIvgP/AnkDvSNg5sYGLgOg8ZduEg2
CZ21iZp17dWcrEvLsk40BeW9eFBZOcopvGRtXIgHIj/QiPgU/Yr+W+drDz8L9e80
7Q88Rl8MAgUW5G3COOoOHhIikAuyiNzCqo550vIhA2b86i1h3UTHo4jI+n1Gi7CW
uEFY4Hijae0uuMF0pxJK7Th3xFrlEqdJ76IIpluFgL3wtt+JNtkHOte025s40p0O
p9gHz/Csx+5RY15RZ8IZyJMU24Fa0nZIOdtxxM+mLd9f1zW90MjDneV2ie6hWpeB
dhaA81Nvv59uElyVDJuC5B6e1DSKGfJD9YIP0+zkEeRoAol3vCvbQGPuSVwzCwXk
38t+fX0BjJiThlRY7aHSpOzxHLtE1n8fXxI1zEkTo4v+Lg0sW8xrpy+JmRN64A77
YlrcwnG3Yrmy1J49QHsUBrLfF5MQw7ip6KKiVP5FJWgpVMH4hupsU58bX8vQcH/c
ly5CHFZdS+jpMZ9ylkml5z9WeCsuOGupwkuIDgvG8IlVVrjQTdun5P1ItHROAiom
pHrkAfdv3ejrUQYdJKVCLGZVl4NFppqIFd+M38vZjaXsF+Jh9ntpY71RFzIrEl3S
fZRuDdnVdoAFB+oJuWL98P3Ds9NPHkCCXQ22VNMOeOClTi1AK7C0Jq7pP5qJoX4n
l+ex8IR/eWdjjtIp1fVC
=6ioi
-----END PGP SIGNATURE-----

--=-u8JEhJZNfwqgX7Ez6x+A--

