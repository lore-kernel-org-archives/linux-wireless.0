Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbZGJQhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 12:37:45 -0400
Subject: Re: [PATCH] cfg80211: don't look at wdev->ssid for giwessid
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247243579.29747.6.camel@johannes.local>
References: <1247241214.29747.5.camel@johannes.local>
	 <1247243482.2877.14.camel@mj>  <1247243579.29747.6.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mIjORnfGufo/CwOoQMNa"
Date: Fri, 10 Jul 2009 18:37:40 +0200
Message-Id: <1247243860.29747.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mIjORnfGufo/CwOoQMNa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-10 at 18:32 +0200, Johannes Berg wrote:

> Dunno, switching is definitely working for me... And I can't see how the
> code could _possibly_ fail.

Yeah so the GIWESSID code is correct now ... just not SIWESSID :)

johannes

--=-mIjORnfGufo/CwOoQMNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKV25QAAoJEODzc/N7+QmaqxAQAIjSgN8RUP98gYKQONSfBC8Y
lgliovh/FpzVeNBXdQ5ZBipoKBfD0FFvH6VMKBQGRkNMKCNSMyB+YPb74d7NIcE/
gV2eFpspiJPkcVHRBPLGwiRS8gC7UqUKCUCiU67H91iMQ22X1QQbJHc0+lCB5b0S
ikHoNZINH8xqT1GJCFmP9rKSbgtbehY5kNJbu1GpGN13BgzhFVvZOU0tHHL4LNrC
uexxU1VjnG5+7ZJEXWel0VSoSAn06xExuoymYutE4EED8nuD2Tj24HDh7eTzdT3f
8HI+WryrKpr8Hgmk+iqVvjh6WxUfxOAmIaPLbXHmNTvNy1RYzDVaT+Y2vLWZWZHI
7ZwEI545QPi8qHxjMg+4iSIIyzPzY8OYRrli1jyignQtciTHa0/7NJdDyi6Pd7NJ
pqOOnZGRMIchZj6twYOewK2jTRiWPjcfDL+6vxrmthIsEPx41x55qDjH3OeZk/Jf
gI80imjLYTBaZjOwaCkf0pRMFDd7SM8IiG5/JXZmJ+ZoNSgjBJK5fcc3L+FoCabD
avf2Xwch5+dz4FkDUaKD9uF0DhnhkZUc7EjsdjG2AMTvAvVfdL+V9MdbrWwIN8WU
udv+ckNa3Z5SrXZXJj6wNEZfxJTkl/G9hlm/41RcyNh3toxZCte2AjZDD08mq3CB
95WYb135ij/OLqs8VJQJ
=AzZL
-----END PGP SIGNATURE-----

--=-mIjORnfGufo/CwOoQMNa--

