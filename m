Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbXFHJGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 05:06:12 -0400
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070608105900.4c401e14@griffin.suse.cz>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
	 <20070607221939.444e9d74@griffin.suse.cz>
	 <20070607222113.0f752bf8@griffin.suse.cz>
	 <20070607222210.1a445cd7@griffin.suse.cz> <4668A7E5.3070500@lwfinger.net>
	 <20070608105900.4c401e14@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m93NJvzBmkD51zWV36S8"
Date: Fri, 08 Jun 2007 11:06:28 +0200
Message-Id: <1181293589.6533.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m93NJvzBmkD51zWV36S8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 10:59 +0200, Jiri Benc wrote:

> > I do not think this particular rate control algorithm is needed. A patc=
h has been submitted that=20
> > will allow the user to use the SIOCSIWRATE ioctl to lock in a rate. In =
addition, a patch that=20
> > changes rc80211_simple to set the initial rate to the lowest supported =
value has also been=20
> > submitted. With these two alternatives, everything that this proposed m=
odule does is supported in=20
> > other ways.
>=20
> Ok.

Actually, I'd vote for having this rate control algorithm anyway because
it's basically a rate control algorithm template you can copy and
modify. rc80211_simple is quite a bit more sophisticated over that.

johannes

--=-m93NJvzBmkD51zWV36S8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaRwU/ETPhpq3jKURAgE9AKClzjnbkSEb2sJrzEpQ5X9yxGuqOACfbrXl
OmNMZT0J5bkwhgu6e6dM0pc=
=bMYQ
-----END PGP SIGNATURE-----

--=-m93NJvzBmkD51zWV36S8--

