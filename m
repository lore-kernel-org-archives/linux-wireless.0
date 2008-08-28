Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYH1LFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:05:52 -0400
Subject: Re: [PATCH 08/11] iwlwifi: call apm stop on exit
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219928195.6064.43.camel@californication>
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
	 (sfid-20080828_123916_214502_EDFC473D)  <1219920741.25321.4.camel@johannes.berg>
	 <1219928195.6064.43.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VJGruyvD2m89xTPWcyyT"
Date: Thu, 28 Aug 2008 13:05:46 +0200
Message-Id: <1219921546.25321.8.camel@johannes.berg> (sfid-20080828_130555_315058_02B4F71C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VJGruyvD2m89xTPWcyyT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-28 at 14:56 +0200, Marcel Holtmann wrote:

> > AFAIR people have been complaining about this behaviour _forever_, so
> > it's hardly a regression.
>=20
> I think so too. However the question is still if 2.6.26 maybe did better
> and we are now doing worse because of other patches. This needs to be in
> the commit message. Otherwise this falls for me in the next merge window
> category.

Also, this is another victim of the "oh we post patches when we think
it's convenient" rule, I took a minute to dig and the patch has been in
the iwlwifi repository on kernel.org for six days already.

johannes

--=-VJGruyvD2m89xTPWcyyT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJItoaGAAoJEKVg1VMiehFYrGIP+waDKWo71YA4g5gFOsExxvGm
DcGDor7A8LlLycARrKzbzt7tYi0aOIT+UbXUm/HC3fNZ16GMHMuR9TpmsQDZGi31
shV3BwC8/eZtT+T2L7OlauPQ9YK2iFayNc3c47nlogGwGPo6ulVktoTpbBDVjO4E
LefebO9JCXYmS3Vo3hLxwLNo3GFMly7LR1d4MaguBWjv0KXjcZ/bASBFr5HlMdHy
zVnwq+x+3nB5CFtDJMFQayIzyTZH8noCMWGlD1npOND2iQD5tQRA179FCr4zT1rx
HvXD/xh8IARkOqBEFhbl6D1ciLaCkdid5B/e21vS7yXzqXQI2UekEAC34VwV/Tdd
3OM3BLAA891CEkiFvqlBlfiHdwacWeO3GJG4geJhyfhxHsO1wwcepSXrS/sEVZNP
1ulsEa+JfWDqWUib6sZvK/zN5DQpGPpQR8xmpq13ITugg9W2gfKMz0rADEiP3qFW
+schVqy6SaZWD1j5K27kM2ttmDyKtkYUziUOAh43HTULHNSY3Dj/PqOyAJhgZ3CD
V3kb2gVmQQV19Ev2HH49LSNjZq3Dq2CjaINTBwsvlCBVUuOudvtIKXSsELbgvdcG
OrVd0DTspIabj7McV4nX+GSaRgiFu1ZeZ/z09vmNj63AlL3jypHIh7xkcYPhmLhc
Via6APe6Iu50Vx94SjS2
=eb0l
-----END PGP SIGNATURE-----

--=-VJGruyvD2m89xTPWcyyT--

