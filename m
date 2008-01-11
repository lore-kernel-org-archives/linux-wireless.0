Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51372 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYAKMAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 07:00:12 -0500
Received: from [131.234.198.2]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.68)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JDIYT-0005qy-TR
	for linux-wireless@vger.kernel.org; Fri, 11 Jan 2008 12:00:10 +0000
Subject: Re: [RFC v3] cfg80211 API for channels/bitrates, mac80211 and
	driver conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1199986287.3861.91.camel@johannes.berg> (sfid-20080111_113807_327773_C6F8A143)
References: <1199967423.3861.51.camel@johannes.berg>
	 (sfid-20080110_121725_060148_B022943A)  <1199986287.3861.91.camel@johannes.berg>
	 (sfid-20080111_113807_327773_C6F8A143)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a3A/ermP6dJHMRZRRiyz"
Date: Fri, 11 Jan 2008 12:59:51 +0100
Message-Id: <1200052791.3861.165.camel@johannes.berg> (sfid-20080111_120025_585318_DBBBD10E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a3A/ermP6dJHMRZRRiyz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-10 at 18:31 +0100, Johannes Berg wrote:
> On Thu, 2008-01-10 at 13:17 +0100, Johannes Berg wrote:
> > This patch creates new cfg80211 wiphy API for channel and bitrate
> > registration and converts mac80211 and drivers to the new API. The
> > old mac80211 API is completely ripped out. All drivers (except ath5k)
> > are updated to the new API, in many cases I expect that optimisations
> > can be done.
>=20
> Tested with iwl4965 and found two bugs, will repost.

http://johannes.sipsolutions.net/patches/kernel/all/2008-01-11-11%3a59/017-=
cfg80211-channel-and-bitrate-api.patch

johannes

--=-a3A/ermP6dJHMRZRRiyz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4daNqVg1VMiehFYAQJLmA/8C6/SzNh2CP/wKtestqQik3CZ8YfxoZzi
/n9PoKyDEvaRkyxRxHcaY+2hTNpr2TnJ2b1l1qu9fZpS3fF5jgvkj+CpYklAfTPe
7tbqRqJ1L3YL8DDWXAP8xqSJGEbZfVaY0VUeJJKhxUavJsJSGUfeV+wakvCN3R5Z
qKv/ucHb5nN5GW0hXB62e/aIjO3PMU3umLpxnB4Z+vcoQ4GsjB4gffWL4XPNtY+8
PilFV95O+JJ2hW0QmxzaJITMHqH4IB/x/tRCP/KuHPUnoInSzvUW0Ak+qJT4YWo8
j3xRKoBoBgP2bYh0HvrcHlZjFiNmPcskz6QXxZ4L8b6C6fO565fMFz4RzfylYYhQ
+y99fU8cAsZiBxcnUHo2KLYLaxbHTNc3vowmiQw3d8DVfpvqVAebE3VA2LptLVD0
k7LdccGrs5IbTgFOxRrVZoo4EIDPE+cPDyvl42k5t7eqI+J0UVsnbi4wh7Uz1tCt
6WxwWI9FrYsRI/gwYeKXaKpbGNxs4tmQqaeLgOsk60OCo2iaOy8hbVarIZhCMY56
SWjSX1K4PItH8hDjzqCM2jYNgkKFUs29qseR2C3r0n2foHTsrIi13rSUwQFs/Yag
opYXtAiItkr5OmiWf0D/eX9czXOaejHYts0zP1zAmNPTpryr1OCRcQhpXGVU5tdz
Jn/4sjUVaZc=
=Yc8E
-----END PGP SIGNATURE-----

--=-a3A/ermP6dJHMRZRRiyz--

