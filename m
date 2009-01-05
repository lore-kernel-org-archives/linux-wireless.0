Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZAENJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 08:09:57 -0500
Subject: Re: [PATCH v2] mac80211: Add 802.11h CSA support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
In-Reply-To: <18785.54821.934672.713597@gargle.gargle.HOWL>
References: <18785.54821.934672.713597@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-f5J4SG3zvCODCGKsTTje"
Date: Mon, 05 Jan 2009 14:10:40 +0100
Message-Id: <1231161041.3334.8.camel@johannes> (sfid-20090105_141000_155367_E63E24AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f5J4SG3zvCODCGKsTTje
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 15:13 +0530, Sujith wrote:

[...]

Looks good to me, just one thought I had:

> +	/* Disregard subsequent beacons if we are already running a timer
> +	   processing a CSA */
> +
> +	if (ifsta->flags & IEEE80211_STA_CSA_RECEIVED)
> +		return;

Should we verify that we're getting subsequent CSAs? Is it possible that
an AP drops the CSA element again and expects STAs to _not_ switch in
that case? Or, even if that is not possible, should we verify that
anyway?

johannes

--=-f5J4SG3zvCODCGKsTTje
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJYgbNAAoJEKVg1VMiehFYtssP/iqPZczD6/q2QAcBUf1oP7wm
XTz2MDsruF8JlnBuQJT6uh+jjZ130yRo0GqtzpVGLb4r5ng6Z83kipWkdIeEJWoN
2ZoIb5DxFNio4k015lVMAC2t6/3J5ZgoSC7MdusBOWZddxevaN2YbugXyh+588ds
ocvOsfLcVbDPWXLu5VVg1SJncorfEqZtNBbluXb1vrPvJ9kSYolocXIII9S5YnuG
eK0shFVaW3kVo3zaWFbK4q2GF96Ona3nCRdfjVRVu+KuyTvaVCCGCn9cbuhSJctB
xvWmTjyKH87KFKLSKOZqFLjw8TG4bk45GLLX08xluvgDivQDDS+mSgax+TRM3Y3V
6vRJX7Qyioa4x1TaTudnU6qVlFbAnHwwRDpx6dBpix4Jdm5gNC0qDVdV6zzFjMDt
GEn5kB4RM7xG5StkeBhSC4PUEfZ9mzsr/3nfPGDQgfg/3URnAkoSN+GxoaTbY9/p
XtUtKMbI9ftCL9zv/Xs++A4AKa2CDDPTzg5O6QYIRD0DmCnz2OQmiM61CjsXxtO9
6BKRnRjWS16lMJRAdQyjNY97SAwF9pVaR0Sbc/Uc0vgnoJfixWYGXy1BGoii5qp0
giQk7vcNV8Eq1fCgRM80FP5N5+xbnajCNVORywgW2AAtQ0P/c8uojR+1rjtI9njv
tPKDtTLAuI4qNWVc3Cor
=dyVW
-----END PGP SIGNATURE-----

--=-f5J4SG3zvCODCGKsTTje--

