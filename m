Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZGUKoO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 06:44:14 -0400
Subject: Re: [PATCH] cfg80211: avoid setting default_key if add_key fails
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248140853.3747.39.camel@debian>
References: <1248077577-7295-1-git-send-email-yi.zhu@intel.com>
	 <1248086067.4204.6.camel@johannes.local>  <1248140853.3747.39.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jhvCPNBH9dOJwp+2lZo/"
Date: Tue, 21 Jul 2009 12:43:37 +0200
Message-Id: <1248173017.10870.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jhvCPNBH9dOJwp+2lZo/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-21 at 09:47 +0800, Zhu Yi wrote:

> > Should we even disconnect again in that case?
>=20
> Yeah, if one key setting is failed, it might not be worth trying others.

Well, even if the others don't fail, the connection wouldn't be working
properly in that case.

> This is true for iwmc3200wifi. But I cannot speak for other drivers. How
> about merge this patch first? This is clearly a bug because the firmware
> confused when it is told to set a key as default but never existed.

Agree, let's merge this first and then see how to disconnect.

johannes

--=-jhvCPNBH9dOJwp+2lZo/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZZvUAAoJEODzc/N7+Qma4eYP/RUEXw6laQQ3uvKfmDWONhqK
JwUik47i9yOeEwY0c4c/MKUmtJnJroES4MffbmDMvd8ONAxG/zjn3JqMRYfR71Ye
V2VGanpyUu+yLlhY/k8xDLWLOmdCCNCfO+XRL5+xauYELDS592AAsapFiTOSlk/5
RjP6OPueKItwS2e4ESsxvIQqJC2wfnZx2MK0ci/57fBYJ3uHTlbDdngHiobtiWQw
o414kFc4kX89RxAg/G56NcQraECbteAPtwTKPwJGxUcwhemVhLqHNXglP+MC9t0K
xb6SAqvJXyU4lMihFyS/c7oZ2HyqarBUrcBSserczHYojjHgjJGgO01rHPPO6QAG
l+2xIrjcGg64gfafYEI5ViYKp6c0PkOlxU5LXUY5gP/qwN+BNKWIk04sAySWdgKv
rjFtTatOoKgG1fenFkHNHQPMD1Ktfn8JOZywjcYwGS4jsXbMtzHz8GsOnK8f4lvp
LmPRURAyDf4XvWrdwqsJadK5vRNNkvHndRv92OOk/9al/08gKwZWvyILvmQucbKD
mRJZcRSc0dzxFN1ZhYjJr4sCHhTmEjfsN1Yo/tGNQvqU+m1uwIWrXGhT5ZdaZGs1
YrZGNvyc2YPUkdJw/5ujGK6Tm49uCqj9e4Y730hLEUCZ0VhtnFo/9SfCe4ohwaNy
7EwhXuNINDB2Rr/aOm22
=L28B
-----END PGP SIGNATURE-----

--=-jhvCPNBH9dOJwp+2lZo/--

