Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57894 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbXHQLXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 07:23:52 -0400
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1187328536.5763.137.camel@debian.sh.intel.com>
References: <1187328536.5763.137.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OiaKQoH+263VHOh954up"
Date: Fri, 17 Aug 2007 13:26:21 +0200
Message-Id: <1187349981.23489.162.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OiaKQoH+263VHOh954up
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 13:28 +0800, Zhu Yi wrote:
> [ My previous post doesn't show up on the list for a whole day. So I
> resend it now. I guess the an 800k mail is too big for the list... ]

Heh, yes.

> This patch (against 2.6.23-rc3) adds the mac80211 based
> wireless drivers for the Intel PRO/Wireless 3945ABG/BG Network
> Connection and Intel Wireless WiFi Link AGN (4965) adapters. I hope it
> can be merged into 2.6.24 kernel. You comments are also welcome!

I was recently reviewing encryption stuff---can you comment on why you
don't allow disabling hardware keys? For proper operation you really
should allow that.

johannes

--=-OiaKQoH+263VHOh954up
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxYXd/ETPhpq3jKURAsrTAKCKLpThgGz5zDBoB7N12Cp8AqtckQCfWTWy
Oto+TDBnoF7MK2l1ueGM2PE=
=8Ydl
-----END PGP SIGNATURE-----

--=-OiaKQoH+263VHOh954up--

