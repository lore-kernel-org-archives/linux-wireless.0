Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYGISJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 14:09:43 -0400
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1215625246.3246.40.camel@johannes.berg> (sfid-20080709_194135_916590_FC9A6131)
References: <20080617154008.883383150@localhost>
	 (sfid-20080617_175912_673335_B33F2037)  <1215625246.3246.40.camel@johannes.berg>
	 (sfid-20080709_194135_916590_FC9A6131)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UMeMOJyB2FbXzMkl5CLW"
Date: Wed, 09 Jul 2008 20:08:56 +0200
Message-Id: <1215626936.3246.45.camel@johannes.berg> (sfid-20080709_200945_861029_93F1B86F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UMeMOJyB2FbXzMkl5CLW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 19:40 +0200, Johannes Berg wrote:
> > This patch set does not address the issues found in configuring default
> > keys for monitor interfaces, i.e., this still needs a workaround in
> > hostapd to set IGTK for both wlan# and mon.wlan#. In addition, the
> > debugfs directory is left behind when the monitor interface is removed.
>=20
> Can you try this patch?
> http://johannes.sipsolutions.net/patches/kernel/all/2008-07-09-17%3a38/02=
1-mac80211-inject-sdata.patch
>=20
> It should use the sdata from the TA instead of the monitor when treating
> injecting frames, where possible.

Just realised that it doesn't handle VLANs properly. Could you add a
static MAC/VLAN mapping to hostapd to make VLANs possible without
setting up radius? :)

johannes

--=-UMeMOJyB2FbXzMkl5CLW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdP60AAoJEKVg1VMiehFYf4UP/iId4CY/R6V3YvQa17Kp2wsd
nuRtgKqxBPPbjIEs/69H83UJjU9eQ65A2ZqIbRSwsqK3PzHsS06XMWr4jbeLUozT
kbKDgtPO7zDeaH+rplO9oGZzzdn/c9UlgW+TQZ6DPTiH8lIDaGuyppdj2IKROPD+
DgSKSxZUagS2qmuBw+P73YsWDDCmMnMmA83gQ6h6zhcflL+etGdyVfOlsseQ9QpB
x32UwtWXh/ddgaGPdM2p0SPyYwTzBAU0XwmNxDCtmtnKmnV1LdKLz3noscq3dDGu
a91lTaoRRC5sW3UUjDaTvwbXIseIMTonZPEuXR8nT2oPD3Eq0C66pj+NdYeSylGq
LcGAkqAYBqc5WT1E366HIm1M8bwrDcBC4/elvKAQ2vgu8YIDxv3Wa4eJO8zSYym0
PvPIdsYCnMNbCtMslGBSEznBHb2Co8b5yi7tm6bCs6/LgERUIp7QNYPHWOXWz793
Qvum0o66vfUkZmE9z8uuGRsuCZBWQ+WGFsLKlLEze53HAEweyZCQApABXb3Z41/2
G1873C56fmK8+De8VctBiJsRpWXOtLrZwx0ASCsAyrdfL8F3a3J97lhzUJ1uv6w2
6PfS0PIrzzBJqiTIBC42qJgpKRaPYUPYk6GcYfXYQUQ40rYhV2fbsq/uoPRnoDMk
65M3zdZyNyXuC30oWbvj
=ea6t
-----END PGP SIGNATURE-----

--=-UMeMOJyB2FbXzMkl5CLW--

