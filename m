Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYH1Kw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:52:29 -0400
Subject: Re: [PATCH 08/11] iwlwifi: call apm stop on exit
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219927149.6064.25.camel@californication> (sfid-20080828_123916_214502_EDFC473D)
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-9-git-send-email-yi.zhu@intel.com>
	 <1219927149.6064.25.camel@californication>
	 (sfid-20080828_123916_214502_EDFC473D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/1FMz8QP9H3/ByaLCWA4"
Date: Thu, 28 Aug 2008 12:52:21 +0200
Message-Id: <1219920741.25321.4.camel@johannes.berg> (sfid-20080828_125232_441117_102A7E58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/1FMz8QP9H3/ByaLCWA4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-28 at 14:39 +0200, Marcel Holtmann wrote:
> Hi Yi,
>=20
> > This patch calls apm stop on exit and suspend and sets STATUS_EXIT_PEND=
ING
> > accordingly. Without this patch hardware consumes power even after driv=
er
> > is removed or suspended.
>=20
> is this a regression to 2.6.26? That is always the important question
> here since that will determine if the patch should go in. If the 2.6.26
> version did this better (even if not prefect), then this patch should go
> on, otherwise it could wait until next merge window.

AFAIR people have been complaining about this behaviour _forever_, so
it's hardly a regression.

johannes

--=-/1FMz8QP9H3/ByaLCWA4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJItoNgAAoJEKVg1VMiehFYF7UQAJejBUpVCxfK+84/qc5DpYhr
dmpssBFeprvKICgEZBZPfBqWFltl/EK5JUjWUBnvLosbxv6VmOeDIZhUieIUsBDj
8AbnFNyQbYVyZlH+k8ba/IxgDxZC6B+6nAv1+bnsgGdU457gr/Dnqw97beYctnqT
8azPyCeroq+SJ0QOAUTN7X3rRrLnSGLy1vGUxnI6EmdGo4KQVdKVteGZlnYx1KyH
Hjpvy5QZQdAXpQVpLVZZw2KqY15yeVCi2fQHERzE5FD2RxTJF3zM90t+gJEcJ0Z8
xZ5X0XgWuWMOBtfOk8yHfVV6+h1Og8vTxpbPSJAgBMXckpcSvbba0L9LVqVrIIyD
LB2AuA8Io/eywIouU/MgbBnBrD3K2nMVQc9Wlln+pcapCF2Xh17f1J8VpqM5X8hC
ZytcnEhPPLVZ8Arcd2paAjVmrG8+6NNqg/wQQrDaQDbkTnnAo+GzLB22GqhDIG7H
o9A0JHXDzziJvBoFBfAYZmCEKFYReA7wEGIp4IsZP6RNTcCxYwQkknKaPVpUWS5T
radKudd9BYjtiHdGvyzl6lhcm8gw8oa/vE2X13eznCbj4YhXmXSabSGHRcQ7H7+T
nDEU5uNuGg+OTfHn8oqTRFCSE1WEb31rLQUbSTIDXcP8eNCgALeuOxWbdr3Asovm
HNarZSAr4C82t+JLEgIK
=HYyL
-----END PGP SIGNATURE-----

--=-/1FMz8QP9H3/ByaLCWA4--

