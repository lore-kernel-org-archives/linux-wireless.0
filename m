Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZEUOzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 10:55:03 -0400
Subject: Re: [PATCH 1/2] wireless: move some utility functions from
 mac80211 to cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Zhu Yi <yi.zhu@intel.com>, drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <20090521144115.GB2744@tuxdriver.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <1242872340-27417-2-git-send-email-yi.zhu@intel.com>
	 <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
	 <1242889781.24825.611.camel@debian>
	 <1242897719.5471.1.camel@johannes.local>
	 <20090521133839.GA2744@tuxdriver.com>
	 <1242914188.4212.7.camel@johannes.local>
	 <20090521144115.GB2744@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SKCtIYlko60U4B6ZPnIH"
Date: Thu, 21 May 2009 16:54:58 +0200
Message-Id: <1242917698.4212.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SKCtIYlko60U4B6ZPnIH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 10:41 -0400, John W. Linville wrote:

> > Basically I still think having lib80211 is pretty much pointless since
> > all future fullmac drivers and mac80211 all need to use cfg80211.
>=20
> I like the logical separation for now.  At some point they can probably
> be viewed as a single unit, but even then I think lib80211 will be
> a better name for the amalgamation... :-)

Fair enough. Yeah, it would probably make more sense to integrate
cfg80211 into lib80211 at some point.

johannes

--=-SKCtIYlko60U4B6ZPnIH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFWs+AAoJEODzc/N7+QmaHtkQAJ8RzBEbA69oWb/tP0UcErLf
Ab5UuwZthqqFSqKRy6dxPRUeg7+l55Y9xJPmW7h9/nw9E5jQhQE6tYYecMMWAieF
bse+IsqMR+W0B+34L2LZYD6anE8DiiYqwhnAxBAGDXpmne5RXBVl4WLHrr4YYJTf
gBXvPYBEAMm4YbX1osFqOqHfRe9B0nB3L7xV0loXfH6oKGEe1u6LRJXmFpwvP1h+
yudyfboXS286LyT0zqLoEv1X2NK2W7bK76KYlLTyOib7ojojvwmJV3Otolq6p7cc
8khp/yfS5+aMNkBxGHLNiB7/oeS3t7ZlooqZqy4M11BFrmjJCGwkDsEmtNYG5LuF
9Fjm55yTzgpdLR51eUpBR3HgDCV1IlRhTUP3usYOVObdMyZuEAI6GTeO/FdtAEbk
pIdzTIDtt/kZ2aXg2Z2JZB2Gum8eRdKaLu6uuPF58Sy0l66hSmGnJEbwtG/FKbU2
P9He9mTToRkAUFlxP5vuozs3K9M4eR5Xnzbe1791j+6ABgfBDqiaVYNP7kuq44Ai
asiWUlPSMSEsNcwTamSQWefgqrrd8MzdKE7CWMsqGLCy1qM0Y9HCu5kD7cmPmcmB
Pibi/Zy3ufdtST9B4TW00NRqlltv/2Ns5QDvIrug8ZJQ1zU0KfqtsznJIDEJxGJA
J4+LUAiEM5XwOiWlguEQ
=VPZ1
-----END PGP SIGNATURE-----

--=-SKCtIYlko60U4B6ZPnIH--

