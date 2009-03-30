Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbZC3UoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:44:19 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Dirk Opfer <Dirk@opfer-online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <200903301336.52883.inaky@linux.intel.com>
References: <1238349195.24972.5.camel@johannes.local>
	 <200903301954.07008.IvDoorn@gmail.com>
	 <1238436058.5970.24.camel@johannes.local>
	 <200903301336.52883.inaky@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qXwt3X32EBle0Ut6j8EO"
Date: Mon, 30 Mar 2009 22:43:45 +0200
Message-Id: <1238445825.5970.37.camel@johannes.local> (sfid-20090330_224422_298261_B7D11220)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qXwt3X32EBle0Ut6j8EO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 13:36 -0700, Inaky Perez-Gonzalez wrote:

> I guess there is both history to both; Johannes, you are right, in this
> case the hw rfkill kills the radio in HW and *we* send the input event.

Ok.

> Reason it sends the input event is because I used the rt2x00 code as
> reference...

Right, but rt2x00 doesn't kill the radio in HW.

> So, if you guys all agree that passing this to the input layer is not
> needed,feel free to yank it.

Ok. Except I don't know how to handle wimax_report_rfkill_sw() yet.

johannes

--=-qXwt3X32EBle0Ut6j8EO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0S7/AAoJEKVg1VMiehFY5uEQAMD0qTFuwFNSVvsIRo6+lBWG
EZK9UA/czrdsbrELBmSLd2giIUEbsBXwn6324jpwX/1CfN6w7tTnS9FL7pTU9EBa
Ofv09q0MLssWl6SxLtYE3kJTzoDzrbJvFBqgFfZKyNa2D9RSpqOPz4pNTwkfgThW
D6xvs2lyCSvpGKB9F/bVSl5Jjw2AbKYCsoCKEVQDsPmx8zjB15hQF3y2yxWiHnwO
+O/nB/CW7+WD+1a00TpRbDTTIbsvEWTNqnUCt0dmbSvDy9x1xzfc02JpC3lPvXDD
DAb1SoCb+PXwTikexy2bv0ayMy8xwJNhucPYBdjGun+CPV4f36E0MOFEiU4AGKzW
bMG2vuShjBWHfZf6+1nsAdZdwcpoKWAHkPL1zM0ZWYlFHROb8mFhNC5Q17TjioI5
mHJQIKOi7oadlm+p1XIB3k+XJBRHEFnLkWuqMLC2IFzx17DQCfDYBpOc3zrS7SNG
olxI9G0LtDrGV6JQA3wpzsHKDfdALdITw1fz1VpuAcgk8D9PfJU4FhsJgUaR7Mpi
ZXMtJtGHOEeK+3MPQKAzy1zJhH0Wd+W8f09d9pXst5fl/xaYq5k0kMAdrjCpKmY7
rP45rkNH3Tj8jxmbNS0rk9cNGfV2cthyl45B3iuaEBCMJ/ZmLcWbPph6MqMhWLXE
cTvw//FRAidHHFAWR00a
=405X
-----END PGP SIGNATURE-----

--=-qXwt3X32EBle0Ut6j8EO--

