Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761144AbZLKLvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:51:37 -0500
Subject: Re: [PATCH 07/31] wl1271: fix tx power setting function
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1260531682-4695-8-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
	 <1260531682-4695-8-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YLk9fEDfGUOwuTstp+bP"
Date: Fri, 11 Dec 2009 12:51:37 +0100
Message-ID: <1260532297.2442.126.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YLk9fEDfGUOwuTstp+bP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-11 at 13:40 +0200, Luciano Coelho wrote:
> The wl1271 firmware supports maximun 25.5dBm, so the driver was returning
> -EINVALID to anything above that.  The new mac80211 stack uses 27dBm as
> default TX power, so we were never setting this correctly.

??
Just indicate a max of 25 in your channel registration max_power.
cfg80211/mac80211/regulatory code will not go above that.

johannes

--=-YLk9fEDfGUOwuTstp+bP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIjJFAAoJEODzc/N7+Qma4coP/3rdssCJ70koc92t6I+odZ5q
/R9/dkaJoaxhxPhMmfA9Z8NKswFD676o1sGxLPaA15qbgKF6wZpIb9r/DZqOoFmu
wmBIdYodCfQHkFMYDsWiCRaZoPGVfwBRWaOBQ2cAWJ4bQU56SHdLd8mCFPxcLvim
bfYNBpcbw8mYA5P/RW3/NU2yuWb26UzlqwofIy85X7mFwKTmaVoYQ/VViYZ9J6ab
6OQD3nukOlPihDypyX4OsAAcdLy81PcGHEa2HrYrCsQyOjFwYeWyYLA9KXJdFR1h
I2C16Q1FiCQAad3TxKnMsoih7YZANfQP4bC0fr95V4v5rECn78D8j4MgVUW73TiQ
sK82aSXAni+Z84czNOqNnTqIq4KL4q3VjzfqOecgMp0NcJ1Tf6GZadB+SMBDqpi3
lNFn/OnSQkNM9e7cdbCvYLQUqmdZNamSMPT3A+J0sKBJLjLo80Jo2z4zltjT+qGE
WPsbeTqJgjx8RGyqc9Qd/ANNOwD+ZCYwzZYaNhB5BfBxfE9LN/DnMcoMQcj5oFZk
j4RlDQLB7sYgdsm1gpRmGFFb1gUM24ON/2phQ8Jfd/Je48Aha27smYMsKgiftdpP
sUIWoJIHisRXufHf0mqh+6J9Vk0BEb9Sip1SzGGzc4kIVN5r51vBPnmmAJgCEeB5
4AyeCVOU9dscCYgR9xPA
=Aymj
-----END PGP SIGNATURE-----

--=-YLk9fEDfGUOwuTstp+bP--

