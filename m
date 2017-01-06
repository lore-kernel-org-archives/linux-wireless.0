Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36498 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760484AbdAFIqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 03:46:22 -0500
Received: by mail-wm0-f41.google.com with SMTP id c85so16813419wmi.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 00:45:36 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: ath9k-devel@lists.ath9k.org,
        sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: QCA Ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        "freebsd-wireless@freebsd.org" <freebsd-wireless@freebsd.org>
Subject: Re: [ath9k-devel] 802.11k, 802.11v and 802.11r support in QCA9592-AR1B
Date: Fri, 06 Jan 2017 09:45:15 +0100
Message-ID: <2946022.B9kIklMXmS@bentobox> (sfid-20170106_094812_178060_23E83E4A)
In-Reply-To: <587211005.1320200.1483690502965@mail.yahoo.com>
References: <587211005.1320200.1483690502965.ref@mail.yahoo.com> <587211005.1320200.1483690502965@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart36189806.stnyiZrjXa"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart36189806.stnyiZrjXa
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Freitag, 6. Januar 2017 08:15:02 CET sandeep suresh wrote:
>   Dear Experts,We are using  QCA9592-AR1B ( WPEA-252NI ) in one of our products and it supports 802.11bgn. There is a requirement to support the following standards:-802.11k802.11v and802.11r.Do we have the driver patches to support these standards? Please let me know how to go about this.Thanks & regardsSandeep Suresh.

Most of the stuff you ask here is already part of the current hostapd and has
nearly nothing to do with ath9k.

There are some things in 802.11v which would require driver support but I am
guessing that you are not actually requiring these parts of the kitchen sink
802.11 amendment. Your list of amendments look more like you want to support
some features to allow better roaming for Apple (and similar) devices.
Spoiler: They also don't support most of WNM (regardless of what Cisco tells
you).

The other thing which comes to my mind which is driver specific in 802.11v
would be BSS Max idle period management - but this is supported by mac80211
since ages.

I would recommend to get in contact with the hostapd people for more details.

Kind regards,
	Sven
--nextPart36189806.stnyiZrjXa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlhvWRsACgkQXYcKB8Em
e0bxmRAA2ZfQ5r6E+FWdicoT6AaSP5Ay8Y9jrjHn70XcI6rYPkd+YBWrN+ksyMaa
L27+VcvEB6guaKsuR3p83F/BclIlb4vnqkMd8PwbVzPiBOvLXf3988ux8FHRBRly
+eLtzx5cTAQIaH1atYqAemZvJWEDX6t5oaKaaA0zUy9xwKSfnLFPbjapse8Ln8JR
P4s8O2AkqTtHBVtJjUJtTVc0ANMe3R2AbsHTLG8R0gsc8EZdioIYIeqZGqSs7wW2
j8cNvLuAzuVRvQEWK/4VM/jxvxA7qC3ZLEGnPXM8H8mygmmIv2j8kdqQUZNMVQ0Q
rOOJ1Od2baoFr07Ip3Uv7FeyIrCEiOwycoVqmDmxtdKWO841X/PF5qS4O2EVEVfw
yYg+thtX/B90SAIOcoX3x4pMAOtbkI7X1cTxDDvqKQFwQVFdOmGs9fjQLSzcsLKm
r2c+n/1Qid/smkHNielDslhO/dYSuyjK2VqyiPK1Q0gQVjg7SMY8RxYxWmAcjTVc
9XTnYpQu/QLlHJ2lPc4ukIlfUF0pDn/xeRSQ/Ra4ef8ioJ4MAPeKBopJHoj9WsKE
udRbuKTTD5BgxiaHF0gfFZhb6Y8Mexsxz/KuPhkuh5wbFbHxw9MqIthuX/GegGp8
v2Y5hV/qkO6VDySu5AE7Sb0tXDXY1+Tvk2qW4wyTrirth0KyTtw=
=AHTT
-----END PGP SIGNATURE-----

--nextPart36189806.stnyiZrjXa--
