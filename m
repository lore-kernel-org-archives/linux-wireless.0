Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYGKSIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 14:08:10 -0400
Subject: Re: removing STAs while aggregation is in effect?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <c85cb4470807111028w19f62abel31704deb18c73f6d@mail.gmail.com> (sfid-20080711_192850_305767_D979E950)
References: <1215770111.3483.112.camel@johannes.berg>
	 <c85cb4470807111028w19f62abel31704deb18c73f6d@mail.gmail.com>
	 (sfid-20080711_192850_305767_D979E950)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t1+4BLlZI9mHnVO55IRA"
Date: Fri, 11 Jul 2008 20:06:53 +0200
Message-Id: <1215799613.27426.0.camel@johannes.berg> (sfid-20080711_200815_298498_AA13E731)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t1+4BLlZI9mHnVO55IRA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> funny, but by chance this is a flow i am dealing with right now in STA
> mode as part of patch meant to clean a bit the dissassoc flow. as to
> AP mode - i did not look at the rework as well and i will have to
> check this part, but IMHO this is more to do with the general flow of
> assoc/dissassoc. if the MLME decides to remove an STA - by all means
> it has to free its resources first - aggregation queues is one if them
> of course.

True, but it's actually quite different in AP mode since there we just
get the request by userspace to remove the STA and never know what's
happening until we do. Whereas in STA mode, I'm not even sure we
completely remove the sta_info entry for the AP when we disassociate.

johannes

--=-t1+4BLlZI9mHnVO55IRA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJId6E5AAoJEKVg1VMiehFYMLAQALb152Tipzd1LJsg1I6n0EhW
H/muT8xflKQAgdxOgerlD9L5wx4U9RoYSbmp3qj+CfKvswoDt5AzWy9EmobmOMmV
jUJYW88qkPrUU9k6ndVAFxLwJBIU6Sgdcwfy2Yp2aoJ19D1f2wAu4iUHFwvgckL3
1VK3x4mlDF2JqjaE3L3X+9Fz6I5qAZUzMf2zWaLMS2WRZOca16FwNCqvKsG8Ce5u
IPh19ZkLyGF3HhxdnFkgUz5/9tjgkJchUAAFIy/xW+RpOTHWfpROaQmmKTxge2W6
DbXerI1NffDxVxspNgtYXb8GtEXiGspmG4fwraujH0RdV4/TXbIIGG9eIvEdWWuC
v9Dw5iEMRtAQtcCfXWq/rCwuV+NCw5lEVSKCW1OMBIZ1jHRRUC4aCME4KU6ntc9v
9pT/Gto0RMcZbc8Wsl8iazSplh7Qo8IFrBNX1h86zg2Y2z+vksg43llzt5W+sSzX
Cqa7lLli0avZZv4a672b4BFu3BuSUX742/ymdd4M+i2D1kDghfXX/9D/VMTYg06q
mRlewnf83AwSuKUpFInFnSH6yiF2QVIlcLliOiU6JTHNoXA1S0tmVwqlLQ9X5GoA
bAhx4+/G8JUuqqKqAwo9MjkY1e3hflzMiK1hEQPTJtwkVZo2prwkwMXjR1yC3IS2
/GS3qyGzHhfo0KC5yJw/
=VhJb
-----END PGP SIGNATURE-----

--=-t1+4BLlZI9mHnVO55IRA--

