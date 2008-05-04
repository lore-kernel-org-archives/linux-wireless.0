Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYEDRzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 13:55:43 -0400
Subject: Re: iw: NL80211_IFTYPE_MESH_POINT not defined
From: Johannes Berg <johannes@sipsolutions.net>
To: ael <law_ence.dev@ntlworld.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <fvksqp$blq$1@ger.gmane.org> (sfid-20080504_194934_131530_1EA0F365)
References: <fvksqp$blq$1@ger.gmane.org>
	 (sfid-20080504_194934_131530_1EA0F365)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZKm9md3OjA+Va/PnAKnJ"
Date: Sun, 04 May 2008 19:55:33 +0200
Message-Id: <1209923734.3655.4.camel@johannes.berg> (sfid-20080504_195507_942472_EE8264C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZKm9md3OjA+Va/PnAKnJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> interface.c: In function 'get_if_type':
> interface.c:50: error: 'NL80211_IFTYPE_MESH_POINT' undeclared (first use
> in this function)
>=20
> I guess that this should be defined in /usr/include/linux/nl80211.h but
> it is not present there nor in nl80211.h in kernel 2.6.25.1 which I have
> installed.

You'll need the header from the wireless-testing git tree, if you really
want iw.

> I am just trying to get a usb-wifi device running with 2.6.25.x where
> the driver has moved to mac80211. iwconfig appears to work no longer and
> I found documentation to the effect that iw was required instead. Hence
> my attempts to compile it.

iwconfig will definitely work, in fact, iw right now has totally
orthogonal functionality.

johannes

--=-ZKm9md3OjA+Va/PnAKnJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB34lKVg1VMiehFYAQI+fBAAu1nOmEmJp3QBx44vDiplZoyvfncgoxVq
xL206P9WhO062NfZttCfFsJ/WpLpiNrOcCJhrxrMwyaBx28BiZFi8Ezwt2wM+/XY
/i4WPCGJlo74hJhrzS2wQKUvZClmokNeb+FpnCqFK3aG8P6a+trskPxVOafNf7rn
934B9RBT3EsyMSSc8fH28aWKqIE/qAdQwTSwGGx/oOwrEfDnsEV2plY6JqkqDzVf
7SMISUHmvXCyhj1Bcj23ST5eFvtOi4outJxs+vKIhTnyK0tbfCjNJg5lPlOaLpx7
09aOq0s2hycffP5v+8I1MnMceDDPv5tM/ukJwFMZOZHlNf6JQU+wrQW/MLW1l0CX
DmiNNNI0XNzlBN44Hnn72SaTmB6biEtlHNRuRFG1L++MlpYQfd+GBeiZbZ1tWmBN
Av0q6LBJBKCR4oBmHpOVffCy3rOe8koB1JtrvcYOS9AqTaoBC3Qw6P8VvQDLotx7
RAygwDG6nXHT+if3azKVgH2pz+S1b14wW71U+pIhTcQ2S0lZIrUdhtdL2OndG/og
84i1ZOOWPyXwRcV0JXSNOtGnd/IpHPxIdQSHPB+rXl77b0aIYz3GZhpWsAqbMbKN
RxQqNRZcLwAWPd297tPTEqJYRqHcnuYEKEDF2LS9vVprlgXrhqC2xngJ++yQFDnh
njc4U6PwJzU=
=M/xi
-----END PGP SIGNATURE-----

--=-ZKm9md3OjA+Va/PnAKnJ--

