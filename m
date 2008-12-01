Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYLAThp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:37:45 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1228152631.10900.6.camel@rc-desk>
References: <1226969241.4014.24.camel@johannes.berg>
	 <1228152631.10900.6.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H/z0b+k2hrzX/fAEy6XY"
Date: Mon, 01 Dec 2008 20:37:09 +0100
Message-Id: <1228160229.10627.38.camel@johannes.berg> (sfid-20081201_203748_832753_964D3BEE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H/z0b+k2hrzX/fAEy6XY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Reinette,

> Above you mention that this patch fixes bug #11596. Could you please
> explain how this patch addresses that problem?

That looks like a mistake, I don't think it can fix that bug. I probably
pasted the wrong URL, I had a whole bunch of iwlwifi bugs open
everywhere around. I apologise for any problems caused by this, was this
bug closed erroneously?

johannes

--=-H/z0b+k2hrzX/fAEy6XY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJNDzhAAoJEKVg1VMiehFYqqIP/2RDfMdaHklkSUzI7ekwVPiU
5OJgX3YlzNG/xHRwerVyC9BSadIE9cjqXpcfB5QIYipd5l2P9qcMa6U+vZV9lZox
/wR57tk2M3Pb3rCE7I8sluGjNL7fh9xxqtXeT7vHRJaFbtJhxtWBbOB1TyWtH8/t
m305j/ZLS3YK4pFM8S4ysA6apn44uhAmKAMyB0RTbYmi4MVKDzpzXGlM9WRsXd9E
8SRUmfYJgLtg1qfwzdEMs2ykd6uMEPI1ZX/gUMyTPbQwBnIeZ3ok+1n2rn7hyaYA
qNXv1C8xK+y2nCXvQvgr3oe6poyvsHKoYfoRXU4+t6NzNnkRAX5Z5pxjWvwmEiZ3
+aCT6SAYKSVpMkxhG9WHhIhyh2MO/4iKCO180TpYxD0Pw15fUFyiPtzRiB6nENPU
Pct8SgBggCSN7hBtJAMQTqEonf4Jazntw1/fQ3t9CB904Zem9c7IqOHIqO7tPfeD
7iO/d7bs0CECzSftbk9osFEKxfMNsDNRUQNOTJHXlZLUXIUn7KjnHdejjyH7xc7h
ZbT6ydCMp+FYRpXI+eTT0Gz0zGCQ+xwiJ/DBGXoTeM3CCWOdzhfCy1LzOaYjZyoa
ZYb9YizkqY60wPFTrOoiyfCnfQmWNe4VYM7XK4b9fpLAX+H+kTEgrZqzeUJ1JVTc
RNXzS4+q0/z5I7ja5jWl
=nuUe
-----END PGP SIGNATURE-----

--=-H/z0b+k2hrzX/fAEy6XY--

