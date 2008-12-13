Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYLMALC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 19:11:02 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4942FD59.8020401@erley.org>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>
	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>
	 <1229099080.14423.15.camel@dv> <1229119118.3572.6.camel@johannes.berg>
	 <4942E7A4.3050206@erley.org> <1229121535.3565.4.camel@johannes.berg>
	 <4942F867.5020203@erley.org> <1229126725.3565.30.camel@johannes.berg>
	 <4942FD59.8020401@erley.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eWOSQs1dUtjbU65is66O"
Date: Sat, 13 Dec 2008 01:10:57 +0100
Message-Id: <1229127057.3565.34.camel@johannes.berg> (sfid-20081213_011107_606531_13BB063A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eWOSQs1dUtjbU65is66O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 19:10 -0500, pat-lkml wrote:
> Johannes Berg wrote:
> > On Fri, 2008-12-12 at 18:48 -0500, pat-lkml wrote:
> >> This converts iw to use libnl-2, and adds compatibility with libnl-1.
> >> There is not currently a good way to detect the libnl version during
> >> compilation, as the versioning in the netlink/version.h is defined as
> >> a
> >> string "2.0" rather than a major and a minor number, so we must detect
> >> it in the Makefile.
> >>
> >> Signed-off-by: Pat Erley <pat-lkml@erley.org>
> >=20
> > Ok, I've committed a slightly different version of this (corrected the
> > type, and made the compat code static inlines), can you verify it still
> > works against 2.0?

> Yep, works fine with 2.0

Alright, thanks for the patch and testing!

johannes

--=-eWOSQs1dUtjbU65is66O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQv2NAAoJEKVg1VMiehFYka4QAIGRE+D3YVo/OXZC8Kt8BQIN
tYYUnhvPVF1OOYC/7HX3Vmhknl3tcXx1Bv2NfX59sjtm/4PFXEy5IWTlwMVTcn7A
F4avSP10EF833W5I+2WGiG4z1UupQViQeCLcThaS6vNyA6xomW7kvtYWMyFh/Ys3
5YG7qJY24YdV711V9P2XAM8VuDBIs2hH6Z7DgsUk9S87E1n2MvGIKNiZ0RD9Q1wp
CVZ2sRcRuht2GAtTwh4y+OdKKrZFhZ0cdc5nsxH4jdBXA1hUu8WOntMu9gWRitBX
bw5jZF2em35B7qxYpR9hRNLota2Xc5LCPP1JKvP5cTvt0RWwghgb5i1+G49sINLT
SWFF7/YsvLrpYbMwMMBlmfW0pQN7wTqDI9O9EJBi84MtOVCEKpGcS93vkcFxr+5K
r9H/iEkYDH06PDTa0QweVMW/vYVwyKREc0tzMx9bGI+Dsje8vQnFHGOv1ulN6C3S
TN1bBRFe9AeCaK9WBiw9nFAJDK3XvcZJMyrGrY4BJzNtWqqKf4Arc+6DlSbbP40f
t8CoH234T85zy9+SNaQQf6oUod7sRNCW85Kcrc5bersMZQcCe8KLkAlNYOqukwRs
HTAtwPla9sWRKPETzDegzqqO1c8CobWC0Z00sqTbFiEwStq/7sKFCAQSpuqKB+ae
nxLt0g5ShJFsjQsaHWwl
=7Vnd
-----END PGP SIGNATURE-----

--=-eWOSQs1dUtjbU65is66O--

