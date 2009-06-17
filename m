Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbZFQQxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 12:53:33 -0400
Subject: Re: Power save / 11v support feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Ramesh R <rramesh_1@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <933839.92475.qm@web54506.mail.re2.yahoo.com>
References: <933839.92475.qm@web54506.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Hcicy2+tjI/kgbElvLaV"
Date: Wed, 17 Jun 2009 18:53:02 +0200
Message-Id: <1245257582.31588.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hcicy2+tjI/kgbElvLaV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-17 at 09:09 -0700, Ramesh R wrote:
> Hello,
>=20
> I am interested to work on the power save /  11v support. Is someone alre=
ady working on this?

In what sense would you want to work on it? I mean, on what in
particular? 11v support probably needs firmware support first so unless
you have a device you can hack for that you're not going to be able to
do much ... ar9170 comes to mind, but doesn't really have powersaving
anyway.

And just general powersaving, what actually remains to be done? Could
look into supporting uAPSD on station side, I guess?

johannes

--=-Hcicy2+tjI/kgbElvLaV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKOR9rAAoJEODzc/N7+QmarPoP/0KPd/5IV1fqdst4cdRffVyc
6BPdY/XL10TFgQIGLhCy6BmcMDb5t9LVMebbtHgANdQU7UYJqZcG+M8KrqZrAWhS
0J3AdmY4G3ybsKanVfuWMUa7b5x9069Dxu/OvMTOjDI65qEdZpoxuWEiaT287GVr
9WCQNPpkKADdna607yGBj6fMYs8FZCXCFBsrkmXg/BS+ytKPt+RKQlUyMx9P3gPP
2RG1WtFlZwijV8K+CSqtCx5SAjP+68HAS0+crrVMv+wL+6haRkWIxdrmdsMoQ/US
4EfzRAVliB7K1JIU2US0uxQd4XwqZDjRuCJ8b8iuQLC5mv/ZPNd0ja/VipBcPQ1f
nOiPoccncSg2UDXz46aY8TPdfUrhfeuRdfBnmsYQIu1kf6/SpR/1zuaPSptKTV08
wY/mEgLI9bRGLkVEDcEU6Je09gHcqs53ajuokVKvGY9772Eo9ClteaCu7runtU0d
Lzalm86ro1mEJ1NGDEi7nna8xpBHo55cN5G8yiiEkFUx6eoToJwNsVSv7lArF9Dn
UF3jIO2L9UCIgOAU1+QWZfO1uSNk33AC9rAYbaM5zOYuZwUr+eQG4yP7PpSIt0R+
UgtAL5u6hBqF7LrPW8pt7DukuAB8spZ0Vqi/FISzTP921BUg95YLwdwkxP0bSa1h
WS/Abup13ST26178D009
=HJdL
-----END PGP SIGNATURE-----

--=-Hcicy2+tjI/kgbElvLaV--

