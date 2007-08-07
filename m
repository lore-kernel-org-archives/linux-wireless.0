Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbXHGJx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:53:29 -0400
Subject: Re: [PATCH] mac80211: fix tx status frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: jbenc <jbenc@suse.cz>, "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1186475037.4067.14.camel@johannes.berg>
References: <1186475037.4067.14.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MLDEjVGqbrB76O62OKNI"
Date: Tue, 07 Aug 2007 11:55:10 +0200
Message-Id: <1186480510.4067.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MLDEjVGqbrB76O62OKNI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-07 at 10:23 +0200, Johannes Berg wrote:
> When I added the monitor for outgoing frames somehow a break
> statement slipped in. Remove it.

This should probably go to .23 as well as -stable.

johannes

--=-MLDEjVGqbrB76O62OKNI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuEF+/ETPhpq3jKURAvkEAJwMXT1wlbLCX7TPFprM1zucSPhJ/wCfXupz
1nnjnlJqCHwCCYwfL91D2gk=
=fXH0
-----END PGP SIGNATURE-----

--=-MLDEjVGqbrB76O62OKNI--

