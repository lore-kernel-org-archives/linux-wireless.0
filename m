Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455AbXISPJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 11:09:54 -0400
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240709190805i6b703e0w885390a78eda9bdc@mail.gmail.com>
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
	 <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
	 <1190197117.4414.0.camel@johannes.berg>
	 <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
	 <1190204934.4414.17.camel@johannes.berg>
	 <1ba2fa240709190805i6b703e0w885390a78eda9bdc@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sgu18RCSuthD2d0GyVkG"
Date: Wed, 19 Sep 2007 17:11:10 +0200
Message-Id: <1190214671.4414.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sgu18RCSuthD2d0GyVkG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-19 at 17:05 +0200, Tomas Winkler wrote:

> I will do this favor for you :)  I will prepare another patch.

Thanks :)

You should probably base it against Michael's tree though:
http://git.kernel.org/?p=3Dlinux/kernel/git/mwu/mac80211-misc.git;a=3Dsumma=
ry
which basically consists of all the patches I had that we agreed on
should go in.

Oh and please also update the comment describing the callback.

johannes

--=-sgu18RCSuthD2d0GyVkG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8TwO/ETPhpq3jKURAnM5AJsG+35aKC4U1DV4aSqaCB75nQ12nACeLXYv
+5SiDC6Z79/eBrZza9+CVHE=
=gyvt
-----END PGP SIGNATURE-----

--=-sgu18RCSuthD2d0GyVkG--

