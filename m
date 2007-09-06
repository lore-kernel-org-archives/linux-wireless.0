Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbXIFOph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 10:45:37 -0400
Subject: Re: [PATCH 03/21] mac80211: revamp interface and filter  configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	Li YanBo <dreamfly281@gmail.com>
In-Reply-To: <20070905234622.671760000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
	 <20070905234622.671760000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tsKtUEobmabUV5K/K9F+"
Date: Thu, 06 Sep 2007 16:46:53 +0200
Message-Id: <1189090013.28781.97.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tsKtUEobmabUV5K/K9F+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 01:42 +0200, Johannes Berg wrote:

> +/* show frames with failed FCS, but set RX_FLAG_FAILED_FCS_CRC for them =
*/
> +#define FIF_FCSFAIL		0x04
> +/* show frames with failed PLCP CRC, but set RX_FLAG_FAILED_PLCP_CRC for=
 them */
> +#define FIF_PLCPFAIL		0x08

For those wanting to uses these flags I should notice that the b43 patch
is currently incomplete, it doesn't set the related RX flags on the bad
packets. This doesn't matter for now of course because we have no way of
enabling these flags.

Also, I should note that the next patches in this series document these
better, I just split that up for more technical reasons. I could roll
the changes into this patch but I feel it's not worth the effort of
rediffing everything.

johannes

--=-tsKtUEobmabUV5K/K9F+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4BLd/ETPhpq3jKURAswOAKCQRvE4gbKPwflnW+siYQCiRk9mrQCgl2GO
AhEEuKKWSmSO9n+1RHPyVhA=
=D96m
-----END PGP SIGNATURE-----

--=-tsKtUEobmabUV5K/K9F+--

