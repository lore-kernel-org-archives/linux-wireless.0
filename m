Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbXH1Ils (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 04:41:48 -0400
Subject: Re: [PATCH 08/15] cfg80211: clean up key add/remove interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46D2ED59.1020508@lwfinger.net>
References: <20070824122705.549190000@sipsolutions.net>
	 <20070824122907.784517000@sipsolutions.net> <46CF298B.7040001@lwfinger.net>
	 <1188212576.7837.3.camel@johannes.berg> <46D2ED59.1020508@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t3qvhWLylmSGYNK+1wLY"
Date: Tue, 28 Aug 2007 10:43:06 +0200
Message-Id: <1188290586.7837.60.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t3qvhWLylmSGYNK+1wLY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 10:27 -0500, Larry Finger wrote:

> I have been working from the 'b43' branch with a top commit hash of=20
> 43a9a146a1290808519c68615809ae8bc207e8a1. It seems to be out of synch wit=
h branch 'everything' in=20
> this area.

Ah yes, that explains it, I think John grouped the cfg80211 updates with
mac80211 and those aren't always pulled into the driver branches.

> Sorry for the noise.

No problem, I appreciate any bug reports.

johannes

--=-t3qvhWLylmSGYNK+1wLY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0+Aa/ETPhpq3jKURAhSlAJ9FLVjSwxfXWIJke0KCa/fvpm21KgCfZwrE
c/Cbs1zt515IZ99BKLXSgj8=
=14TM
-----END PGP SIGNATURE-----

--=-t3qvhWLylmSGYNK+1wLY--

