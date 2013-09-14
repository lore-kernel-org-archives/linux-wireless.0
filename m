Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:57953
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756061Ab3INCrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 22:47:19 -0400
Date: Fri, 13 Sep 2013 22:47:10 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cw1200:  Don't perform SPI transfers in interrupt
 context
Message-ID: <20130914024709.GA14728@shaftnet.org> (sfid-20130914_044722_282618_18C5F121)
References: <1377649787-2817-1-git-send-email-pizza@shaftnet.org>
 <20130903115856.GA16844@shaftnet.org>
 <20130909183350.GB1955@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
In-Reply-To: <20130909183350.GB1955@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2013 at 02:33:50PM -0400, John W. Linville wrote:
> > Since they didn't make it into 3.11, I intend to submit them to -stable=
,=20
> > but I need to make sure they at least make it into -next.
>=20
> I'll be sending them for 3.12 soon...

Can you please revert this commit?  (aec8e88c947b7017e2b4bbcb68a4bfc4a1f8ad=
35)

It ends up creating horrible interrupt losses.

I'll have a much simpler replacement posted shortly.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSM84tPuLgii2759ARAkV2AKCegrnCe5xzk/JA4C1zBHmirWpRbQCfYFub
blJ0EHbrKVm2fHWxznuIsAg=
=VNug
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
