Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbZIXIFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 04:05:41 -0400
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Johannes Berg <johannes@sipsolutions.net>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4AB7A5BB.1050300@yahoo.es>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-G+ubo3cPwClBX8CfhgPX"
Date: Thu, 24 Sep 2009 10:05:38 +0200
Message-Id: <1253779538.3868.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G+ubo3cPwClBX8CfhgPX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-21 at 18:11 +0200, Albert Herranz wrote:

> Adding back "cfg80211: fix SME connect" and applying "cfg80211: don't
> overwrite privacy setting" fixes the connection issue, but with a
> introduces a small difference vs the previous working version.
> There is now an extra "deauthenticating by local choice (reason=3D3)"
> message in the logs.

> [   13.969153] b43-phy0 debug: Adding Interface type 2
> [   16.679249] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)

> * master-20090916 + "cfg80211: don't overwrite privacy setting"

> [   13.218613] b43-phy0 debug: Adding Interface type 2
> [   15.832582] wlan1: deauthenticating by local choice (reason=3D3)
> [   16.131599] wlan1: direct probe to AP 00:12:17:15:e7:79 (try 1)

Very odd. Can you edit the deauthenticating message to show the
BSSID/MAC address?

johannes

--=-G+ubo3cPwClBX8CfhgPX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKuyhMAAoJEODzc/N7+QmaNyEP/1N6h5vRpzVl3NsN9rAjFgE/
BPQ4/mbVy0T6riA+AJj4hV473hR5DEnpeiweth8NQHthaUAfyQXoWdJNtg6FmI4P
0RJSnz4kzaUuVcEDrBTJUvl0pT6KLVXN+ADY5FHxWBUBB/vkBAYFIrwKsSAdlPIY
ubPDdyY3HbcMl8c1D95/njfEoXanLUlSaciHxeTxY8MBpYC2/A+zWk4b91p0p+WK
0HDPAkmcWZq6XqUkP8F8TAxMkzG+fEHO1RxYjhff6rfU1ruNUtC7u/yZ+KdhOpOA
coRmLSJzEt9WVHlFmcAQWGNCraN19ZmMCB9O+iHruSBClbu86Yl2VNcZldo94w1E
FvRXnraBlT4qbfF56mDLFeDd89d8psfvlfdt1CjzXZ+/TbbaK4IzE/bxD4Nx8hPL
aFOfoPbNj/kJTMBW2LkWnLKyCd/rRpVKK7vomR3Hti3e1C0Ud8ZEaZY5EQF3fJFo
USNjK/6cmVIM15CcfUuTo5qxDIWqyzaLbUMP+RuxNjh6QeJY26LUEfUFqfZfaWng
u/41+IzUARsu6Pst7ooWxvPe3mddzvDNI/OojRaoyNb/YYzL2aYSIv0yLSrEu8K9
+D+LqADSW/BzyfAJYaUm+iLffPTR7zxW/us5SGP6NykW4QehdAI3Cx03S04duj1T
ABqfljYmN3+EfXDEtBLG
=gGju
-----END PGP SIGNATURE-----

--=-G+ubo3cPwClBX8CfhgPX--

