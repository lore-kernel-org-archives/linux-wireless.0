Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYIJHvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 03:51:10 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214149401.8585.2.camel@localhost.localdomain> (sfid-20080622_174624_286344_54D543FD)
References: <1214149401.8585.2.camel@localhost.localdomain>
	 (sfid-20080622_174624_286344_54D543FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZsCy/9PgfZeo7lolC/g9"
Date: Wed, 10 Sep 2008 09:51:01 +0200
Message-Id: <1221033061.12266.10.camel@johannes.berg> (sfid-20080910_095115_515502_30A213FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZsCy/9PgfZeo7lolC/g9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> mrv8k has commands that get called before and after the scan has been
> done to save and restore hardware state.  Add optional callbacks to
> mac80211 to enable low-level drivers to know when the stack is about to
> start scanning, and when it's done.

Was just talking to Sujith about something on IRC and realised that
maybe this is required to turn off IBSS beaconing when leaving the
channel for a scan?

johannes

--=-ZsCy/9PgfZeo7lolC/g9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIx3xgAAoJEKVg1VMiehFYzukQALJ3OlydTXXum3ld8RTx2OUB
8M2zNodEcvoDw+BLtDBkPzgb48gIz3IZFaRn/FyNV5WpH+rcoYgssCf5iPdL7MHA
PuhUDiGpgzHFz9mhiKRCNFG2VTXF8zC11DiQIUIjL2lwXCXgyQHDp+ybKkGOdqi0
aU9Stp1pYUwY1h5CnXw53gW/6ufKQE3xrm//HFZ40SytuD1EF/BIRjXqClsDuYLN
gEyt6imX3BgGTGOci2QyQr5JB4G1k2paSrmlpF8wqtkQwzDTiRocaa8Sekw8Tqm+
ZeY2qalX6HEHKMn0TYAYavcpzAr5ShDMm6X4hWEiDSV9dlkZfBBFzQY6O3wEUM0z
PypXyvd52LebB6/d7Cmg2jM0s0w6W+ErcXFQZuVhNMQdZX/6aoVCGZtj9lCPXE4B
2zME31mSuv/NnarE/R3Q1xqNnMLdU2bUqaA4+IJgzLBaQ/li+wjIgRHhL5KBu5bJ
ucON5Yx1xXbuB3prJhYUzYAe/oT5k2Rk4cW19K+9RdxLj5DEZk6H29MQpTMOAkH+
GvlR+2ACxgP0vG2Ldg7i+T7Y1+TjWihLni0sqUWYwOsjH70Z9a98gjAXCpPd1Nl+
EOPv06yBthdzWkL+4+393vZ+mJ0uHdlgSJyforZekbcBlBsFjzLcfbQY4pzZUona
591U+X1E/9Qj4nD/Jkzu
=bNx2
-----END PGP SIGNATURE-----

--=-ZsCy/9PgfZeo7lolC/g9--

