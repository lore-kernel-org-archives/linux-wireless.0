Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXFKIVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 04:21:43 -0400
Subject: Re: your nl80211 work
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: David Lamparter <lists@diac24.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1181397249.23205.10.camel@xo-28-0B-88.localdomain>
References: <1181380044.3566.11.camel@johannes.berg>
	 <20070609113859.GA10836@charon.n2.diac24.net>
	 <1181391299.3566.17.camel@johannes.berg>
	 <1181397249.23205.10.camel@xo-28-0B-88.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mIz+hTJei0ZxzwPrzNOZ"
Date: Mon, 11 Jun 2007 10:16:41 +0200
Message-Id: <1181549801.3566.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mIz+hTJei0ZxzwPrzNOZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-09 at 09:54 -0400, Dan Williams wrote:

> Well, at least have one that all 802.11 _drivers_ can use at the very
> least, I know of 5 or 6 places in the kernel right now that have this
> sort of info.  Even just inlines in ieee80211.h or something for
> chan->freq, freq->chan, freq->band, chan->band, etc.  Max allowed power
> levels and stuff as well.

Right, that's something we need to clean up as well, but I don't want to
touch it before we have a concensus and more work on regulatory stuff.

> WRT to userspace, if there's an easy way to put this into headers that
> get exported to userspace headers, I think that would be useful.
> Otherwise everybody has to keep rewriting these, both mac80211, fullmac
> drivers, userspace programs like NetworkManager and wpa_supplicant, etc.

Right, except that when we add .11n or even .11y that'll require all
userspace tools to be rewritten, so wouldn't it be easier to export the
info via nl80211 right away?

johannes

--=-mIz+hTJei0ZxzwPrzNOZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGbQTo/ETPhpq3jKURAtCDAJ9WElsYGDfx2vUPyvV/NGGafa+V7wCglyox
WbWZ19gAMovA0/e7wvFLda4=
=fr5n
-----END PGP SIGNATURE-----

--=-mIz+hTJei0ZxzwPrzNOZ--

