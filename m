Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXISKRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 06:17:32 -0400
Subject: Re: [PATCH 1/1] mac80211: add sta_notify callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
References: <1190036530108-git-send-email-tomas.winkler@intel.com>
	 <1190054680.23521.23.camel@johannes.berg>
	 <1ba2fa240709180951v3dc0a98ay11205296fd5768a@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1+wDVWJoOIQZ1hg70Kef"
Date: Wed, 19 Sep 2007 12:18:37 +0200
Message-Id: <1190197117.4414.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1+wDVWJoOIQZ1hg70Kef
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-18 at 18:51 +0200, Tomas Winkler wrote:

> Actually I'm interested in this feature 4965AGN HW supports multiple
> MAC addresses.

> > so, would the firmware be able to distinguish between the same STA
> > sending WDS frames and trying to associate?

> Yes it will

So that means you should add the if_id to the sta callback, no?

johannes

--=-1+wDVWJoOIQZ1hg70Kef
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG8Pd9/ETPhpq3jKURAj8mAJ4pPrigwPkYWlAPnCULH2cYcUB3nACfSvPf
oZ3sFankFAs2Fp5b8BkRGOs=
=AfgO
-----END PGP SIGNATURE-----

--=-1+wDVWJoOIQZ1hg70Kef--

