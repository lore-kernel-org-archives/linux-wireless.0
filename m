Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56776 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYIFW13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 18:27:29 -0400
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220739930.21016.6.camel@johannes.berg> (sfid-20080907_002542_014456_D81314E0)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220739930.21016.6.camel@johannes.berg>
	 (sfid-20080907_002542_014456_D81314E0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-riOctpPr7V5E7B1oNsaT"
Date: Sun, 07 Sep 2008 00:27:24 +0200
Message-Id: <1220740044.21016.10.camel@johannes.berg> (sfid-20080907_002731_668301_443D0647)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-riOctpPr7V5E7B1oNsaT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 00:25 +0200, Johannes Berg wrote:

> > +       ieee80211_set_associated(sdata, ifsta, 0);
>=20
> This whole set_associated(0) vs. ieee80211_set_disassoc() business seems
> fishy to me, can't we just move the set_associated(0) code into
> set_disassoc? AFAICT there's only one caller now that calls with (0),
> and that's in set_disassoc().

Ah, I see you're doing that in 3/3

johannes

--=-riOctpPr7V5E7B1oNsaT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwwPIAAoJEKVg1VMiehFYp/8P/2knAppc5Jp1AXK6dlKyQ1ej
Xf5si45hzm4p2MXR0+b0pAgWzn8FwRZIhj7qDwe+TBrle5Wv18h0MDIhGbZKbiMG
Kk7HS2goQIyHkSOJCAHFGtVEpL+C4nbjvdYMt1MVsdVg+Q0IH//zKbxzqmiV0MHN
AfZBQ1lx/pCyioa/vXl3bcXonxNqd2rpcuYt5fFX8VU8THDF0GcPCrITWQ3/Gtjk
D7lP7O6DYuP3TuDx8aCKlwbVbflrdBsdXvpNqP2YWhW4YUYKW7HskguPntwDL0hJ
juctBBP5W0UCINmeAEjwzLyGHjuUH5C4oZ9dZJ1Y/ig90Jf2TTJFQBTB3PEWpYKZ
sY65qE7oSC21RW19c1QJi5Uy5ED41fl+r1+GdwhyJFJ88tHFrE90SWNolZBPP+AT
O2c4kU6/BT8nusA0CWfJMZj1ZMKJzn5UdGWzqkiF6ClB1ry2FfPHyt3SXxBhKK8T
ZGsezH3cYVyjGQas3oXC17Ba/wRz0fC8jd8eUPiHhRY04Z+sNFRwprpamGT9d4Fa
YagrSiwtxBr00PTuN1wvTRIfxtH7Gp4cAuJi5dM2dqkP/dOkVJw3JZ/melxlI9Et
tvPBbc7Zx+OXpgvMj8oOGB43lOwJ28Flf5OV76cH7PtUa3dgGhVITk/1/I5aqfns
YjWcGiyAHUtzyUsVUaYx
=XWNb
-----END PGP SIGNATURE-----

--=-riOctpPr7V5E7B1oNsaT--

