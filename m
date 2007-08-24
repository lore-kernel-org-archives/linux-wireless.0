Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXHXKMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 06:12:48 -0400
Subject: Re: [RFC 09/11] mac80211, iwlwifi: remove atheros turbo modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1187942429.13078.104.camel@debian.sh.intel.com>
References: <20070823164500.998912000@sipsolutions.net>
	 <20070823164524.799041000@sipsolutions.net>
	 <1187942429.13078.104.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v9OZHSut0LdhYCEmIHVy"
Date: Fri, 24 Aug 2007 12:09:51 +0200
Message-Id: <1187950192.24933.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v9OZHSut0LdhYCEmIHVy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 16:00 +0800, Zhu Yi wrote:

> ACK. iwlwifi doesn't support turbo mode. The code was there for
> completeness. I agree with the removal.

Good. I noticed another problems with this patch that I'll be fixing,
but I am still curious why you define channels with turbo that are named
11N or such?

johannes

--=-v9OZHSut0LdhYCEmIHVy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzq5v/ETPhpq3jKURAhDuAKCV+VEUrqX4Kf2mXWpl9XDXh44hrQCfbPZ0
4bh4cXgotTi/oJrBe6JH1ng=
=/Jx6
-----END PGP SIGNATURE-----

--=-v9OZHSut0LdhYCEmIHVy--

