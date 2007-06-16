Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXFPM1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 08:27:10 -0400
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	David Lamparter <lists@diac24.net>
In-Reply-To: <200706140935.50779.flamingice@sourmilk.net>
References: <20070611085950.GA5540@mail.intel.com>
	 <1181635570.4758.22.camel@debian.sh.intel.com>
	 <1181806608.9058.22.camel@johannes.berg>
	 <200706140935.50779.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CeTQRiAMkj6Eg92Uj6nl"
Date: Sat, 16 Jun 2007 14:27:35 +0200
Message-Id: <1181996855.9058.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CeTQRiAMkj6Eg92Uj6nl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-14 at 09:35 -0700, Michael Wu wrote:
> On Thursday 14 June 2007 00:36, Johannes Berg wrote:
> > For me, that settles the DLS API. That API is easily implementable by
> > the userspace MLME as well.
> >
> This API is unnecessary. The most that is needed is a bit indicating whet=
her=20
> or not an sta_info entry is DLS or not.

No, it's not unnecessary. In London, we said that we wanted the
(userspace) MLME to be controllable via nl80211 from userspace. Hence,
we need API to do DLS setup/teardown because the (userspace) MLME is not
going to be the program making the decision about DLS and we explicitly
said that we want the MLME to be controllable via nl80211 no matter
where it lives.

johannes

--=-CeTQRiAMkj6Eg92Uj6nl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGc9c2/ETPhpq3jKURAirgAJ9JUTBGjftsYb4RODTFWY6xAQ+F8gCeKO49
+HUyJ57CZGuCpJ/KB5IAMAU=
=xHKZ
-----END PGP SIGNATURE-----

--=-CeTQRiAMkj6Eg92Uj6nl--

