Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbXHWOM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 10:12:59 -0400
Subject: Re: [RFC 1/2] mac80211: allow drivers to indicate failed FCS/PLCP  checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200708222111.03164.IvDoorn@gmail.com>
References: <20070821161845.165557000@sipsolutions.net>
	 <200708212307.59926.IvDoorn@gmail.com>
	 <1187774561.4314.0.camel@johannes.berg>
	 <200708222111.03164.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sX/E8kKeTOR/sAXMwAw/"
Date: Thu, 23 Aug 2007 16:13:34 +0200
Message-Id: <1187878414.4314.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sX/E8kKeTOR/sAXMwAw/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-22 at 21:11 +0200, Ivo van Doorn wrote:

> Not sure how interesting a frame with a ICV error will be,

It *could* be interesting in monitor mode if you're interested in lower
levels than I usually care about ;)

> on the other hand I am not even sure how a frame with a ICV error
> looks like in rt2x00, discovering that will probably happen during
> the hardware encryption implementation. ;)

Yup :) I'd hold off on that for a bit though, I've been revamping that
part of mac80211 because it currently makes not much sense.

johannes

--=-sX/E8kKeTOR/sAXMwAw/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGzZYO/ETPhpq3jKURAoT/AJ0RIrHt5yWmR2Uxij0si22wNa/eBgCfZVZd
x7tVW7yvjl8UsA2n0bqTofk=
=bloF
-----END PGP SIGNATURE-----

--=-sX/E8kKeTOR/sAXMwAw/--

