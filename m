Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761410AbXHNLxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 07:53:45 -0400
Subject: Re: [PATCH 3/3] mac80211: remove management interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708130844.27516.flamingice@sourmilk.net>
References: <20070813074504.416717000@sipsolutions.net>
	 <20070813074644.118092000@sipsolutions.net>
	 <200708130844.27516.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2yAUufp1lrSmYwtK7uz6"
Date: Tue, 14 Aug 2007 13:42:46 +0200
Message-Id: <1187091766.4069.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2yAUufp1lrSmYwtK7uz6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 08:44 -0700, Michael Wu wrote:
> On Monday 13 August 2007 00:45, Johannes Berg wrote:
> > Oh and somebody needs to fix zd1211rw-mac80211. It abused the
> > MGMT interface constant that was explicitly mentioned to be
> > not for drivers... I've "fixed" it for now but readers of the
> > code may not be happy with it.

> I've done this in all my drivers. It's perfectly fine. If you're going to=
 drop=20
> the MGMT enum, please post a patch to s/IEEE80211_IF_TYPE_MGMT/-1/ for al=
l=20
> drivers.

Oh, I thought zd1211 was the only one doing that. I could add a
IF_TYPE_INVALID if you really require that, but I don't see the point.
As soon as the driver wants to work with multiple interfaces this stuff
has to go anyway.

johannes

--=-2yAUufp1lrSmYwtK7uz6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwZU2/ETPhpq3jKURAognAJ9p9Qu+24+t860kRdg5HOae4r84HwCfRgMM
dl3eECNSqaAN1Z1DKCTcJ8I=
=Q+qN
-----END PGP SIGNATURE-----

--=-2yAUufp1lrSmYwtK7uz6--

