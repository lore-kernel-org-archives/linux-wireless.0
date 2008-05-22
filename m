Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231AbYEVJSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 05:18:37 -0400
Subject: Re: [PATCH V2] iwlwifi: Fix packet injection in iwl3945 and iwl4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>,
	Tomas Winkler <tomasw@gmail.com>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1211447545.7814.97.camel@debian.sh.intel.com>
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <69e28c910805210819ye492edkc20b1ddccdf082ce@mail.gmail.com>
	 <1211447545.7814.97.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qIAMF8EVEH6WgVs5WPt/"
Date: Thu, 22 May 2008 11:17:37 +0200
Message-Id: <1211447857.3698.52.camel@johannes.berg> (sfid-20080522_111840_626998_EFEFAD7A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qIAMF8EVEH6WgVs5WPt/
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-22 at 17:12 +0800, Zhu Yi wrote:
> On Wed, 2008-05-21 at 17:19 +0200, Stefanik G=C3=A1bor wrote:
> > also works in monitor-while-associated mode.
>=20
> How does it work? AFAICS, mac80211 wext.c blocks setting essid and bssid
> in monitor mode. Did you patch it?

You just create two virtual interfaces. Which, incidentally, iwlwifi
seems to be quite buggy about: it will accept all types, even those it
doesn't support (mesh, ap, wds?)

johannes

--=-qIAMF8EVEH6WgVs5WPt/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDU6MKVg1VMiehFYAQKDVRAAqS9MT//TmGekvSpXsB4DsSoJth6Sbsje
GgWBLeae0JNcywixeuYQpLXTmQx8WrrKQSUew++0V9yCSNHoO+fihnNh2I8wEEGX
Ea5qeK2ozxr9410O8lFox2APApvWGFOmV50DLReHjB9zqQQ1n7xSynqN5f0l+NbJ
DL78MYzF6x8SkrFAemRBAKJ75pG2RpumUaYeIPWwaNHXE2zRkKW3LRvWpYM3xXZh
UJ479v41jJGpiLCftrpweVWhK26wsyLVDGrmshUJWEE8aWes1cCqfQPSyY/Wp5wQ
f0yfpQk+FVA97sgPJdalTk8iRvjWQr64i8EPdra/16iGL7JUx/O/zNgh8JXo9EmV
2S5dibjduDNzw7l9kKW3292xYtwVez/5Mea8FaBN8uhSishUBdF9RLDO/C4VJHdo
Ov/XpQK5EzrHJCPiJNeACy++URSFCg2pbwhgOcn5RfqELRFFyemoG5rPDTd4cAE8
3CMI1AfZajUhX3txrj4y7K6zOPYewaZ0aPxxYFNbqWIovYkxeGCpDZp2YIO55KoW
gW6xHDYcRDkK8ogY0g0ZW+S6Fb5wyY5MpgmORKWpkwOk9KWmLaqaw6pWu7OEJnC/
9NF6QB5G8XLDeSqsOWyEEK2bl6HTkKO6WxGRkUW18YP4NIg1FoNQGSzALXtmbHzc
1fWEcgy1gI0=
=5iO/
-----END PGP SIGNATURE-----

--=-qIAMF8EVEH6WgVs5WPt/--

