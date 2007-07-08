Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:49984 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755646AbXGHWor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 18:44:47 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Arrested Development
Date: Sun, 8 Jul 2007 15:44:17 -0700
Cc: Ulrich Kunitz <kune@deine-taler.de>, Andy Green <andy@warmcat.com>,
	Jon Smirl <jonsmirl@gmail.com>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <468DE699.9040708@warmcat.com> <20070708203717.GA15957@deine-taler.de> <1183929814.3771.5.camel@johannes.berg>
In-Reply-To: <1183929814.3771.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3691536.SJSavnNomx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707081544.21464.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3691536.SJSavnNomx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 08 July 2007 14:23, Johannes Berg wrote:
> This isn't going to work properly when you add a sta interface and then
> a monitor interface, which afaict the driver doesn't prevent in
> zd_mac_open. Basically, it has the phy always follow the last-added
> virtual interface which doesn't seem right. Also, I might be missing
> something, but it shouldn't allow multiple sta interfaces, afaict it
> does now.
>
It doesn't allow more than one interface, sta or mntr. mac80211 does soft=20
monitor mode interfaces for zd1211rw when a sta interface is already up.

=2DMichael Wu

--nextPart3691536.SJSavnNomx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGkWjFT3Oqt9AH4aERAkjZAKCnHSi+GBhXtjHk6X8WcctLv1A0BgCfQeeB
gdqlP00os1UhJjGdGfEht+M=
=boyp
-----END PGP SIGNATURE-----

--nextPart3691536.SJSavnNomx--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
