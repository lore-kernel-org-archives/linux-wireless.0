Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbZGOJij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 05:38:39 -0400
Subject: Re: [PATCH v3] cfg80211: rework key operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247647086.3695.48.camel@debian>
References: <1247051586.4755.81.camel@johannes.local>
	 <1247052613.12857.0.camel@johannes.local>
	 <1247055774.24749.0.camel@johannes.local> <1247647086.3695.48.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KvTR+9R3U8YnWn5S6cUM"
Date: Wed, 15 Jul 2009 11:37:46 +0200
Message-Id: <1247650666.14973.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KvTR+9R3U8YnWn5S6cUM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 16:38 +0800, Zhu Yi wrote:

> This breaks wireless-tools for WEP with fullmac cards because "iwconfig
> key" doesn't send the AUTH command. Is it expected?

I did expect it to break iwm because I couldn't make sense of the iwm
code, unfortunately, sorry about that. But the key needed for
authentication should be being passed to the connect() call too.

johannes

--=-KvTR+9R3U8YnWn5S6cUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXaNkAAoJEODzc/N7+QmamTEP/A+Kbt5NBtoZS7x/63ajdrO9
Zq82PPFTIJvUyXWqgrnAGqJaQIN49GyrHQq7P2X4DPAapw81moEjh/yrMvgIcDgu
5+1aJihh+XrpjTzeqO6L3Xi+jvjsUsZHsdZbyL+aaT/SHngLyIiI1gNquoFjCvqG
4LDh/oP27U4KfXvLu40UGMSVHA1sOOFw9wgMyGA+DSrb3rp0hcIrHB3Qqu0jQaVu
sEbJj5zj0Ysd7yauEqWC+wxRUU5ZdOAiwz6OTbDf6iKyX6UEs7+CTl712IG6xlaA
7pHbUSvy8JO/uDxFSXpmtrU9ode5WtJCqEqEQmlpkOMYdGv8gGRSrM6xWQd3C2lv
wIY0gBEMOkckD0E53yXww98+vKIGS66dquOb/z3aqMcvd1kkfcQnRbvwnSLUXuJX
VJjxOIh6/TZ3uM6Gp/tOTH8ppqU/aIFuphVBWB1rwC6V9EPAvOxNzq56Y6ODmNC7
ZotsTMAhAB4EwuvTjmSjWSTUPjliuQJYkeMQt4rgeNN09PzmmOflq566Nj8a6rQZ
iF5bBN2G84QB/wkHItD1LTmKX23eRWWQuYsXSwBpH15VSsIfMaA4c6jGSWNVMtC4
IXMhfwB1oOupW3UWJULCqpoEzZ/q4EnQmfo0LbsvFHvNhU2bQiDlVIBDVIAZNhOi
FFuHXq9Pf/mC0KBd7KCv
=s4OG
-----END PGP SIGNATURE-----

--=-KvTR+9R3U8YnWn5S6cUM--

