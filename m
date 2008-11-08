Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYKHHKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 02:10:03 -0500
Subject: Re: [PATCH 0/2] Add reg options for intel regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com> (sfid-20081108_030116_424285_074E898A)
References: <1226109668-13778-1-git-send-email-lrodriguez@atheros.com>
	 (sfid-20081108_030116_424285_074E898A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SLuzWfEs+oE5rmayXjeR"
Date: Sat, 08 Nov 2008 08:09:44 +0100
Message-Id: <1226128184.3610.0.camel@johannes.berg> (sfid-20081108_081017_903472_91DD2647)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SLuzWfEs+oE5rmayXjeR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-07 at 18:01 -0800, Luis R. Rodriguez wrote:
> As we discussed we can ignore the first hint for the
> iwlwifi drivers. This adds that work. Please test and
> let me know what you think.

Looks good to me, thanks. Of course now we have to live with the slight
discrepancy here between hw, so rememember to ask for 'iw phy phy0 info'
output when something goes wrong :)

johannes

--=-SLuzWfEs+oE5rmayXjeR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFTs0AAoJEKVg1VMiehFYUEkP/0oWIEcOfqo93/0iZHApMs05
i9mLljgvnec+DExtx6JPcStML3OyuqmLf7BQZIfc40YLqfxwNIKKSZWl8alm54Lf
wtFaXB/sBE0x9xGNz9wXMoDgc50c72SB1+Od4krnSeCP9NmT5d8TSLsKkEhhJ16s
C202fKQ8ABhyeBFfD9rCUWNpmxcIitVxF4Hg3b8kopV/hXNPJT3q2+sjydji2IIq
7FaMAd0+zS+/iv9cTOl5OjvzDui9ud+S8Ezov8hi7hiYyfbrzISN2XAcNuzINfdC
IMgSBTnHLHFonMFEAbB0inQRwSCrDdrxLEcKRB5upHFSdDuIMfJLLRsGIELUBHVG
oN3Q6bXIAX8ad4Yg1YRh683+2oms4noK49xFFUbpi/YJ14R5vxyZQbTsmaz2U0Ny
Vn85b+s7KXYHaOt0mfD8Hi9WZSYvSUoF2QSy3yLQNQ3m5TyRSnQs412RPSqMs148
K9LF65N0koUb8QrnNvNFUk5dmKEycaEc0UIXeAGQ043ac0mg6iF1q98Yuvsx8TSh
OpLUiloZnvgVOg4vCrKRvm8ZHoH8y2wkDrEGNSeJ874G4ye+9F1S6sqA5CJ/4DYS
/LAqIqaOsauJyY36EeK3PZr76C12GmcHn45DrZuyfddHAvfDaphh5cRGF/X/PVM6
09gvcKUgr2d8enf93iVU
=W1lO
-----END PGP SIGNATURE-----

--=-SLuzWfEs+oE5rmayXjeR--

