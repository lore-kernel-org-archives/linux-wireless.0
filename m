Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbZKBJjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 04:39:51 -0500
Subject: Re: [PATCH] mac80211: Fix IBSS merge
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	reinette.chatre@intel.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <19182.41944.492519.390013@gargle.gargle.HOWL>
References: <19182.33851.980271.360757@gargle.gargle.HOWL>
	 <1257151486.3555.161.camel@johannes.local>
	 <19182.41944.492519.390013@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V+ka/k1Mhwas3wMA/QWe"
Date: Mon, 02 Nov 2009 10:39:22 +0100
Message-ID: <1257154762.3555.174.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V+ka/k1Mhwas3wMA/QWe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-02 at 14:48 +0530, Sujith wrote:

> And I encountered an oops when using iwlwifi (current wireless-testing).
> Set the interface mode to Ad-hoc, bring up the interface and issue a join
> command using iw - this causes the panic.

Hmm, interesting, I'll take a look. I guess I suspect
e1e8e5389a7b947a212c0d9db1b4e18eef16946e

johannes


--=-V+ka/k1Mhwas3wMA/QWe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7qjFAAoJEODzc/N7+QmaRjAP/14NMHPTvAzGS7ncxjRsEuJ0
vLEbu3kfeFSztHU7eLyv6jkWP77V+UthJQgp2Bx3jAKaOolzLuNmdtv9itLehz70
M2ThOv2wB9+Qd0LDCJG5v7dpb+Pyp4OyoUhSIE1vGQblPF0PySe+4NynwEUpqz8x
mvyT0Ult4yVBS/u4LIUf4RkPgmkqTAz97hWyJDlGUtSugGm+MTx/i39OF/qxYSu+
j4WzpIiXDBACsq6dRDjGlYXjJp7RHS4Y7YtuwdvqOoT3TftANOyMmo8bOgYlLxBl
x8elkJa9YZVybzRtlnF3kkoWBcillNvRJxLtfRiMQUEsppFfQgznSRXSV9Fh9IEf
VUQOGJTFMhNwI9hTD0M3Ms5Evss2dwP9bjeDQhcAIwEdZF/2mWFoSQ2Lwtn0OBlA
hF7+KgCpvmJlU0EIBwUkSXDPCh5WxoQ7FxyO0ffg4T8l48qcuy2l2uD2D62yVPuH
f4/0rvIUIb/xn5jISXEgcdhjQAXm0PS07iQcyaOWgkm3wphh+qRU4EMACq5F7rnV
XDFCUi7//JWfol5OIYHfp75aGppYIdwKmv6EcWd70zhnbXavN5f2M/EIpwtq+JZx
enDe2tAYnXCyIIB5HO6zblQPgbb173AEtKAkedgsLapn33Q/SdWEWjMk1MY17fcw
zPtIhL3jL6ceuPFsiyVP
=5Z9s
-----END PGP SIGNATURE-----

--=-V+ka/k1Mhwas3wMA/QWe--

