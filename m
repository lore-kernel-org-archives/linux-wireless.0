Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZFPSqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:46:15 -0400
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KtP/lwhasjRAhJXwoUGY"
Date: Tue, 16 Jun 2009 20:45:46 +0200
Message-Id: <1245177946.21287.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KtP/lwhasjRAhJXwoUGY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 11:42 -0700, Andrey Yurovsky wrote:
> On Tue, Jun 16, 2009 at 11:35 AM, Johannes
> Berg<johannes@sipsolutions.net> wrote:
> > On Tue, 2009-06-16 at 11:31 -0700, Andrey Yurovsky wrote:
> >> Commit b2a151a288 added a check that prevents adding or deleting
> >> stations on non-AP interfaces.  Adding and deleting stations is
> >> supported for Mesh Point interfaces, so add Mesh Point to that check a=
s
> >> well.
> >
> > Why? Aren't those automatically discovered like IBSS peers?
>=20
> Yes, they normally are, however it's possible to turn that off from
> user space (via iw).
>=20
> The reason for this is that it's useful to manually create mesh
> topologies.  This is mostly for testing, verification, and
> experimentation.  For example, you can manually create a topology
> where you have two paths and you know one path is better than another
> and then run a test script that verifies that the right path was
> taken.  It could presumably also be used by some user-space "mesh
> manager" similar to hostapd for APs.

Ok, fair enough. There are a lot of quirks in the mesh API, one of these
days I'd like to make it less like wext and have you join/leave like the
ibss commands instead of setting each parameter one by one...

johannes

--=-KtP/lwhasjRAhJXwoUGY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN+hWAAoJEODzc/N7+QmaW4QP/iG9HrCuQ4oZOLZSDza/jEcv
l6238Ca7IoD0ijZMWsHS5tbL/JsyVPnVUGlN7e7Zvyi4NkIOMPfuECfe7kS6iJ3l
TXRk7lWpPkUKFOrBg/ZfV4Sq+XQb/nBiHdG4qFzJQwu8uNPjW40uHiQraCSB5dZn
+J6LUAUboAH7t8gI9ohO0U5cvEAQ9aMUrGXc/1Aw/hgUgrEnM7w6nvl0Sgh93vtO
OYVnJojP0bED5OiYnDITjLfsC32G/wX37PyrZJ2omNzUII1SVLmPheysn8kDxg32
DOAFNQG/9e7r024o6L0qWKAHjoFBEXervclkzEPDFr/PfalnMYahnZxuPmW0P8Sj
GzP5KGEHDmZXyTc8X16a/ue+rE7QmXK4nLL22O56Zorb17NqWWqAux4pRI79Zmj1
UebHFEBYM7b/U/q7mNOHV4hiTwbFhrnX7a11/fPlhbOAICiLCoWeNEJblgXLYzCV
AZ0yhilnqKSVzjM0NoqOsLqTi+YF+GxffM4sRxc21WJNerp3nqPqdcV/LApAb5Xs
42QCDcpsNrb4Ce/nou/Kjlo8aByWmEyFu2d0o+i78dEIK/T3RiVA8xmF4r3lft9S
SRFD1p+GIy9wJyt+upq9iBYKwlBntoaPT4bwNsROsH7GRuIYYlGSSSJNbYrXqiVQ
k6unhRWaXUJUWebAXwBm
=PrFS
-----END PGP SIGNATURE-----

--=-KtP/lwhasjRAhJXwoUGY--

