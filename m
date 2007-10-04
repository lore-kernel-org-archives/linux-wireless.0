Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:30623 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757636AbXJDQ6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 12:58:15 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] mac80211: Fix TX after monitor interface is converted to managed
Date: Thu, 4 Oct 2007 12:56:15 -0400
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20071004113343.552139D502B@zog.reactivated.net> <20071004085440.008216c6@freepuppy.rosehill>
In-Reply-To: <20071004085440.008216c6@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3822380.ChMOfOQO4F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710041256.20995.flamingice@sourmilk.net> (sfid-20071004_175826_596971_08602375)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3822380.ChMOfOQO4F
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 04 October 2007 11:54, Stephen Hemminger wrote:
> Playing with the function pointer is a awkward way to do this.  Shouldn't
> the state management flags be used instead (dormant, running, stop/wake).=
=2E.
> I am concerned about races and dereferencing the NULL ptr.
This is all under RTNL and the pointer is only modified while the interface=
 is=20
down.

=2DMichael Wu

--nextPart3822380.ChMOfOQO4F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHBRs0T3Oqt9AH4aERAqhjAJwJwuirxBJEqpdxneUd2T0uLq2/CACfaMv4
wL/Xmkli1yjGD62ROVqXWZ8=
=7+ee
-----END PGP SIGNATURE-----

--nextPart3822380.ChMOfOQO4F--
