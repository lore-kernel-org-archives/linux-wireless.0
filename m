Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761477AbXHCOuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 10:50:16 -0400
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: Derek Atkins <warlord@MIT.EDU>
Cc: dragoran <drago01@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <sjmy7gswuvw.fsf@pgpdev.ihtfp.org>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg> <46B1D28F.1080006@gmail.com>
	 <1186059192.24230.44.camel@johannes.berg>
	 <sjmy7gswuvw.fsf@pgpdev.ihtfp.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y20ukOWLqkkXSqlUeHqU"
Date: Fri, 03 Aug 2007 16:50:22 +0200
Message-Id: <1186152622.4647.48.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y20ukOWLqkkXSqlUeHqU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 10:33 -0400, Derek Atkins wrote:

> Um, what state?  Sure you lose your layer 2 state, but why force a
> layer 3 lossage when you don't necessarily have to do so?  For
> example, I've seen plenty of networks that have both 802.11(a) and
> 802.11(b/g) networks that share absolutely everything at layer 3.
> Indeed, at home I have an a/b/g AP where layer 3 is always shared.  At
> the IETF last week it was also shared.  I could easily roam from the
> 802.11(a) to the 802.11(b/g) network if my wireless driver would let
> me; the IP Address I've got is certainly valid on both networks.  Why
> should the driver try to be smarter than I am?

Can you please re-read the original mail?

Thanks,
johannes

--=-Y20ukOWLqkkXSqlUeHqU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGs0Cu/ETPhpq3jKURApf6AJ4hRl5gOK5MOngj6nLRapQelASASACbBLI6
zQZaLsYbFyDFZCTsaCyO1mw=
=5Gwx
-----END PGP SIGNATURE-----

--=-Y20ukOWLqkkXSqlUeHqU--

