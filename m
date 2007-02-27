Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbXB0K5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 05:57:05 -0500
Subject: Re: [PATCH] wireless: rename d80211 -> mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070227032756.GA6569@tuxdriver.com>
References: <20070227032756.GA6569@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sUoaeRw3mk0XysWJBgMP"
Date: Tue, 27 Feb 2007 11:56:35 +0100
Message-Id: <1172573795.3870.244.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sUoaeRw3mk0XysWJBgMP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-26 at 22:27 -0500, John W. Linville wrote:

> I've changed all references in wireless-dev from d80211 to mac80211
> and from D80211 to MAC80211,

And I notice that by "all references", you really mean it:

-T:     git kernel.org:/pub/scm/linux/kernel/git/mwu/d80211-drivers.git
+T:     git kernel.org:/pub/scm/linux/kernel/git/mwu/mac80211-drivers.git

johannes

--=-sUoaeRw3mk0XysWJBgMP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5A5j/ETPhpq3jKURAnkxAJ0UyGavGErC33RPj89/d9zac0j+xgCgreb2
/mqrDvnoxkNIG2cwWnjOSrY=
=x2oM
-----END PGP SIGNATURE-----

--=-sUoaeRw3mk0XysWJBgMP--

