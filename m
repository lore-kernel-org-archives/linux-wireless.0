Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:56115 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYFTNP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 09:15:26 -0400
Date: Fri, 20 Jun 2008 09:15:44 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: More 4965 woes
Message-ID: <20080620131544.GA31113@drd1813.lan> (sfid-20080620_151529_673364_45659809)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <20080617132401.GA8328@drd1813.lan> <1213781294.2625.52.camel@debian.sh.intel.com> <20080618154109.GB15170@drd1813.lan> <20080619134138.GA27021@drd1813.lan> <1ba2fa240806191253l2769dec3q2a49638eafe01e48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
In-Reply-To: <1ba2fa240806191253l2769dec3q2a49638eafe01e48@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2008 at 10:53:22PM +0300, Tomas Winkler wrote:
> > On channel 36 things appear to work (well, as much as they do otherwise,
> > packet hanging still makes the device unusable).  I'm still confused as
> > to why the card can report it works on that channel, scan that channel,
> > see beacons, but then refuse to transmit.
>=20
> There is a bug in the firmware. the fix is on the way. Unfortunately I
> cannot currently commit to
> to any particular day it will be published yet.

That's fair enough, good to hear.

> What AP do you use I don't see such bad behviour on A band.

Which do you mean - The failure of radar channels, or the severe
latency/packet loss?

The severe latency/packet loss happens any time I enable HT, if I'm
connected to a HT AP or not, 2.4ghz or 5ghz, in a clean RF environment.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"Remember the book store down the road?  That then became a book and coffee
shop?  Now it's a 24-hour just-coffee shop.  It's like evolution, only, wit=
hout
the getting better."

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhbrYAACgkQ17KIInOLvbGcqgCbBSbuYhCAqCDpzhrG75gSY1eT
5ZEAnAomFN1qUkDtFU4Iao041VJK3Uxu
=yZ2e
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
