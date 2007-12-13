Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762690AbXLMRhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 12:37:05 -0500
Subject: Re: [FYI] hostapd with mac80211 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	hostap <hostap@shmoo.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com> (sfid-20071213_143532_407063_3AB777D4)
References: <1197512614.6558.224.camel@johannes.berg>
	 <1ba2fa240712130635n44838ac4s5bb606e5dc27fdeb@mail.gmail.com>
	 (sfid-20071213_143532_407063_3AB777D4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e4aild2MnwZ5p1LFRgRF"
Date: Thu, 13 Dec 2007 18:36:55 +0100
Message-Id: <1197567415.8313.33.camel@johannes.berg> (sfid-20071213_173717_081719_0E45FAA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e4aild2MnwZ5p1LFRgRF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> We have mostly configuration patches - (enhanced hostap_ioctls.h)  and
> some minor changes in hostapd flows that we would like to rebase over
> your changes to nl80211/mac80211 and hostap respectively. We can start
> with 11n Association flows patches.

Oh btw, will you be publishing driver updates to support AP mode in
iwlwifi? You must have them anyway if you're working on this and I'd
love have a second driver capable of AP mode in the kernel.

johannes

--=-e4aild2MnwZ5p1LFRgRF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2FttqVg1VMiehFYAQIgLhAAwJv0C+J4MsO4/du2jf1vyUz+iYF8CCXN
YtZMZJ0xJWtBO3tdHvbpnftDnB5dp/Iw0ax3OTykxm39eBBWyC858G6qFXYTgoUE
AyVaT6DtuBKRFnpKTnUSHFZJe+O0Drd4LMrrE89cSqY9xLIpPOTuy8nCiTdWzD+e
eRLA4Zq4OuOVx7l8uOBSfUffSCo40y8QbChxfOz0QoAWydqbLwMjHp/eE8wdJTnA
uRRJ4IcAoGV+gLL23bAvI3wkdXImUePghrQbu4mhYFPiRwrK0mz8i3C18pMpH0VO
5B/kPXI3qQD89P8oIRt+zqRc5QGLntL5jg8yoW3aQ5ck0t5r9/LmRGC3JgvJOoKC
zwRujlgm1cgEIrAfojcNUM8ntvCwn9DDgrCoiFUvc7Wfu4STG8BWuh0Xr++GqLbQ
uGR2MTL+LX4/6kbX2wkWtpHarErkZxm8ByrSLS6gNREHhdyATOxKkF4dEC2q+Rt2
Y4j0zZkYxqsPv4QcpQwRLTj7OlrDwqPjaRxN3viugAbMrUUXNgLq4hoKI74Pe1+w
kuR0ejH0B2vhTsFskuQX/L0YYrAK79G7s8IpL+vZPL622n6nPXGphT51a0n2n/lr
LAbKjvWMv9WH+MKdpCWw6iEp3cNeInsdH53/fI+EWE2IM3gwLOp9Zkbfcr4rFK07
oUrcY5alZjs=
=wl3o
-----END PGP SIGNATURE-----

--=-e4aild2MnwZ5p1LFRgRF--

