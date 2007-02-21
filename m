Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbXBUKpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:33 -0500
Subject: Re: [RFC PATCH] d80211: fix build break from netdev class_device  -> device changes
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, jbenc@suse.cz
In-Reply-To: <20070221005811.GA3875@tuxdriver.com>
References: <20070221005811.GA3875@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jYM1vcNQgP9XLFyXP8+3"
Date: Wed, 21 Feb 2007 11:45:16 +0100
Message-Id: <1172054717.3705.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jYM1vcNQgP9XLFyXP8+3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-20 at 19:58 -0500, John W. Linville wrote:
> In preparation for 2.6.21-rc1, I pulled Linus' latest tree into a
> branch of wireless-dev.  I hit a build problem with the sysfs stuff,
> due to the recent changes from class_device -> device for net_device.

Hmm, need to look up the reason and see if wiphy stuff should follow.

> Since I don't count sysfs as a strength, I thought it was worth
> posting this for some review before I actually pulled Linus' latest
> into wireless-dev and slapped this on top of it... :-)
>=20
> Comments?

Seems fine. Is to_net_dev() defined in netdevice.h now?

OTOH, we might want to take this opportunity and move it all to
debugfs ;)

johannes

--=-jYM1vcNQgP9XLFyXP8+3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3CK8/ETPhpq3jKURAg78AJ9AX5vFJ9fFQWiP6DmqFLf4ds3vtgCggnlz
dtyZEzxDNpqk9jyOlljxluE=
=yrDn
-----END PGP SIGNATURE-----

--=-jYM1vcNQgP9XLFyXP8+3--

