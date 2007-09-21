Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763862AbXIUVse (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:48:34 -0400
Subject: Re: [PATCH 0/5] Add central regulatory domain agent - Patchset I
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1190410796.14368.17.camel@xo-3E-67-34.localdomain>
References: <20070921204606.GD31768@pogo>
	 <1190410796.14368.17.camel@xo-3E-67-34.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c1KFOVUki90F62cdphDf"
Date: Fri, 21 Sep 2007 23:49:50 +0200
Message-Id: <1190411390.18521.174.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c1KFOVUki90F62cdphDf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-21 at 17:39 -0400, Dan Williams wrote:

> Also, if you could make sure this stuff is completely separate
> conceptually and architecturally from mac80211 itself, but have mac80211
> _rely_ on it, then we can rip the bits out of the fullmac drivers that
> do regdomain stuff and plug them into this framework too.  I think
> that's a real win.

Yeah, I think that's the plan. In fact, I always consider mac80211 to be
on the the same level like fullmac _drivers_ and mac80211-based drivers
somewhere below that (at a level that with fullmac drivers doesn't
exist)

johannes

--=-c1KFOVUki90F62cdphDf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9Dx+/ETPhpq3jKURAulPAJ49DxoIBw+BKHcpqYQ6zpkZfN1N4wCffCTS
tDW0IiY6rFf9iyNLPZ66KJU=
=VQUc
-----END PGP SIGNATURE-----

--=-c1KFOVUki90F62cdphDf--

