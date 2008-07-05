Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYGESnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 14:43:53 -0400
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error
	in	adhoc/master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Bryan Batten <BryanBatten@sbcglobal.net>, linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807052042.47008.IvDoorn@gmail.com> (sfid-20080705_203620_594861_13D70D58)
References: <200807051511.57995.IvDoorn@gmail.com>
	 <486FBE75.5040100@sbcglobal.net>  <200807052042.47008.IvDoorn@gmail.com>
	 (sfid-20080705_203620_594861_13D70D58)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3NMIvZOMFmH4hWKxpWhM"
Date: Sat, 05 Jul 2008 20:43:35 +0200
Message-Id: <1215283415.6848.14.camel@johannes.berg> (sfid-20080705_204357_125313_0DEE2EC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3NMIvZOMFmH4hWKxpWhM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hmm, in that case I have to fix something in the beacondone handler
> to prevent it requesting a beacon when mac80211 hasn't supplied anything
> yet..

I was working in this area... Can you take a quick look at this patch
and let me know what you think?
http://johannes.sipsolutions.net/patches/kernel/all/2008-07-05-18%3a42/mac8=
0211-beacon-revamp.patch

johannes

--=-3NMIvZOMFmH4hWKxpWhM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIb8DTAAoJEKVg1VMiehFYiP0P/2wMpS48ntOohXywyQ8BvolQ
bJ4+v+DSI3CLBws+XPZWQKTzhiiT4+wXQkZZu+xqPxBtB9o9duwCzYcUt9HSYVDH
RJ8cfJ5efizQrNHPNhtioYtMlGUKN76GoEnuv/STr+gGQZRqWgmwBH4BFkoBkd8x
48v79B7IhioJTg+SiPeIWjIXDcA1vRCDC4K+klLLRgcy2zr1Kz51gReZrpEF4iyr
Jnd4BU3ue/2D8bgJ3mgA8uBORKmvE4dWjEflCXAPkS+W4YaUm5TZWjWPMLUlx6JG
DZvbMdWWuL9A9JEeOl4rtJzy6fbmZz0UrTQFh4vtSflf8avZhQdN/fpssp+9N/xg
z1JXNjRWtIqw+rzEJ4GKCd5Pe9ehz51vsrdguh051taG/GbjLYrEzPxYpcRPE18g
Iiuc+tjRRBn5y6SCT+Gkok4qeUp2OgyUx74PWVWOmxDrrrzsEjl4O31PTWyM3Elf
9tExf862+Jn4Fmk9y8EboIiKrxdyLi4k8n8bOKagtETXRp6bzut520NcG51k2UPC
pScoOKvjJovT/SBY/IwH473EMsk7NMxBoLNcgF30aslPOFH8opwVP1IiHvXM7j3w
hVeRLhZYCHX7P4mlQ87OwhJM55G1fg/J1WazAUqwpR3S8T2Co4aOxHLP4EVZWHMr
Mi0SobfI2eAtZLVzczsU
=9YMH
-----END PGP SIGNATURE-----

--=-3NMIvZOMFmH4hWKxpWhM--

