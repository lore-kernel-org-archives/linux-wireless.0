Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXDUTvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 15:51:31 -0400
Subject: Re: mac80211-7.0.4 ieee80211_ptr trouble
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dick <dm@chello.nl>, linux-wireless@vger.kernel.org
In-Reply-To: <20070421185622.GA7019@tuxdriver.com>
References: <1177144052.9892.8.camel@localhost>
	 <20070421185622.GA7019@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fLnN5VvVDmh1Bs/gVLJ8"
Date: Sat, 21 Apr 2007 21:54:14 +0200
Message-Id: <1177185254.5941.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fLnN5VvVDmh1Bs/gVLJ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-04-21 at 14:56 -0400, John W. Linville wrote:

> > /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compat=
ible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_get_hw_fea=
tures':
> > /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compat=
ible/net/mac80211/ieee80211_ioctl.c:119: fout: 'struct net_device' has no m=
ember named 'ieee80211_ptr'
> > /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compat=
ible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_scan':
> > /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compat=
ible/net/mac80211/ieee80211_ioctl.c:172: fout: 'struct net_device' has no m=
ember named 'ieee80211_ptr'
> >=20
> > What am I doing wrong, what happened to ieee80211_ptr?
>=20
> You'll have to ask the gentoo guys...

Nah, he's compiling James's stuff against a kernel that doesn't have
ieee80211_ptr, afaik James used ax25_ptr for this or something... Looks
like you forgot some header file.

johannes

--=-fLnN5VvVDmh1Bs/gVLJ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGKmvm/ETPhpq3jKURAlC1AKCnMa7rbhQGtMjDTzt1hoUbM07WEQCfWd4v
z8R6OrKwFI7T5wIkVJFLYS4=
=7fTB
-----END PGP SIGNATURE-----

--=-fLnN5VvVDmh1Bs/gVLJ8--

