Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbXGTHhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 03:37:43 -0400
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and  channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <46A050B4.3060500@warmcat.com>
References: <20070611103828.961999956@warmcat.com>
	 <20070611103914.577674038@warmcat.com>
	 <20070719191052.GC6603@tuxdriver.com> <200707192139.14930.mb@bu3sch.de>
	 <46A050B4.3060500@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mAo+M1zopIaJ6jJb/bcp"
Date: Fri, 20 Jul 2007 09:37:24 +0200
Message-Id: <1184917044.23536.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mAo+M1zopIaJ6jJb/bcp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-20 at 07:05 +0100, Andy Green wrote:

> After seeing patch tracking issues on arm-linux mailing list as well,
> those not involving me, I started making a PHP project called
> "patchfillet" for the purpose of extracting patches from a mailing list
> and trying to track the patch lifecycle in an automated way driven by
> the contents of the threads (eg, keywords like adding Acked-by: <blah>
> in a reply) and maybe one day by looking at an upstream git repo commits
> (I found that the Index: line in git-committed patches can change
> destroying what would otherwise be a hash match).

Sounds like `patchwork'.

> I must say an explicit ACK or NAK for patches is a great idea.

I'd also appreciate explicit davem-style "thanks I merged this" but hey,
I get by checking the various git trees all the time :)

johannes

--=-mAo+M1zopIaJ6jJb/bcp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGoGY0/ETPhpq3jKURAjftAJ9F2tUKZGo7IQyRObZOWfYitKzzoACfbXo7
rkndBLuH1JqxcuOZnRqzWh0=
=pw6i
-----END PGP SIGNATURE-----

--=-mAo+M1zopIaJ6jJb/bcp--

