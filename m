Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYLRVZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:25:55 -0500
Subject: Re: [PATCH v5 3/3] mac80211: implement dynamic power save
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081218211712.6842.98402.stgit@tikku> (sfid-20081218_221727_688611_C7676A25)
References: <20081218211532.6842.88104.stgit@tikku>
	 <20081218211712.6842.98402.stgit@tikku>
	 (sfid-20081218_221727_688611_C7676A25)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/3RVJ3xhFpQeicP7afjH"
Date: Thu, 18 Dec 2008 22:25:55 +0100
Message-Id: <1229635555.3601.49.camel@johannes.berg> (sfid-20081218_222600_750891_E7FAF47F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/3RVJ3xhFpQeicP7afjH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 23:17 +0200, Kalle Valo wrote:
> This patch implements dynamic power save for mac80211. Basically it
> means enabling power save mode after an idle period. Implementing it
> dynamically gives a good compromise of low power consumption and low
> latency. Some hardware have support for this in firmware, but some
> require the host to do it.
>=20
> The dynamic power save is implemented by adding an timeout to
> ieee80211_subif_start_xmit(). The timeout can be enabled from userspace
> with Wireless Extensions. For example, the command below enables the
> dynamic power save and sets the time timeout to 500 ms:
>=20
> iwconfig wlan0 power timeout 500m
>=20
> Power save now only works with devices which handle power save in firmwar=
e.
> It's also disabled by default and the heuristics when and how to enable i=
s
> considered as a policy decision and will be left for the userspace to han=
dle.
> In case the firmware has support for this, drivers can disable this featu=
re
> with IEEE80211_HW_NO_STACK_DYNAMIC_PS.
>=20
> Big thanks to Johannes Berg for the help with the design and code.
>=20
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>

Looks good to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

--=-/3RVJ3xhFpQeicP7afjH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJSr/cAAoJEKVg1VMiehFYXJwP/jAH93OckFIov/t7WiLD4h4Y
pOYSi1aT1OcqqALwHFswVuUSheWul/fNrjGZO/Y2LfjL7/53pR2bl6Z61Lb2FYjx
EmL72Ow6CGZD+Y0ei8qydiqNjiB7eHQO8ZYE9BR9Kj7y/yoMqNn73ZXDjUeXu3N1
tTYndTkb1l15ScfJvPeFZWXkORAvuHQxbcUUYv32WjUXaVO8yHfyDisQszQcqlR1
Keb7qsaC2pu4U7Vf/pVAnkZuuw6uaymlfB7MRLHaUf/c9gyJoLsPHZlIAw/SgSfb
IcCHBBMLKy3SfJ5m7k/hj9homh55kJp4fwtBtmNIYtAYj3f6Z8cO8ktqTzKEPLyo
tO8JSC5atEuFBzJGlP/Fw8r+PRu8X0PrRAaQg6QoRMFGN2DMN2F/N2OBVjTNnuVQ
sf0HBOvXr/+eCXEqY15J9x9Hsj1VatknfWDnmFPkjgLN8R4cv5w2DJ4yi0zNZ6B8
+GlhhvSL1WSwrFzYc7ApP4YbHxJZR4DI7G3L5XXK1ExjzxeIfMMnEf1yGImFtxJf
Ez4niXVeURZkUXvnAwDhQTQogVwiRwRLc0vAwDI2ZhM1RNkw8uVmpTIoQJq5kc2T
mYyKfCKPaAfg3qzw5j6cCs08OfXZCFLDGha0zu3svLLpNM/u9EqUzTwR2+AwlwRX
X53woDisZOu6x3leEOrS
=4baT
-----END PGP SIGNATURE-----

--=-/3RVJ3xhFpQeicP7afjH--

