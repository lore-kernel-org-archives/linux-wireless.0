Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZEQJ2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 05:28:51 -0400
Subject: Re: [PATCH] mac80211: cancel/restart all timers across
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905161416n5295e5eamd4cf41fa1129260d@mail.gmail.com>
References: <1242391067.5799.53.camel@johannes.local>
	 <43e72e890905161416n5295e5eamd4cf41fa1129260d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OYVigLUNlaACFCw3WLaL"
Date: Sun, 17 May 2009 11:28:46 +0200
Message-Id: <1242552527.10005.75.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OYVigLUNlaACFCw3WLaL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-16 at 14:16 -0700, Luis R. Rodriguez wrote:
> On Fri, May 15, 2009 at 5:37 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>=20
> > --- wireless-testing.orig/net/mac80211/mlme.c   2009-05-15 12:43:11.000=
000000 +0200
> > +++ wireless-testing/net/mac80211/mlme.c        2009-05-15 12:43:11.000=
000000 +0200
> > @@ -37,6 +37,9 @@
> >  #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
> >  #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
> >
> > +#define TMR_RUNNING_TIMER      1
> > +#define TMR_RUNNING_CHANSW     1
>=20
> Typo?

Damn, yes, thanks for catching that, will repost.

johannes

--=-OYVigLUNlaACFCw3WLaL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKD9jJAAoJEODzc/N7+QmazrsP/A6Wy+eRDt07cesattdCP9VN
eFvyxRVzrITM/ggUKpFzThXtdo+hih1gouDycKfVrM+szesDf8n3ye5yNFwfKP2i
bnapuO/chWchE+RAgE/382q5WRGTfTw75uB7b1mHyesebygG+09dmahDwyTR81fr
ciAVWPL3p9I2ZSQNYJg4oUhjdio7Lm1GzZcRvvqBlVDYOSLpigcLcwJCki6XG6UB
X8EySvEIakkKqsIL4RgwxXyHQCDsZMr06VaiNd8955zR+2VyNEfvdF83tTHOa0DP
Q6qGaDjoPU2q5NoeMfAT591t1alksMBA4augC6tNxDovmuy939CfGBGsF4Sr345m
7fJ+7qcQdPdxsWyWvhZ/YgYlbVQXJqWqCJQflywTnuKg1Jobaa0qWGcWJoA21+XV
zVmS+3BRa+FUgtrfXQDf1TG/YCX79FJ8muBtA8u+/fMeivOIm+w7iMCibx2cxjt7
RBTa2G7DUkZRM77jUF1HmNo0i8bSBLTF+vgoTSdlMIg/Ixv80T9IPj3G01W206IG
44yKLkNDizWFxQtBpKipBInBpEUZFerrJx4rBLXgM/DKZk8GFJ3dvsQ/10jB7I5N
W+ecJVtGCYKf8Zh17BxIAj7a5vI8eabkfH99RVqDB5f9S4dR8RJgs/PHQqCFIUTH
W6/lEBNEQHwLNdfpRcAo
=c1bM
-----END PGP SIGNATURE-----

--=-OYVigLUNlaACFCw3WLaL--

