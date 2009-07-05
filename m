Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZGEBhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 21:37:45 -0400
Subject: Re: [PATCH] iwmc3200wifi: cfg80211 managed mode port
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090702235513.GA4143@sortiz.org>
References: <20090701192641.072258140@sipsolutions.net>
	 <20090701193421.155074452@sipsolutions.net>
	 <20090702235513.GA4143@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fUKkWT9vFHLICA4fgQzP"
Date: Sun, 05 Jul 2009 03:37:34 +0200
Message-Id: <1246757854.16770.109.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fUKkWT9vFHLICA4fgQzP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-03 at 01:55 +0200, Samuel Ortiz wrote:

> @@ -521,7 +521,10 @@ static int iwm_mlme_assoc_complete(struc

-	union iwreq_data wrqu;
-	memset(&wrqu, 0, sizeof(wrqu));

johannes

--=-fUKkWT9vFHLICA4fgQzP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUAPXAAoJEODzc/N7+QmaGpwQAJ+GN6DiBSsEd61N9TxRAri0
7ogHMTBdppL6E67UTVEPxTh2oBfDsyal94doYZWYZTAEthxmbroujQs5rafglq5W
KjdOaaIsYA7cisLGHfJtGBpmvoib3F7u2GJW8ypS4d1N1xsjv6CgIFWBhT5IYsp3
4lfW3MftQ6OIvPsv5sry7nUS3/+gWNyG4O5HBJRjAIoi/HnJkzjHIBc8QGaE20C1
axEuHxzsjBNXhNzFP+FgqljZhLY2tITcvcxysbcqnuuEieKgcMPuQi0fIfXOitew
rCbm3yyI3mNQAiKzYtJ9/CAkyW66ta2SpuHjrxN/VDXIiCSoKR1El2mvYK08Fhnz
gOrsZAGQMVnwF52mRBq9I+DAQl1Wj1kfXQLkA61Madc8X+uEin9sPVKNpywSSnu8
noNEGkx+lO1Xqhspk9DPL4eXKPAMwhGLB64OvF5yH7XjEXGr4qI9T70TFmYjTACn
PBLK7w+op8/+89tJnpK/cG6ctyJI9p1o8bJtCwVOebPp1q7+41nTpvCxI1/tqVK6
qFrM5bkNuRD30/TGggYw4ZiHPDMaRWX9UAzNW8bXbZAT9crpyOB+BOxGopccE+UJ
bkFuw5ma/F2rmpZtVPN6/M/58D8Mk7hQmnCWtFlBF66jik3TnqWreilgA710U5MF
+LU6ol6x1I1X0/9mscQL
=rhm2
-----END PGP SIGNATURE-----

--=-fUKkWT9vFHLICA4fgQzP--

