Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZHMTyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 15:54:49 -0400
Subject: Re: [PATCH 10/20] wireless: group Broadcom wireless drivers on
 kconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
In-Reply-To: <43e72e890908131246t44fe8c3eya3d3894810aeea7f@mail.gmail.com>
References: <1250191909-21682-1-git-send-email-lrodriguez@atheros.com>
	 <1250191909-21682-11-git-send-email-lrodriguez@atheros.com>
	 <1250192346.21250.6.camel@johannes.local>
	 <43e72e890908131246t44fe8c3eya3d3894810aeea7f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8qJCvxRBuJcihL5R8L8+"
Date: Thu, 13 Aug 2009 21:54:43 +0200
Message-Id: <1250193283.21250.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8qJCvxRBuJcihL5R8L8+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-13 at 12:46 -0700, Luis R. Rodriguez wrote:

> > Also, I don't think rndis wlan is always broadcom, and in an case it's
> > almost never marked as such.
>=20
> From the rndis_wlan kconfig:
>=20
>           "All of these devices are based on Broadcom 4320 chip which is =
the
>           only wireless RNDIS chip known to date."

Yeah, but it's more of a spec. Anyway I guess that doesn't matter much.

johannes

--=-8qJCvxRBuJcihL5R8L8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhG+AAAoJEODzc/N7+Qmah3cQAK70tZt9ezKGLmCJX7Oi6RV4
uxkLkk5ZGrW7YQDWja6loE50yhAM59OARBm7+WGw00KkxrgAMagRp9oKD7hbEOq4
ZtLa+Cjf/3OlSFeplpioW3MXbOxYLLCfJlFtsxmzyrEF1RZcsIvUXOoOzTuNf6fx
89Xmvh5a+Q6R3prCb8OTpFB9YVZibN5ZV/qZkNgP+lUpuwGUbibmCIKK97OBQ5OD
Op039739qpdsRTlO2/uE2n4Lh4ZZEUu7Rj7JfaDT4y3VDannBYbQSGz61oguQ0b/
KcTFkBzwWIY1CPE2QjEIuTburR5xURU5XPOPG3oxhD0kb7d+ROd6bUcVgxOYGnjn
qd0uhvYcc3L+jNiHgM+zE6rLM5/3NgSM42uL/dxzZx5GANCZe4dqP0oCOo2k++ua
JYJO8dgNJjZGINS+WSQq0eJo6uwVQtEP94JzjPrcHyCCq4F51/G5XSRfEwMe4PbD
WvSnU95vMOeddJ4I2QQTOKvWf9x+E74pxJ36VjSFJGLqDH9TVgS8Z7wwxn+tQnYl
03nnbFCHjk9NqlJlmCvMW65gvtRMiaV0/GYPoHxo7+/p/zlxq5eVd7JQxZjxzE46
KXzSWthbzZrR1V20xOsEHt/qUkv3ViIS82MWJROlCs43V6dO6w+QgTXpQ8tIiqX6
3XTPmXCxu2XSyVVnd2sO
=z4NQ
-----END PGP SIGNATURE-----

--=-8qJCvxRBuJcihL5R8L8+--

