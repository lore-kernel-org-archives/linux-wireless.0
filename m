Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZKPK4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 05:56:04 -0500
Subject: Re: [PATCH v2] rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20091116104937.3845.62090.stgit@fate.lan>
References: <20091116104937.3845.62090.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-r6ixrxNMbGtoqgMlKjDL"
Date: Mon, 16 Nov 2009 11:56:02 +0100
Message-ID: <1258368962.32159.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-r6ixrxNMbGtoqgMlKjDL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 12:49 +0200, Jussi Kivilinna wrote:
> rndis_wlan didn't know about NL80211_AUTHTYPE_AUTOMATIC and simple
> setup with 'iwconfig wlan essid no-encrypt' would fail (ENOSUPP).
>=20
> v2: use NDIS_80211_AUTH_AUTO_SWITCH instead of _OPEN.
>     This will make device try shared key auth first, then open.

Oh how very cool, I was dreading you'd say "can't cfg80211 auto-try
then" :)

johannes

--=-r6ixrxNMbGtoqgMlKjDL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAS++AAoJEODzc/N7+QmamiwQAMrn79uxZ+8eFV6/6fjBIiPl
Sq2/Sa2k9pE0yI55CB4AjPAY2s+u9WFsgS3wSZqwEdv/f57SDN1qV6UybATIH7XT
0GvZ3DsFCTMdzalzb9ykUJSBThD6Izvq4242gGV6ppv6HqLgN9KUDDCyvQhvgPj1
Ktgr1RYa9n9ItDVFBUfhbV6mvdp1oE9J1bw7WsTc1Ar600dTzZnNwewO8t+rcHXO
RssWBqJ8bCGgn3UaCbaRO4SP7terEhUP97KiifMZ8xe69FqYYaYW+yb7z6fAFSUp
9k2jtcW+Hw3DK8NYj1AJ/JnHWuM35YWzyV9MefQcWbM8hf+CDHUgNJDzH1j+i69v
cNxfQeoEp1TtGesHkspHscpCX9jjniEFC7Muy0gl9OjpJ/tQI8wWCTMe+xK73/jK
vHYGyvTGIEzn1oPrWjiCcloAVEPkG3cV7u8p43Xm+NCbBSvYtnnlHtiZg9lvt3x/
H1TkYWxjFyI4VAoaKmccFEMmDSBD9c6H4sMpKjLhielCc7BBOgeZw4mrtYx6Z1NZ
MdYqC6JdknA9wi8/a/7VtH/pq7VEiaaua1Wg24RvPveNr3ZyCN6Ra7B+AvfIQmo6
B63dBuC2bVZy8PcK5ZrupRbNWYtfkDZVRSI185vVoYfRy0PKzfv3iQkasWe4Vpp5
bCdDvmVHEj7lpjwJA2xv
=1oBp
-----END PGP SIGNATURE-----

--=-r6ixrxNMbGtoqgMlKjDL--

