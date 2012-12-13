Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:38534 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2LMOxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 09:53:24 -0500
Date: Thu, 13 Dec 2012 09:53:19 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Message-ID: <20121213145318.GA24196@shaftnet.org> (sfid-20121213_155333_165282_41D17083)
References: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com>
 <20120706201839.GE1879@tuxdriver.com>
 <20121211232311.GA9080@shaftnet.org>
 <201212121613.12750.chunkeey@googlemail.com>
 <20121212161845.GA21461@shaftnet.org>
 <1355329248.9708.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
In-Reply-To: <1355329248.9708.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2012 at 05:20:48PM +0100, Johannes Berg wrote:
> > Is there a better way to handle this now?
> There's IEEE80211_KEY_FLAG_PUT_IV_SPACE now which does exactly that.

Excellent!  I just cut all of the old crap out in favor of this. =20

I'm working on a revamp of the platform_data to be a little more=20
generic/useful/sane, but once I'm done with that, I'll put it through=20
checkpatch and then I think I'll be in shape to submit a patch series=20
for review.  This weekend sometime, I think.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQyevePuLgii2759ARAttPAJ9TAGh5v2L1M/CUgffQWvx/dxuSRwCcCv9p
ye51NjZM8SyRjw7a7zIJMVc=
=7hhl
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
