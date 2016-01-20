Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:35055 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934611AbcATQsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 11:48:54 -0500
Date: Wed, 20 Jan 2016 17:43:22 +0100
From: Andreas Kemnade <andreas@kemnade.info>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, hns@goldelico.com
Subject: Re: [PATCH RFC] wireless:libertas: enable auto deep sleep
Message-ID: <20160120174322.67fdbc27@kemnade.info> (sfid-20160120_174901_135902_AEA866C5)
In-Reply-To: <87lh7k2zi0.fsf@kamboji.qca.qualcomm.com>
References: <1453275709-25276-1-git-send-email-andreas@kemnade.info>
	<87lh7k2zi0.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/keIKodY7MAUe+ZxVB_NL_Ip"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/keIKodY7MAUe+ZxVB_NL_Ip
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jan 2016 14:42:47 +0200
Kalle Valo <kvalo@codeaurora.org> wrote:

> Andreas Kemnade <andreas@kemnade.info> writes:
>=20
> > Enables auto deep sleep whenever the interface is up and
> > power managament is enabled, so there is also power management
> > when there is no connection
> > That reduces power consumption between scanning
> > intervals. Deep sleep mode is entered when there is
> > no activity for 1s.
> >
> > The code looks a bit different to how things were done
> > with the wext interface in earlier times.
> >
> > Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
>=20
> Please use just "libertas: " as the prefix and drop the "wireless:".
>=20
Hmm, is there any rule for that or do I just find that out
by analysing git log output?

BTW: That patch depends on my ieee80211 powersave mode series where I sent
a second version today. Has that series found the way into your review queu=
e?

Regards,
Andreas Kemnade

--Sig_/keIKodY7MAUe+ZxVB_NL_Ip
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWn7k0AAoJEGGrpYhZ30HuKnYH+wdvsx9s/F9lAWgYttQHvWQm
VcCvEAb633FVdkpzmc1StQZN8QBtQNJDJFWZmZn5rHZCSWnFlT2yn5o5JJzpRcNW
eSMhswvzKoDN18FGGoSXPvJQUjAkW+1rQHcLRBNyhDZQ0XRxlWFV5oxglyrwPs2Q
Hc2zSAviTPkhuIvcilA7o7H+SKd0SDBtTBuIeHf2AqeFicxX+fYJP4VHuYvN76p0
bUWDt/Bki5CC8wEJVw0fnWMgNJ0vXFmVY/ESfl6oRDpJap24bnMYz3bHHRQ1O2bt
Em7/8LmiYjMy66x/i5PJzPAeaK7dJbLJQ612XjWMJIDhNPnEr//xwNq5FCQmjVs=
=V9zg
-----END PGP SIGNATURE-----

--Sig_/keIKodY7MAUe+ZxVB_NL_Ip--
