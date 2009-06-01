Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbZFATWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:22:25 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090601175631.GB24704@khazad-dum.debian.net>
References: <20090601122839.GB11011@khazad-dum.debian.net>
	 <1243859931.5299.17.camel@johannes.local>
	 <20090601124553.GE11011@khazad-dum.debian.net>
	 <1243860606.5299.21.camel@johannes.local>
	 <20090601133351.GI11011@khazad-dum.debian.net>
	 <1243866545.5299.25.camel@johannes.local>
	 <20090601153620.GB15485@khazad-dum.debian.net>
	 <1243870669.5299.29.camel@johannes.local>
	 <20090601155020.GC15485@khazad-dum.debian.net>
	 <1243871606.5299.30.camel@johannes.local>
	 <20090601175631.GB24704@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8gMqmfCTpeX7/TgrPgjM"
Date: Mon, 01 Jun 2009 21:22:18 +0200
Message-Id: <1243884139.5299.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8gMqmfCTpeX7/TgrPgjM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-01 at 14:56 -0300, Henrique de Moraes Holschuh wrote:

> I have a stable userspace ABI that exposes a sysfs control that the user =
can
> use to enable/disable bluetooth and wwan.  I need that thing to remain
> working well for at least one more year before I can try to remove it.

Ick, ok. I guess I may need something like that later too, so patches
welcome.

johannes

--=-8gMqmfCTpeX7/TgrPgjM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJCpnAAoJEODzc/N7+Qmarb8P+wdYEVRyDGsvWAqb+ypFHK5B
vVXAbVwXTUTj7OEjsVgToOg5QcuPise5lusuLm3fO0gezAaF0LUOx8xyIsfj7+yy
sAXydK2nOqPbQ6hJe3PLm3ScrVsDzGasE0TJtZbA+2Yok+YCHTadz4FI9ud+lX5K
MYQkbJoZuoIwZy8J+NrSIhiC76gG6AX2b/iTsF21xftRgfE313tn2FZ+Zds8/aeA
tCPQKR0Ob/MCdYho9Kw/2AsJc9MLXWocx4ZRMkWgLyO2vne4pGkD32fSAOPjJ5Rz
qrX22Zoe2j0IklYGxn7nBraEbjoc2s9w1FmizzivrEGjFOCkR32TWDOm597FRDdr
DmaCm7H1S/qFxbd9BIHsz2aRAeVLbyJfC3fQk05z6Xgf3mRa0IoKfFyRcXQ1VumP
wqwIsfaxb6epmoWxa1SMwcex9tk967MLZEuytGcX1fEN+2XR0/aJpMyP+JOuwfmJ
N0tI2OnY/sLK3m7VepYY2PgSDgTSZF6iLde2l1A6RlbGWs2JoN3knf4FDtKUZ8s9
tTiXM7N1SgO5kKeytmkw8UY55FmsBE3x7nF1zBTpNxplc/idiHN+dssy3YG2O/sY
XB2QEUhfG7JG+LFHVu8nEV1cz+Kriv3XYJwTfI353TIZLF97hLQkpNrCfoT3sgin
lzOvD53ANhxA3eTYx27m
=vAji
-----END PGP SIGNATURE-----

--=-8gMqmfCTpeX7/TgrPgjM--

