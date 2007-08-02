Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58504 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbXHBMvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 08:51:48 -0400
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <46B1D28F.1080006@gmail.com>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg>  <46B1D28F.1080006@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-s+YtHkz32xoi8s7Cfbt4"
Date: Thu, 02 Aug 2007 14:53:11 +0200
Message-Id: <1186059192.24230.44.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s+YtHkz32xoi8s7Cfbt4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 14:48 +0200, dragoran wrote:

> > Nono, you cannot solve it in the driver. The whole design of mac80211
> > mandates that assumption and I think it is a valid one to make.
> why? did the old way (allow mode changing while up) caused any problems?

Why should it be allowed? Can you come up with a good reason for that
since you lose all state anyway when doing mode transitions?

Until then (and I guess somebody *really* wants it) it's just a lot
easier to not even try to change these low-level things while the
interface is operating.

johannes

--=-s+YtHkz32xoi8s7Cfbt4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsdO3/ETPhpq3jKURAqfOAJ0fIn/LwSoPMajzaNmXGykr+13ZawCgioH7
JsdFZGJ8c2vhuEm4LE/FmzY=
=Wv7u
-----END PGP SIGNATURE-----

--=-s+YtHkz32xoi8s7Cfbt4--

