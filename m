Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757736AbXHCJl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:41:29 -0400
Subject: Re: [RFC V2] bcm43xx-mac80211: Provide information to allow  transmission rate decreases
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <46B1F201.7060107@lwfinger.net>
References: <46b0f367.p35iGhSXwM+v4QLG%Larry.Finger@lwfinger.net>
	 <200708021337.21285.mb@bu3sch.de> <1186055319.24230.32.camel@johannes.berg>
	 <200708021503.53982.mb@bu3sch.de> <1186060034.24230.48.camel@johannes.berg>
	  <46B1F201.7060107@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-smIy+bNp5Tbc4geXKyDA"
Date: Fri, 03 Aug 2007 11:40:01 +0200
Message-Id: <1186134001.4647.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-smIy+bNp5Tbc4geXKyDA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 10:02 -0500, Larry Finger wrote:

> When I first started investigating the problem of mac80211 not reducing t=
he rate as I moved away=20
> from the AP, it seemed to me that the decision regarding excessive retrie=
s should be made in=20
> mac80211, not in the driver; however, I have had extreme difficulty in ge=
tting any changes into=20
> mac80211 on several occasions. Linville assures me that he has had privat=
e discussions about this=20
> problem; however, I needed a quick fix and couldn't stand any protracted =
discussion and/or review=20
> delays. I knew Michael would be tough, but that his comments would not be=
 delayed.

Agreed. There are definitely problems with getting things into mac80211
and I've complained about that in the past.

> At the moment, I have more pressing matters to resolve than fixing this p=
roblem in mac80211;=20
> however, I feel really good that the port of bcm43xx-softmac to mac80211 =
has this issue.

I think that a great many other drivers will have this issue too.

johannes

--=-smIy+bNp5Tbc4geXKyDA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsvfx/ETPhpq3jKURAnfjAKCHXLuSZe8Pk6mW3ytJUTR2GndVxwCggNyb
FXP16CCjy5YIDJSnR2nUdBw=
=0KcQ
-----END PGP SIGNATURE-----

--=-smIy+bNp5Tbc4geXKyDA--

