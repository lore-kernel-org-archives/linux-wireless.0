Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbYAKLiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:38:04 -0500
Received: from [131.234.198.2]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JDID3-0005eW-Fj
	for linux-wireless@vger.kernel.org; Fri, 11 Jan 2008 11:38:01 +0000
Subject: Re: [RFC v3] cfg80211 API for channels/bitrates, mac80211 and
	driver conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1199967423.3861.51.camel@johannes.berg> (sfid-20080110_121725_060148_B022943A)
References: <1199967423.3861.51.camel@johannes.berg>
	 (sfid-20080110_121725_060148_B022943A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dSfj5IfJA733iDcpn1cm"
Date: Thu, 10 Jan 2008 18:31:27 +0100
Message-Id: <1199986287.3861.91.camel@johannes.berg> (sfid-20080111_113807_327773_C6F8A143)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dSfj5IfJA733iDcpn1cm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-01-10 at 13:17 +0100, Johannes Berg wrote:
> This patch creates new cfg80211 wiphy API for channel and bitrate
> registration and converts mac80211 and drivers to the new API. The
> old mac80211 API is completely ripped out. All drivers (except ath5k)
> are updated to the new API, in many cases I expect that optimisations
> can be done.

Tested with iwl4965 and found two bugs, will repost.

johannes

--=-dSfj5IfJA733iDcpn1cm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4ZWbqVg1VMiehFYAQJUDRAAjvPpAvtSNzO4URoWoWJJ+YnFkSxaXhKW
gZl1PNv+cgff8Rdiqgcnwld9k4xIIgSZqt+KVJJZSnWUIqhO+ctZLPvA6CtPidl/
mxRJuRH1usZLVwyI7vRNcD/9LtCPwCYaYXN0D+OsmZ9U7P9l0v28K1hRKNGN4JIc
8banSmAGvVTCABIy7WWNfukA+unwJG8dC1nyNO/dtlwS0BuwaVlA/m80d3CJXbd6
w2Y1BE84+BJm6jeDcpiyxNs8U82rtLa60VuYDHS4gqea3e67kGcGPkUpxfhNgxmv
WGlMbV8miuFq0yNmkTBPrteEtb8FkIwe/TXaQeesPT+O4AwkNuviFYZNyRMxGE1G
HBYxW50nV2BPCVUDpAgEvvzOfHY5odpcsK5WKCwXDeDP+0ynWf0JBm9QJib+0t+D
zNsofZmLt9xELVsibl6rfS8l94yA1wCkHKdfcEx0lKCrLWLK1JwtzB6pkW4C0SL8
ZADmirRUL/h+2YUTQv42aTwtj2A1llXyh3ujVlR6cDF+Fhd7OyC0pz1nhLhxxUWs
qxyfns/zO5hCQUxDO0tWjwOoYlUwrS3zCXcsix62rv0/UpfLUYxlqVKa0k1rQ4cI
/R0J8rEzNj7CJWeUxYEQAjw4FDTMZ3tNEHxfQw+j7NG0EndEqoyfn1DYz7pCJyuO
TW7f8vcjbhI=
=e1eo
-----END PGP SIGNATURE-----

--=-dSfj5IfJA733iDcpn1cm--

