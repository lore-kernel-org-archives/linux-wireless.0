Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZAYQY5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 11:24:57 -0500
Subject: Re: [PATCH 00/12] cfg80211/mac80211: few fixes/enhancements for
	regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FwbcMK6SYDXesEcZg4Zl"
Date: Sun, 25 Jan 2009 17:24:50 +0100
Message-Id: <1232900690.3952.10.camel@johannes.local> (sfid-20090125_172459_954594_E0F71ADD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FwbcMK6SYDXesEcZg4Zl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 15:05 -0800, Luis R. Rodriguez wrote:
> This series contains a few fixes for cfg80211 such as another
> fix for parsing country IEs, but mostly contains work to help
> drivers build a more useful reg_notifier().
>=20
> This new series handles strict regulatory settings by introducing
> a wiphy->strict_regulatory setting. OLD_REGULATORY is left but
> as can be seen it leaves room for cruft to build up.

I'm not sure I agree with all of this, it seems a little restrictive,
but the code changes seem ok to me now, thanks for bearing with me.

johannes

--=-FwbcMK6SYDXesEcZg4Zl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfJJQAAoJEKVg1VMiehFYqGQQAJxAqjRWQHGogU2SJHJpLBzJ
lRefb8hY/Jtm9pdWGucPEnmtHUBmdzhaFQSXT4kdjgNUgNfgl+yHh6Fr1bXdZaYa
JZWsj4OGt2lVKLtpO5npPiho1HWFZSiFHUK4EWAkKqdTQUkJvDegt9uhoHyktbXF
jspL3F0DFD7iOnbZH12C65zOp1lyJbG1yndCb0bXguiQIvR0h7GEqho2dx83dvS3
0Pwkeh83urY0VKywR1cFT0oBH9TPUByPxRu/mKl+uuwxgR7NJoZCIVLkhsANP7vy
ATpFOSyWlzR4oeyKcqYwhwK5os1d6V2spodiwFE0i2eZvsnSXweuMrye20LDRjzK
2/kL6sKbkWCAq4coLSmudegcNYjF7FdI0t6mj0BT+Shb8K70dVjj4Jln8EEA0s19
cdMr5m5ZkJFTN71Q3KULnChhRPV7c/mcWprzKmi/PSLQcEoC2vMZSPX5Esim/0Sr
zDx9ZnVyamKbsVfS0F/GFZWdxo6SJBuWK1tLpwRO20OsfgFLuYg7fta3nNJbH3ap
SxjYLum4bYmNzr5Dli/m1dL21uJHxM7v9AURdllUn3ntOYjdtBWvtabZ4xhRiXLj
kP+anOIy9mjR6+3kO8l3d+BGBIqwny7kX0kTwJAM6w8sVcuJVBRzUS9DjKqafvf8
sKDOe8G53stZJi6W0sCO
=dEm3
-----END PGP SIGNATURE-----

--=-FwbcMK6SYDXesEcZg4Zl--

