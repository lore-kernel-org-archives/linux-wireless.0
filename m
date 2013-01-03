Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3ACOmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:42:33 -0500
Message-ID: <1357224173.9741.18.camel@jlt4.sipsolutions.net> (sfid-20130103_154237_783254_5F6A01AA)
Subject: pull-request: iwlwifi 2013-01-03
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Jan 2013 15:42:53 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-fMzv5JoZ0wMTbu6WFkBX"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fMzv5JoZ0wMTbu6WFkBX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

I have two fixes for iwlwifi: one to fix a lost return value that was
dropped in a previous patch and could cause "nobody cared" IRQ messages,
and one to work around a firmware issue.

Please pull.

Thanks,
johannes


The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565=
:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to f590dcec944552f9a4a61155810f3abd17d6465d:

  iwlwifi: fix the reclaimed packet tracking upon flush queue (2013-01-03 1=
5:31:15 +0100)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: fix the reclaimed packet tracking upon flush queue

Johannes Berg (1):
      iwlwifi: fix PCIe interrupt handle return value

 drivers/net/wireless/iwlwifi/dvm/tx.c  | 24 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/pcie/rx.c |  1 +
 2 files changed, 18 insertions(+), 7 deletions(-)


--=-fMzv5JoZ0wMTbu6WFkBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQ5ZjtAAoJEDBSmw7B7bqr4BkP/2VqbRIJdrSsjE0XWyEjP8ZR
XGjboHZT7zAAlWtEZXLiODrh8BMjbnuH7de8LUPyES8UgmAYbzc2VDbxv9Yacatd
e2QEOK9qM8ODzsyUer9kV64ErsgFZFrM7X1KK6RRGI/dscF10EISwkmtMPA3R5Gf
QSk6DTVUXa3Z4InsUjogL/n9hWfYYR7IVhaQHafUq1innsRKnBqq/+bGB4X4bbGe
1unbT3k6yAVsh0uvuW+koTJaBXEFVZ+6UXFcmKw+SxdUXIWTGADyrytWcf96U58x
Rrj6eOxoFWi65Qm6CEQrkg7BR3m6J+eGLHmKxDuJfsxXk2O1nbsMFOufh9hizbms
THcMSRe2sl8x1REgXlBpi+bF6qplNlHyjN/6h3B7PJawsCNUBvxG03ydX0iSyrY8
wB6/my2rfLUPc7ih6FduUcHV8mGBTV5QV4YTsMPzAXWWr7sXDtbK0N5pjVWn52el
b5yZsN+QjmvjhJFNsFw/MP9CaUsafdUJ9FMA7KJNGiccSJclZbXVhkKuNrQ2PwGj
bt7wgOrHKUnjnKyzb2k4fq/Ine6cT6eZCG5KAaR+gkzA0CINPD0ljQJtA94UGes4
OohHI6tlAdj0cH3Q2iThgRTxKV3zb6R8X+r27qime55sPGex93gpJXCeUun061E8
K8ieQz1hfaJpTQG5ngYo
=EFva
-----END PGP SIGNATURE-----

--=-fMzv5JoZ0wMTbu6WFkBX--

