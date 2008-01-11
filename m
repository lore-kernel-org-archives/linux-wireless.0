Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761250AbYAKVzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 16:55:50 -0500
Subject: Re: [PATCH 3/8 v3] mac80211: A-MPDU Rx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470801111020w6de28dc7jb58f0eacac513978@mail.gmail.com> (sfid-20080111_182042_195677_DA70E5F6)
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
	 <11985948451654-git-send-email-ron.rindjunsky@intel.com>
	 <1199976980.3861.87.camel@johannes.berg>
	 <c85cb4470801111020w6de28dc7jb58f0eacac513978@mail.gmail.com>
	 (sfid-20080111_182042_195677_DA70E5F6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PK5ocoJjeqDlkO8NJ0xY"
Date: Fri, 11 Jan 2008 22:55:34 +0100
Message-Id: <1200088534.3528.4.camel@johannes.berg> (sfid-20080111_215602_395608_901CC095)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PK5ocoJjeqDlkO8NJ0xY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-01-11 at 20:20 +0200, Ron Rindjunsky wrote:
> >
> > [32566.907283] rx BA session requested to stop on inactive tid 0
> > [32566.907290] rx BA session requested to stop on inactive tid 1
> > [...]
> >
> > I suppose the message isn't really necessary except from
> > ieee80211_sta_process_delba(), or something. Either way, we should get
> > rid of it in the regular case.

> what about putting it inside CONFIG_MAC80211_HT_DEBUG ? i don't want
> to lose this print, there are several cases were it might help - timer
> expirations, delBA, and fragmented frames.

I'd prefer not to get it even with HT_DEBUG enabled when I had no chance
of doing HT in the first case because my hardware can't handle that.

johannes

--=-PK5ocoJjeqDlkO8NJ0xY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4fl1aVg1VMiehFYAQJo7g/9EFycSLDprLSugcN0uBoTBHhW6pij8q/Y
4U6dFcG2x9yQ8d7g8pehOaPxefvh+iMELsRDN3CYJ6oG/hsbrKIddjXT/Uqckxxx
zSpn5t8t0Pi+xXDvcnig8s6EUvn+KJXUtWFFMc0qRkKLaz4KYqfZQqNMXR6MC2ph
oEnG6EyzFGOaQl0ID7WBy0ziPySPufwoIVW2arQSSPcTpbNgFOvUiEVSPIljzAJL
t6g1qiilweclYQvNo1EOhScYyNlioHdAt476+P3bxUMKiLqLxLptXrz2T7ABYs1h
GXNg3k7NZNdjSn26lMHlw1rQUuf+4CSZjc5aYPjE18Jsk904HbcRRMn3k5Uim91R
MHqEpzDL6ahbffXjZ7E8wfw9w4UsfqmbA6E0xwj9WwiWXfbXMx24067wsu8azffs
R6kL07W9GA2EDkmhO2ybSrPtgkScmOP35Bn38Qb6KOZCfMjAXt89u+k/9alWI3WB
54gMPgY5OCNivnZUDl0Sw3gijChLaHPFsIjdkYCBu7OdfAaTvVcXN98lY/uyR0Qb
Foh2tCpws+bkIsMvlg+899wAhE9G43v9LOfcAzDlIbvmWwcho/4pVod9K/a1Sk++
SkOcBGx8svjtGas2Jyl17XrokdhK6UfhbbW/LwGdsKlFckmwzXqf+2CHXOdRJqDx
YoP/jSNsJVU=
=mNRp
-----END PGP SIGNATURE-----

--=-PK5ocoJjeqDlkO8NJ0xY--

