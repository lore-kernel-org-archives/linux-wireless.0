Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYJVSrw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:47:52 -0400
Subject: Re: [PATCH] wireless: fix regdom passing semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022113751.GD6190@tesla>
References: <1224579720.5521.2.camel@johannes.berg>
	 <20081022113751.GD6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rJK5/UmzFutTIacstOmN"
Date: Wed, 22 Oct 2008 20:47:43 +0200
Message-Id: <1224701263.30459.45.camel@johannes.berg> (sfid-20081022_204756_936331_248EAD4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rJK5/UmzFutTIacstOmN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 04:37 -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 21, 2008 at 02:02:00AM -0700, Johannes Berg wrote:
> > the current documentation doesn't
> > note that you need to free it on errors anyway.
>=20
> Yes it does.
>=20
> >  /* Use this call to set the current regulatory domain. Conflicts with
> >   * multiple drivers can be ironed out later. Caller must've already
> > - * kmalloc'd the rd structure. If this calls fails you should kfree()
>                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> See?
>=20
> > - * the passed rd. Caller must hold cfg80211_drv_mutex */
> > + * kmalloc'd the rd structure. Caller must hold cfg80211_drv_mutex */
>=20
> But this is fine too, so long as we keep the docs in sync.

Yeah, evidently I screwed up the commit message. Sorry. I think I'd
thought it didn't and then only later noticed. I'll resend.

johannes

--=-rJK5/UmzFutTIacstOmN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/3VLAAoJEKVg1VMiehFYUK4QALwPMlE6J5NoQgioVia7v2Qh
9mCLguy9MNZpEZJf662rcBrWY5IRVxfpY2PLAN9fzptASVFgUNXlh6wgUMwdfksz
IcGkuhTPDEWg2Usrg8iF1aOWhR0g393S5d5xqIob1rQex4eJpJzLNQB0D8HZHvhv
phUrtVsRodkI1cSsQvYJIxc1nfTw9/54NzhW5FAnjHd8eS8WvH4ff+4FhMgoJEYv
a4C7ump3IPcb46BbtDuwTWrAjWnqqfURnCGQoRfwdE7xiYJWsug/ItGiOneaSvC0
VvBHIMm2OVsFSk0OFdyB6Dk3/n1yNwSXfwhFFZst6+YA33U0qcf3Ax5VWd+f8eHv
a8grJbdjqynxMBGxYfOemAzYhZ3z1GMGGczrJa/PHD3T7kNA9B3NOJF7wszydJdK
CKGbgAeabh9Vmw23xijs50qi3GtG8GF8m802l9rOGV9fAhYKw2d7Wg+Xb+Q3bnud
H7sxbXEfA48VXCJbmZ8x/9AZzzx7zyAvGFhPgHIKQJn8wPurryRgnueIe9LXOh8t
npNETDIek6funX6EpptYELo+lcTMS83df4RVtgEBa19MO5FXSHMeikYsy9pVWOjN
k2NMSQY4H1vwnBSw5hwyKoYc4ArWa8TjJv8dexWeq+VTDjzmS27jlUxCzQc3Mtec
BxoJqRM4/uGyE0qJJBbd
=fmBn
-----END PGP SIGNATURE-----

--=-rJK5/UmzFutTIacstOmN--

