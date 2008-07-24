Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYGXOWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 10:22:20 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910807230555s2040f507oe6c9e516ef8c0685@mail.gmail.com> (sfid-20080723_145507_239503_2FC0E55E)
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <200807221613.34434.herton@mandriva.com.br>
	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>
	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>
	 <4886C50E.6040304@lwfinger.net>
	 <69e28c910807230555s2040f507oe6c9e516ef8c0685@mail.gmail.com>
	 (sfid-20080723_145507_239503_2FC0E55E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gQeCat1dP+0k2O3h0Mo2"
Date: Thu, 24 Jul 2008 16:22:08 +0200
Message-Id: <1216909328.13587.67.camel@johannes.berg> (sfid-20080724_162227_941006_11E9D404)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gQeCat1dP+0k2O3h0Mo2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-23 at 14:55 +0200, Stefanik G=C3=A1bor wrote:

> Zd1211rw also appears to be affected, though not as seriously as with
> rtl8187: it scans, associates and gets DHCP, but it consistently
> disconnects after about 2~5 minutes, either with "No ProbeResp" in
> dmesg, or sometimes with no error message, just "Removed STA" and
> "Destroyed STA". I don't know if this is the same bug, as I haven't
> bisected, but it appeared when I switched from a 2.6.26-rc8-wl kernel
> to a 2.6.26-wl one that contained the above patch.

zd1211rw works fine here, been connected for about 15 minutes now.

johannes

--=-gQeCat1dP+0k2O3h0Mo2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiJAMAAoJEKVg1VMiehFYAyQQAJFeX1Xm/+/G5HSi3sLGcxgh
o+xobBIF4noTpeinu2fW0B37Fbim1dxNJKhHUzAc8uCOjsSzVfq/k01kpXaskDn+
HMKYA7mwZLvAV8bzA0vccCFa34oIPkQdTYpurOq6cI0vWJCB//ujNH7Gq9VkUYHR
ciVbdA1xn3CoLJRf9Z6zrqERKGydaxrYd6SPvYbaskO8aBxx0Iog9qLj9XT+MM3h
hxq4+IgIUqIGsO815kjsMMoAPQbzwf/S98dH8TmFCJatAHFHdsAvhXWOuvXAf74v
adNJABWew/U5sUGuheJhpg8/ASVX4Rq37yFxYyBUGsVNRMdSmuryQKWIotwWHR28
uWyHJC2F+aNKtjWR/0awEuCKAZeGaPzQ4FVBMABiH0/8U6SeovqV0ZUTyrsomXqS
7lm/WTnxf+LEj/1KumevJZO5L9U/LeuDusBba5+CGaSPjfTDBw2ff4Pr0W7M7psT
heTRdofyOc6nLR7rvR2YzFdqF5mT4nN0yAe7KRmdLsdMEWBe3v0FZa8ljgnRRP5l
4RFmTMp6YL5BmYNWn9FWT3CwNRv1zPU+eDJ+BcCZJQqP0brE86BC6ps9aZW6IGvh
MzlL8OdT/Gmhvm8dccqCVoY1WB9wpzCrWoyY3s5RrQe6Ul9Sp2HUFARbIdonA11H
FZPaMjHDKOvQsAdG1ADe
=iX/Q
-----END PGP SIGNATURE-----

--=-gQeCat1dP+0k2O3h0Mo2--

