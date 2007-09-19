Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXISM1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 08:27:42 -0400
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
	 <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
	 <1190197117.4414.0.camel@johannes.berg>
	 <1ba2fa240709190438o5032df52mb22a97546bdbe563@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mPeW+MnX/dB2eiaanjLr"
Date: Wed, 19 Sep 2007 14:28:53 +0200
Message-Id: <1190204934.4414.17.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mPeW+MnX/dB2eiaanjLr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-19 at 13:38 +0200, Tomas Winkler wrote:

> Yes, yet I'm not sure I want to deal with it right now.=20

Well, my patch making sta_info be per-if isn't ready yet either.
However, once I finish that patch I'll have to touch this callback to be
correct, and then I will need to fix iwlwifi for using it which is not
really nice. Hence, I would very much prefer if this callback was
correctly defined in the first place and the driver simply ignored the
extra information it currently doesn't need.

johannes

--=-mPeW+MnX/dB2eiaanjLr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8RYF/ETPhpq3jKURAvSnAKCfPKVWKbsWh6fn6V9qxkKQjBGWvQCdFacp
JCEnZsNZFIns753IIyW36mU=
=2OcZ
-----END PGP SIGNATURE-----

--=-mPeW+MnX/dB2eiaanjLr--

