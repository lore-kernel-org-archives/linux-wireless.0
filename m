Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbXHHJPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 05:15:02 -0400
Subject: Re: [PATCH] mac80211: fix tx status frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org, jbenc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200708072013.28765.flamingice@sourmilk.net>
References: <1186475037.4067.14.camel@johannes.berg>
	 <1186480510.4067.35.camel@johannes.berg>
	 <200708072013.28765.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IUKFcr3D+ZLxQIzyAxnG"
Date: Wed, 08 Aug 2007 11:14:25 +0200
Message-Id: <1186564465.11717.7.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IUKFcr3D+ZLxQIzyAxnG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-07 at 20:13 -0700, Michael Wu wrote:
> On Tuesday 07 August 2007 02:55, Johannes Berg wrote:
> > This should probably go to .23 as well as -stable.
> >
> -stable is for .22.. I don't think outgoing frame monitoring was in 2.6.2=
2.

Good point, we didn't have that at that time.

johannes

--=-IUKFcr3D+ZLxQIzyAxnG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuYlx/ETPhpq3jKURAvafAJ97FNVxjXKEkmsmHkvNHxNvynpwOQCfeU6g
6eOrltOD5wXQTpgblF5i8W4=
=iDaI
-----END PGP SIGNATURE-----

--=-IUKFcr3D+ZLxQIzyAxnG--

