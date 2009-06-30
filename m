Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZF3G7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 02:59:54 -0400
Subject: Re: [PATCH CRDA] Introduce separate HOST and TARGET compilation
 steps.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1246310952.15012.22.camel@jdl-desktop>
References: <1246310952.15012.22.camel@jdl-desktop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tpOQyTaSclRInNrLv1Rk"
Date: Tue, 30 Jun 2009 08:59:50 +0200
Message-Id: <1246345190.16256.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tpOQyTaSclRInNrLv1Rk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-29 at 16:29 -0500, Jon Loeliger wrote:
> The regdbdump tool is really a host executable that is used
> during the build process.  It could also be installed and
> used on the target, but two separate compilations are needed
> to achieve that goal.
>=20
> Currently, regdbdump is only built for the target, and thus
> cross-compilation of the tool is really feasible without
> this patch (or one like it).

I don't think John is the correct addressee, Luis maintains this still,
afaik. The only thing I'm not sure about is the separation into host/
and target/, but otherwise this seems ok to me.

johannes

--=-tpOQyTaSclRInNrLv1Rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSbfjAAoJEODzc/N7+QmaTM0P/0kz92GtkMHTS6cGzGYAgKxt
2zTwy2lD14JmcgHOZvhj6O6sBZ0Nmm8kT7oXJVcZGqcjcPwFEb0GQ8Q5WoPZZG+Z
AVq+QoRt/6UgP08Rz+IpvzlQ7jPVMZgQbF/kzHqyAgqY5OvRQNvkBU6MT9UvHGuF
UuzQSgT0zE4hWkTMxLiIQuHdlFOboehGQek0W3S++BMqksEWv2jFF2hl0/o40iLO
mR3B4Jctw55BZLG1Xxv7ldyQA73H2KxDn0UmA6GYlq9Hb8Hiaf9jb4GrMQtkQhiw
jZgkosdBH1XqOQdz4F9j2aNtyHgwIlDKwlMWO0YWzSgnDpLLaF9sQXbT2XLC2FgI
9O5leo2ncIuDqm3i6dvFulz8OyqywSjFwb5vHrlaXqvNAv2NFBj3DsGx0v5YJ4fZ
Y7qxXR4r7r2xsxeoijGjJISP8uSzBYjpVx9hWrqW800RH3Le0VJ9MfodNqG2W4Xe
tyQAl7+9HTZ/o9q/DeRcpAibWcKfjviThi1t4+ofhctZacYSNKVnG/JerCyTxhxT
je7oekAhm3f64wz0sdRmnxUcVdk1bB5CJjiU0pTNskdj4vBwRbsNoElMPmrJWPIp
A+18/OelY1dYr4SiKhrnDGJb6uXSSpkLPax0pqwD7lz9aZWXf3WmaEVO9psjfv4q
+GKvxCISsM6DQNxT/k7d
=g2Hv
-----END PGP SIGNATURE-----

--=-tpOQyTaSclRInNrLv1Rk--

