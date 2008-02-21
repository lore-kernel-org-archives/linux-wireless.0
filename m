Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYBUT0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 14:26:38 -0500
Subject: Re: [PATCH] mac80211: fix IBSS code
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: bruno randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080221170710.GG3094@tuxdriver.com>
References: <1203588513.17534.138.camel@johannes.berg>
	 <20080221170710.GG3094@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i8JLZF7eZz+TDihKkgwD"
Date: Thu, 21 Feb 2008 20:23:56 +0100
Message-Id: <1203621836.26341.4.camel@johannes.berg> (sfid-20080221_192648_224496_0BD18894)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i8JLZF7eZz+TDihKkgwD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-02-21 at 12:07 -0500, John W. Linville wrote:
> On Thu, Feb 21, 2008 at 11:08:33AM +0100, Johannes Berg wrote:
> > This patch fixes two errors introduced by
> >=20
> >     commit 19d35612f3cd7f60dd9174c0100584e21f5a1025
> >     Author: Bruno Randolf <bruno@thinktube.com>
> >     Date:   Mon Feb 18 11:21:36 2008 +0900
> >=20
> >         mac80211: enable IBSS merging
> >=20
> > The first error is an endianness problem that sparse found and
> > the second is a build failure when CONFIG_MAC80211_IBSS_DEBUG
> > is not set.
>=20
> I think I like Pavel's fix for the CONFIG_MAC80211_IBSS_DEBUG build
> issue better.  Do you want to repsin the sparse warning bit?  If you
> like, I can respin it for you -- just let me know.

Eh, where do we stand now? Bruno wanted the message to not be rate
limited in the DEBUG case, and the endianness fix is definitely
required.

johannes

--=-i8JLZF7eZz+TDihKkgwD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR73Py6Vg1VMiehFYAQLagg//Zq6zyevLjRq+UUu4nycJFj5dMnri+BrX
/YQceRaPXMDY4lJ7wCzMGMQ3DC4UVCNedIeTimTlkZhB+59FGZXti9GkLyDu2QCR
0EuiiNu1A/sRfLFjQaOcm/6d6FrQJuihQP9lsgiuVOwocEcB9u5opv7M5IQw93V+
6K+VAgsPzVy0eAC1HP96aMXarLjFwgshPxtmwQ3ZaOee3DPzCgiIzSWmoEGhFahf
yiP+MgQwyvnP/uU96b1cN9fwANFmwjVPtF9qH9vpQsENuSMeXAH74/yGV/QeTdH5
8U+a5XoWZoD2z2IwXyyZxRU9BqtdoLqdU1IS8LGQ2tf/xkSQEZ7Pi49y10r2REP5
HMNxZU22yFKACirVvVOmgFTvG+ZLxsnIzTx6IAwl2fUZBiXrq7xSPNtkwm9d/p46
n0+MWNyiuCm2oaUMKyjtfIb1Qak5nxZE3yX2gBy7eXq7N31rG+CSboclagRapEfV
nJ00wG/0Ab+zsOZK/ROA6QDGqFLRlvuqaZjawZC+A/BYNYmOns1ryMRaSIs0OWhf
gcCqDIZQYRBVxBNLTnPUQrxXdHqpjYSk4PM6d/TVElXxkcd2HcZA7LWz1ucOuOnu
iqxVY+h5CfgRdOCD9w5BJjOCsN/93qIQarj3d5SwGCwIh1pyxFdesl1qObHys23F
WvHbQTt2lcw=
=Oeue
-----END PGP SIGNATURE-----

--=-i8JLZF7eZz+TDihKkgwD--

