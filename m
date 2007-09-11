Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762014AbXIKKWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:22:14 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240709100720k5156e11v775a5faa50144990@mail.gmail.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
	 <1189146702.16788.103.camel@debian.sh.intel.com>
	 <1189172436.28781.148.camel@johannes.berg>
	 <1189390172.24707.36.camel@debian.sh.intel.com>
	 <1189420954.4506.37.camel@johannes.berg>
	 <1ba2fa240709100720k5156e11v775a5faa50144990@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-810Vdr13Hto4gIlzdvh4"
Date: Tue, 11 Sep 2007 12:23:41 +0200
Message-Id: <1189506221.6161.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-810Vdr13Hto4gIlzdvh4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 17:20 +0300, Tomas Winkler wrote:

> It is my best intention yet first we need native interface which make
> in turn problems in eb tables. So it is a long shot.

Ok. We've managed long enough without it so I guess we can wait :)

> I wouldn't appreciate this at all. 11n is major feature of our NIC.
> Major obstacle in finally pushing 11n is constant  code base change of
> iwlwifi. This is already 4th  code base. The latest was because the
> driver didn't look nice enough, what an engineering   reason! In the
> bottom line we are hunting our own tail for wrong reasons

Well, I believe that there are bad layering violations in your current
driver, namely looking at the packets mac80211 sends, doing 11N
manipulations and everything in the driver and duplicating the sta_info
stuff because mac80211 happens to be missing a few hooks. If you think
those are "wrong reasons" that's fine with me.

Personally, I'm just raising these points and marking them down as
"against merging as-is". If others don't care about them, that's ok with
me.

johannes

--=-810Vdr13Hto4gIlzdvh4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5myt/ETPhpq3jKURAgIVAJ4yxOr6Z94sWoWsJsePRnqOzrXwvQCgqExd
GmUcqYje8RCxQudbqkzQ9v0=
=Rdw7
-----END PGP SIGNATURE-----

--=-810Vdr13Hto4gIlzdvh4--

