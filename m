Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbXIDOC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 10:02:57 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1188875058.13078.428.camel@debian.sh.intel.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kQ/5rcrdDlKFYw+pQXUY"
Date: Tue, 04 Sep 2007 16:04:11 +0200
Message-Id: <1188914651.9942.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kQ/5rcrdDlKFYw+pQXUY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-04 at 11:04 +0800, Zhu Yi wrote:

> Note, the #include "../net/mac80211/ieee80211_rate.h" still existed in
> this version of the driver. We are discussing how to abstract the
> mac80211 rate scaling interface in another thread in this ML.

You also haven't addressed any of the other points I raised wrt.
encryption [please try running your driver on the latest
mac80211/net-2.6.24 tree, it'll complain very loudly], looking into
frames, using the configured MAC address instead of the programmed one,
oopsing if pure monitor mode is requested, doing frame aggregation and
all the others.

I think this repost is mostly useless for review, I applaud that you're
working on things but don't see why we'd be interested in this step.

johannes

--=-kQ/5rcrdDlKFYw+pQXUY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3WXb/ETPhpq3jKURAix9AJ9LWtE5vhBWXlKrHrhY7ng1bFmaXACfbPG7
eHBqCADY1MSYojmaEJNQTUo=
=rbdb
-----END PGP SIGNATURE-----

--=-kQ/5rcrdDlKFYw+pQXUY--

