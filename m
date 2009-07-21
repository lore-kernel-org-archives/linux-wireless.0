Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZGUKus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 06:50:48 -0400
Subject: Re: [PATCH 3/5] iwmc3200wifi: use cfg80211_connect_result to send
 req/resp IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248139334.3747.22.camel@debian>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
	 <1248086241.14765.1.camel@johannes.local> <1248139334.3747.22.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tjLFJpIKwnnaLMFOUhOJ"
Date: Tue, 21 Jul 2009 12:50:13 +0200
Message-Id: <1248173413.11316.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tjLFJpIKwnnaLMFOUhOJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-21 at 09:22 +0800, Zhu Yi wrote:
> On Mon, 2009-07-20 at 18:37 +0800, Johannes Berg wrote:
> > On Mon, 2009-07-20 at 11:47 +0800, Zhu Yi wrote:
> > > cfg80211_connect_result() let us specify associate request and
> > > response IEs as parameters after we are connected. We use this
> > > capability instead of doing it ourselves with WEXT.
> >=20
> > I think with this, you can now remove
> > Indeed, I have a patch to remove that.
> >         select WIRELESS_EXT
> >=20
> > from your Kconfig.
>=20
> Um, not yet. I need to assign the netdev->wireless_handlers to
> &iwm_iw_handler_def. The former is ifdef-ed CONFIG_WIRELESS_EXT in
> struct net_device. I think this can be done until cdg80211 provides a
> generic iw_handler.

Oops, you're right. I have a patch, but John needs to merge stuff.

johannes

--=-tjLFJpIKwnnaLMFOUhOJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZZ1iAAoJEODzc/N7+QmajKkP/jywKUqMLlRs8vIRf0rqdXAJ
rPEngZV07Q5h2+VSrOilHQvpxgGcoHUmgaC8waxCHP/BPagnVEFYRyLUzis2Mxn4
69KjXOQ29H6RuGG/HaBsqAXuEkM77JYOG0JBlXOwetv0FQw8V7MDvEjmSw+gb1Io
S2tLi2WZLHpeabWn9vZ+4dMhq/PiG2hw52ThyeK5wQMf5DOuBl7XjTOhR63aTxZA
I8Arc59aAP01rLqY7Hf+YN/xTtepf2M02OfFYu8VsZ08fFbIV9DieB1J9izW41Yj
3AiFk+VhfA8INJKWZpEt4o+2YADLpwTAer/deYmaXo5AC7kuSJYdrksZ8IOeB4/P
Xin+ENyDawN7zjZMHKdGc3Z0nOglYRwRohO///Un1IZ+vvkioc8H0aH32TMDu8sw
ZUFwaVfGzD7eK1xFY1ix1fDyaUSiuvlH7CTIMYPVPxOWhu9+Iw+ImNvdNRhwsZL7
7qo9dNMOfQZa4egJaZXLGhcfA2J318gSDfbamTxQs9WOgqbwumDq8hMIgkZqmd97
ySpUPZe5ceRKK/ZJWPAUCo09Nu8lsWrCwJSA5AntPSU1vSGVtgWa50JjNpp/zAKO
XQdyJJmiqZ1aKiv7qff2FsLb1GlSMZx4BIa/UmP4SkvYiddZa+Vs3pMeR0ALDPOM
Lro6fo7wgObWMrOmMP5/
=AshO
-----END PGP SIGNATURE-----

--=-tjLFJpIKwnnaLMFOUhOJ--

