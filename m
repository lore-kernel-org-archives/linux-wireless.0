Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762723AbXG0W2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 18:28:20 -0400
Subject: Re: mac80211 git tree reworked
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070727175716.32242e3f@griffin.suse.cz>
References: <20070727175716.32242e3f@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w+B+/Y0S8Gb9T+M5HE7C"
Date: Sat, 28 Jul 2007 00:28:52 +0200
Message-Id: <1185575332.4006.70.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w+B+/Y0S8Gb9T+M5HE7C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

> this will most likely be unpopular, but it was a thing that needed to
> be done to make mac80211 tree manageable again.

Why unpopular? The general reaction I've seen (and I second) was
"awesome" :)

> Creating the up-dev branch meant modifying all mac80211 patches in
> wireless-dev, as they sit on top of Johannes' restructuring patches
> now.=20

Whee :)

> I started to do the same with cfg80211 and nl80211 patches but it
> turned out that many cfg/nl80211 commits overwrite each other as the
> interface was evolving and being rewritten. So I decided to throw away
> the history and make a patch (surprisingly, it's quite a nice and
> relatively small patch in the end) that brings cfg80211/nl80211 to the
> state in which it was when mac80211 was merged to vanilla. Patches that
> were committed afterwards are committed separately on the top of it.

Sounds good to me. It was changing quite a bit at the time, yeah. It'll
probably continue to do so if somebody works on it again...

> What are the advantages?
> - Johannes' restructuring patches go in.
> - We have patches prepared for merging of wireless-dev into vanilla.
> - mac80211 patches can go to vanilla and will appear automatically and
>   correctly in wireless-dev.

Cool

> [In fact, I'd like more another approach but I'm not sure how feasible
> it is: apply mac80211 drivers to a separate branch than mac80211 in
> wireless-dev and pull both of them into a common branch. That way I'd be
> able to rebase mac80211 tree to keep mac80211 patches always on the top
> (and modify them gradually as fixes, especially to 11n and WMM,
> appear). The big disadvantage is that pulling from wireless-dev would
> become much harder.]

Actually, that just means that John has to pull both mac80211 and
drivers into master everytime he updates one of them. Or something.

Good job!

johannes

--=-w+B+/Y0S8Gb9T+M5HE7C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGqnGj/ETPhpq3jKURAs2HAJwMws9uKId0srZWY3sMvQyJBKTGRQCfQrOh
eJ5NWCubj0AyoSockX5GHSM=
=Rg8C
-----END PGP SIGNATURE-----

--=-w+B+/Y0S8Gb9T+M5HE7C--

