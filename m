Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZGXSP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:15:28 -0400
Subject: Re: [PATCH] mac80211: add helper to add to the mac80211 workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	Daniel Drake <ddrake@brontes3d.com>
In-Reply-To: <1248458909-15338-1-git-send-email-lrodriguez@atheros.com>
References: <1248458909-15338-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ESHtrvFkcYtDuV9t2GWl"
Date: Fri, 24 Jul 2009 20:15:24 +0200
Message-Id: <1248459325.32151.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ESHtrvFkcYtDuV9t2GWl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-24 at 14:08 -0400, Luis R. Rodriguez wrote:
> We add a mac80211 helper for adding work onto the mac80211
> workqueue. We then add a warning if we are suspended. At that
> point drivers nor mac80211 should have queued work, drivers
> and mac80211 should ensure the workqueue will remain clair
> until resume.
>=20
> We make use of the helper now in mac80211 and on all mac80211
> drivers. If you see a warning because of this patch during
> the suspend <--> resume cycle it means suspend is busted for
> your driver or mac80211 and it needs to be fixed.

Looks good to me.

johannes

--=-ESHtrvFkcYtDuV9t2GWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKafo5AAoJEODzc/N7+QmalOoQAJpYA+1t9BKIjpvktQH4PSHb
TLxaulIyz1SsnNQ21Ydr1H6TDpRFLjhbLuoTP1vR39wNE1sq2iG4gDgiKOwMK25H
5M4Fw5Aj9rEIhcZ+ah+SZzsOuoSaDCHeBAH7pNcajTpV8hbxSXrrMuAhnEFf1rx0
3uxgCaC0lEOsFOfOzbcHhLLtbd+OO+NNFw6PbyEGPBZfmNgPS80iVk8lGG7Z6XyS
z8G7EizU7eT58gmYjbCG/uIYI4LZr5Y3VVgQV4bR9gJ8UGIeR+MGHhPiuryuRore
Pzte+zunEhwU+nbhbbCPGiYsgQhZQnHrp9s+0EGHdJK1YFS/arjBszo1Txut4vPc
dDyuRxkzV0Tp1AX+10usvM1itHfsiiDmvSCUG0ch3IbH15kl3JBnB/H/TGp03qY5
rco2lwIqXMMTbvbiykUqG/vSkhm54wytpN1RJ92ENXqKLkQEWw6X1B9MVRyXQJ+B
CyD95ui4CM5ij6IULvWNGK/sh2swf0mTK0uKEE4n7/hFh06z48AuoLML0KJLk8QH
aMXpXDusmWqoeC/2Y2tD45Z5FfFZJL7pQVbqZUyFG5zGmDO82qkB5TqnavlT5rr1
WMrAGp6AkRlj/dqfUHvkeXkv3PehyrgRBZXeOoFiXzNBHflQiMxUeh0oqnuI5wiO
E29MTGTAa/nN0YVatHRF
=YpoZ
-----END PGP SIGNATURE-----

--=-ESHtrvFkcYtDuV9t2GWl--

