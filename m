Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZHRHPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 03:15:21 -0400
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
In-Reply-To: <20090818003550.GG15363@mosca>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
	 <1250283993.4411.1.camel@johannes.local>
	 <43e72e890908171000r52f59cb6tbfef751324bf9968@mail.gmail.com>
	 <1250545069.25876.0.camel@johannes.local>  <20090818003550.GG15363@mosca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qp32+d+PrgUWSOiI4akQ"
Date: Tue, 18 Aug 2009 09:15:16 +0200
Message-Id: <1250579716.25876.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qp32+d+PrgUWSOiI4akQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 17:35 -0700, Luis R. Rodriguez wrote:

> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: [PATCH] wireless: make mac80211 select cfg80211
>=20
> This lets us keep mac80211 on the menu map even if cfg80211
> is not enabled. We now remove that pesky comment about this.

>  menuconfig RFKILL
>  	tristate "RF switch subsystem support"
> +	depends on CFG80211 || !CFG80211

That's backwards.

Now you can still have CFG80211=3Dy and RFKILL=3Dm. And RFKILL really
shouldn't depend on one of its users anyway.

Just leave it the way it is please.

johannes

--=-qp32+d+PrgUWSOiI4akQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKilT/AAoJEODzc/N7+QmazrAP/1/sOyRiMh/daRsipER+6rKN
aqXNb78NauSM+BNe36yr3DPnHpGb34EwaXU4qKa1T7Z6jsnmS5WLZAg3m68SU/EJ
fO/BOiODxVLLDa5O8FzK8DRRPmxSYNWI7rpdl7g46Xbw6nsXI5Jf4iUDzQ06/p4s
vjFPTgXbby1EomD0Z0ZYi90vPo8Kaxv2vzM9A8Y03pbMEer2xm7iVgMt7gv5332T
HYIis3Ikgh/qdxG1k7V+bzhflTxKT568i3IjJsE7BvZLU3i0ioucU84XrF8iAe6h
U9oC9/A7xjG7DvRKmPb4j6rgqU7U6cZNpQnz57dQk2Qd4A7l9kmLUYH61YRuBSqO
Q5ZmWrF5hRaoq1k8phMtLuXxobMhhWA1VdFmrYRHbG60sFfbockwR5P/PVWr5Dh+
RxyS0JF2ybkcAkkW4JMxKNvGHcmXwj1SkX+vAEdLFJRzGRZa3KHuUAK9BNPH5Uw+
7BZqX3MrroUXcEBui/DHT+ssP2dtLXg+yBDjKWUypBs7R/WF6T4LVDdeuDh2Zsk8
lrIRBXi7SSah8QiorPWz9hpfb+zKEdxQAbZCygbNG2495GLHs8tRbr2K7XZ+50jD
KcLcK7acbVmN9w0RkzJ8JhkqMtDcsG2JiqOdJjNiK9nZkZsc2wZTg8kchRUZR8YD
AU+WL0axiEAtBlrlqXlp
=O2xu
-----END PGP SIGNATURE-----

--=-qp32+d+PrgUWSOiI4akQ--

