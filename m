Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbXHOKtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:49:49 -0400
Subject: Re: [PATCH] hostapd: remove use of  ieee80211_msg_key_threshold_notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070815034312.GK1415@jm.kir.nu>
References: <1186782285.17351.19.camel@johannes.berg>
	 <20070815034312.GK1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-l4eHPL/hSpRpXCdI8xqE"
Date: Wed, 15 Aug 2007 12:49:44 +0200
Message-Id: <1187174984.3998.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l4eHPL/hSpRpXCdI8xqE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 20:43 -0700, Jouni Malinen wrote:

> Just like ieee80211_msg_sta_not_assoc, this one is a useful notification
> and I would rather not see it being removed. Consequently, I did not
> apply this. I would be much more open to changing this notification to
> use some other mechanism if there is a reason to get rid of
> ieee80211_msg_* types, but just removing this because the code is
> currently #if 0'ed in hostapd is not a reason I would support.

Same as with the other one, I'd like to get rid of the ieee80211_msg_*
stuff with the hacked-up prism2 monitor mode header. Again, here I've
extended the TODO item to cover both sides, where the implementation
ought to be in nl80211.

johannes

--=-l4eHPL/hSpRpXCdI8xqE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtpI/ETPhpq3jKURAtJMAJ9zqK92Owqe9cxfBokdS4QlH0kmEQCgk1FI
9lje0vFCiSNFmajo5Dzp9dI=
=X/VA
-----END PGP SIGNATURE-----

--=-l4eHPL/hSpRpXCdI8xqE--

