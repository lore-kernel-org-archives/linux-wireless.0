Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49582 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYBKMZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:25:52 -0500
Subject: Re: [PATCH] mac80211: Fix initial hardware configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200802101416.52482.mb@bu3sch.de>
References: <200802101416.52482.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r8hLvPspKDF0MPMwFJkS"
Date: Mon, 11 Feb 2008 13:25:45 +0100
Message-Id: <1202732745.11481.72.camel@johannes.berg> (sfid-20080211_122555_343517_951317C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r8hLvPspKDF0MPMwFJkS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-02-10 at 14:16 +0100, Michael Buesch wrote:
> On the initial device-open we need to defer the hardware reconfiguration
> after we incremented the open_count, because the hw_config checks this fl=
ag
> and won't call the lowlevel driver in case it is zero.

Good catch.

> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-r8hLvPspKDF0MPMwFJkS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7A+yKVg1VMiehFYAQLnLRAAwzXE9yCp4xxB1NWEDJhpZhhAHT2QqW0y
iNrS3hHDFy/enwABReJGyjXCGoFLxv+Vfx0cjikkyrPDMHyySY764GMHKnzi6DEg
VXtEs5puGsQx8EkwahPTkOTkqwhqMYsRDKeanppblK137pGeX5gwWkltH2QD7pAo
wOQyM8L4qP1eTxYqT6xz63bTVWsGaDP/1Wt4HgHS/sE7/sDe63p29xiWMwXwuth5
KoAGv5bds6uMTwcVDkmn0jiHrRKBTTCUH96akeqaxOHyLvmDMzACTkZibTv+2Amv
ig/gpFfwEsatN3j2C6NnKwFjfBBkOc2aaVZZzA420QgiVadI48fORP2yYKl+pWn3
GBjKgN++VBi7P/JlwNCZnFY1jQMYVTYIFTGmjFQec1lyVs5uuMVjlWiOwHu+S7qp
poKqOMEnBAHbxlprcGm63MQ7VsWAdcj18o0ic5f23YCrh8xxeRGea3Cn4iT4aojR
k8GTqA4Djy2yHiRz/+j3wjRHvguqfeNDFfTJgsnc+q81etoKB2vR+ZJWSK2QX+be
4Uvqdfvph4NrjSBgU6PRtc9XYSqINZAsiCR971FlosHC/AEpddh88hmeuS2PKC9P
QVlbAsF4kx8HS8Y09Kr4f7wKrcfMyjGqVyMp+8W74U6h54//LUpWZ4fK8zKgYS2Y
/I24FPvgFy4=
=WfkR
-----END PGP SIGNATURE-----

--=-r8hLvPspKDF0MPMwFJkS--

