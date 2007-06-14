Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23543 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750725AbXFNQhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 12:37:12 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
Date: Thu, 14 Jun 2007 09:35:45 -0700
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
References: <20070611085950.GA5540@mail.intel.com> <1181635570.4758.22.camel@debian.sh.intel.com> <1181806608.9058.22.camel@johannes.berg>
In-Reply-To: <1181806608.9058.22.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1686703.CBhJz8jC7S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706140935.50779.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1686703.CBhJz8jC7S
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 00:36, Johannes Berg wrote:
> For me, that settles the DLS API. That API is easily implementable by
> the userspace MLME as well.
>
This API is unnecessary. The most that is needed is a bit indicating whethe=
r=20
or not an sta_info entry is DLS or not.

=2DMichael Wu

--nextPart1686703.CBhJz8jC7S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcW5mT3Oqt9AH4aERAnrxAJ9LaPIKUME5puEIkozALX7TykcmfgCfdiaw
MndIp+5XG2/bRWfvpQTXyec=
=9Wnw
-----END PGP SIGNATURE-----

--nextPart1686703.CBhJz8jC7S--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
