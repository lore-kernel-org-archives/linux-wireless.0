Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760169AbXH3PAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 11:00:41 -0400
Subject: Re: oops with recent wireless-dev tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Jochen Voss <voss@seehuhn.de>,
	linux wireless list <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com, netdev <netdev@vger.kernel.org>,
	Matthew Wilcox <matthew@wil.cx>, bridge@linux-foundation.org
In-Reply-To: <20070830074949.7cd25b04@freepuppy.rosehill.hemminger.net>
References: <20070829223752.GA6969@seehuhn.de>
	 <1188475530.2963.20.camel@johannes.berg>
	 <20070830074949.7cd25b04@freepuppy.rosehill.hemminger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-msTEZMDPb3e8RRSHWxSV"
Date: Thu, 30 Aug 2007 17:01:31 +0200
Message-Id: <1188486091.3978.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-msTEZMDPb3e8RRSHWxSV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-30 at 07:49 -0700, Stephen Hemminger wrote:

> Devices aren't required to have ethtool_ops. The code there used to
> call ethtool directly, and it would handle the error cases. I'll rollup
> a fix this morning.

Great, thanks.

Jochen had a patch: http://marc.info/?l=3Dlinux-wireless&m=3D11884271502661=
4&w=3D2

johannes

--=-msTEZMDPb3e8RRSHWxSV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1tvL/ETPhpq3jKURAok+AKC7kBAPAr/8QsVZ/N4g9POGLiK2ZgCfdXBz
D2Zv2GZuwyXdQUg6iphWb14=
=wpiP
-----END PGP SIGNATURE-----

--=-msTEZMDPb3e8RRSHWxSV--

