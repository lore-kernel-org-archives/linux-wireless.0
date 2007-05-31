Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51986 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759166AbXEaT6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2007 15:58:15 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [TAKE 2][PATCH 0/3] IEEE802.11e/WMM TS management and DLS support
Date: Thu, 31 May 2007 12:55:36 -0700
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
References: <20070525115205.GA23301@mail.intel.com> <20070531180445.GB3706@tuxdriver.com>
In-Reply-To: <20070531180445.GB3706@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14227755.zkWdLR6rT9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705311255.40416.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart14227755.zkWdLR6rT9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 31 May 2007 11:04, John W. Linville wrote:
> On Fri, May 25, 2007 at 07:52:05PM +0800, Zhu Yi wrote:
> > The following patches updated my previous IEEE802.11e/WMM patches
> > based on the comments from Michael Wu. Please apply.
> >
> > [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
> > [PATCH 2/3] mac80211: IEEE802.11e/WMM TS management and DLS support
> > [PATCH 3/3] mac80211: debugfs support for TSM and DLS
>
> Yi,
>
> Please also submit a patch series that applies against linux-2.6.22-rc3
> (or later) and adds whatever else might be needed that is missing
> there.  This one changes code that is currently only in wireless-dev.
>
> Thanks,
>
> John
This is nowhere near ready to go upstream and it requires some bits from th=
e=20
802.11n patches which didn't make it.

=2DMichael Wu

--nextPart14227755.zkWdLR6rT9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGXyg8T3Oqt9AH4aERAr6HAKDWmJN17E20PpL9H6qPmvrT7kcxJwCbBMOd
VXS7HgdmdCwEIC8y5e0O07M=
=ehLG
-----END PGP SIGNATURE-----

--nextPart14227755.zkWdLR6rT9--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
