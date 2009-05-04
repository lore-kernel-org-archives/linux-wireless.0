Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZEDLNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 07:13:20 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241427107.2899.9.camel@localhost.localdomain>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
	 <1241427107.2899.9.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-51WhxR2DnPdJrxqUP81F"
Date: Mon, 04 May 2009 13:12:47 +0200
Message-Id: <1241435567.8683.35.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-51WhxR2DnPdJrxqUP81F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> I re-sent the patches now in a different order so that the WPA stuff is
> the latest in case you want extra fixes. I didn't include all defined
> ciphers since I would have to dig though specs again. However it should
> now be pretty easy to extend it since the basic parsing is available.

I've committed everything, and am doing some minor cleanups. I also
noticed we don't validate everything as good as we should so I'm adding
some support for that.

johannes

--=-51WhxR2DnPdJrxqUP81F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/s2sAAoJEKVg1VMiehFY+nsQAJhcrqQIYGAyxW+7mlQm6iNw
4Na+lIIoDVp9LpyJeusKpPdYOmBu4Oxi1U0aIv5qXybR1I45An/P/9/NDtErFuIp
sJPMvFW7B2Xr6qGpQqtqthXUqR8sqngLNr8L5YSPs/T8KBvJ2i8ANCJeUBmpYWV2
NccAKILkilwSKDF02j+FnPaVMiRzMHjMVsT5CQj4WpaG1jVukJSmhofYNMMwbvEp
glb5832WvcnsPKZiCo1zbHE/9GbqTDg/kaipifw6WIjEnSb6Nc6mlBODpiHd/19T
UFb4PzYaN8om5NxsiHfEtiw1/zBo2H/VztPrSfcjwY0WlPM/dZ9gDT4pIRMsbz2a
cds7uqqIYxm2t2dfMSB0Fa+WYzCgVsIrKnSCzH6jt0x/81fUqBn18byLI2TqiBjf
PyT0P4HLxc51ADRQua7BIj0DLQ2KnT+UhMvC4WxW1EcI6sG28jHWB0/SZAaqghOb
PC8e/6LlvGZd8QlwovJERzqVNAD8PuoLTYHUerC0aUl5583cu7yb98n08FNvBpCK
wHGwAjcz2o75sTdIn26E7iY8neSSj0xPTNjvA8NiZYJwsU4+hAU8coVZB1E1a1E1
X2gH8PcU09rxrsItalV4Jg1ZlLxrs0ulUkwhUxeD/75viC35oF2Gxie8H82wHhtS
kSWZFMG+F3eVuD8A7r37
=iatL
-----END PGP SIGNATURE-----

--=-51WhxR2DnPdJrxqUP81F--

