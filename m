Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60772 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYLKS27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:28:59 -0500
Subject: Re: [Patch] nl80211: Add signal strength and bandwith to
	nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812111922.49439.hrogge@googlemail.com> (sfid-20081211_192652_073998_62A7776A)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812111902.24289.hrogge@googlemail.com>
	 <1229019287.8081.49.camel@johannes.berg>
	 <200812111922.49439.hrogge@googlemail.com>
	 (sfid-20081211_192652_073998_62A7776A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6n3hL9B2LKhJ2/AJjI/d"
Date: Thu, 11 Dec 2008 19:28:21 +0100
Message-Id: <1229020101.8081.55.camel@johannes.berg> (sfid-20081211_192902_642305_2B659E04)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6n3hL9B2LKhJ2/AJjI/d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 19:22 +0100, Henning Rogge wrote:

> > This needs documentation for __...after_last and ..._max too, I think,
> > or kernel-doc will complain, and then I get email on the next daily git
> > update and complain ;)
> Is there a script to check for mistakes like this ? I used checkpatch.pl =
and=20
> it did not complain...=20

well, apply the patch and do

make htmldocs DOCBOOKS=3Dmac80211.xml

Actually, hmm, I think, that won't help, because these files aren't
included yet. Heh.

johannes

--=-6n3hL9B2LKhJ2/AJjI/d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQVvBAAoJEKVg1VMiehFYDW4P/RNYcWPEld9AQ2Rp1yDQ71P/
ZWlpfQDGQohOy/pPMlzzZRq6Ek5lvBXar/8sziIKl4vBdKVNRsm/+8QAgAMJ3zlu
htfxIP8Ln6J6PxOmPw8NGukVeKe75qAuYBdvyel93TmHsgY7+QSeP+cAb648bvBa
uYae/LDX0mUEHtKTJu2wrHWxVt3VjJz9pUyTzs9EVE9khY54SSrKwRfD6xLjrp65
mYLIWd/reXV4fCyRS36mT86oJgap2exr15Edkyrqarj3b6gG2+86ENAXmcDVXdOj
TqPFVM3MkH6XTpMnThrKRR8lh2VCOPC1wSrvtrSh3zcjHHGM5lBJQfP+ghj8Qpog
wRe/wivYHAMk9p8av9SKa9Sl2Y4Uhk/+2PGzRD1sCWNG8qKsO0ah790o6NPYMRHW
Jq0mzIqPIMAdGoNjsTsgqPW0Js83Rqyf35e6Ebg6FPrqCz0nwKckTBRuBZRUrcvQ
kbvs61b/BaDTRMgOPpGEgF3VheEpQVd5P/KqwaDe36EkSvn5FDocMG5hdM2E1290
rFdh9Ylk0g/ijD/cjd8fLxEeJZ2zK73FZsWEJt8+EYzy/RHZSQ5/AQxm5kjiA5e9
VPg3cD1WDJHSZEZTbQuwIUfAU3W+PdQfK2aCNOnTLmy3V3WgchIwKw9yrsr+4TcB
LMHvx9IAUGffDxdt/sne
=aVSm
-----END PGP SIGNATURE-----

--=-6n3hL9B2LKhJ2/AJjI/d--

