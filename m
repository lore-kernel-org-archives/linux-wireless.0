Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZDUIee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 04:34:34 -0400
Subject: Re: [PATCH] cfg80211: mark all WEXT handlers _GPL
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1240302453.17388.5.camel@johannes.local> (sfid-20090421_102853_880867_3556ADF2)
References: <1240246179.4632.6.camel@johannes.local>
	 <1240276136.354.107.camel@debian> <1240302453.17388.5.camel@johannes.local>
	 (sfid-20090421_102853_880867_3556ADF2)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xm8WrOd3h/DX/eH1Qcu6"
Date: Tue, 21 Apr 2009 10:33:59 +0200
Message-Id: <1240302839.17388.8.camel@johannes.local> (sfid-20090421_103437_872429_67AE874F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xm8WrOd3h/DX/eH1Qcu6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-21 at 10:27 +0200, Johannes Berg wrote:

> > Johannes, why don't you want them to be used by others, say some fullma=
c
> > drivers? These functions can be used as glue from wext to cfg80211 in
> > the conversion period. After cfg80211 is ultimately used, they can be
> > removed all together of course.
>=20
> I don't expect any binary drivers to start using them anyway, but on the
> odd chance that somebody was considering that ... I just don't want any
> arguments at the conversion point that "we still need these symbols
> because we released a driver that uses them" which would mean we
> couldn't actually convert properly.

s/released a driver/released a binary driver/

After all, I'm saying they're ok for _GPL -- since that means in the
case this actually happens we can then easily convert that driver too.

johannes

--=-xm8WrOd3h/DX/eH1Qcu6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7YTzAAoJEKVg1VMiehFYpBwQAJGP36SeWjHQSb4gpN2qprNB
ER/T2RPbBoF1fCzUKcj3iglJnfwGnIwrlxNwVCPTDn5PxAKTEInA7LZ9q3nSW2Qa
VAUtl8g9RhamfVow8MoFSOg+6F1woMIdWpMDWrpSdw9EF9CvDtbKnleM+ifn7B98
+um9k+4592nyESzxKy5UuGXd1uZ9HFMA3hour6oCHsRwY14hMDfMN1/yd9Y2OJcF
4AnpybcPFnQOS9m2J3/i+1tyb0cr8e8YIX4vcYe3RbWqVROOOq8go5W9pCixTRSW
4beYtG7aOKPho6syLVpE7TAMBM/z+GcV38O3ZDgfj9VZawUaUDSpRr56cLAWMjfr
4vDqD28ArUgIV8VTjwP1MfAZFBDhz9X2VxMSfZvPTML8W03QxAPizemThxquHVWZ
B5zOIW1d3h834mzhtiUooVS5rGPvjTpgIs0/HCG0ZfGp3iZQpz8aBlLBi6eXeTfK
X9VG0B0ZPk8mG58UWFVGiF69T5ubhMZf7xUHF3bt6XJXmZAydsj9xQFdNFvfVdvL
8MUgmZA7l7qqP867VvvJxsWNYEpKcgoqW7SpmQb5tbvJo5b7B+JDFCl1NTgVbzfY
2r5hEjjJM+zE4diOSMSfzsEBCQqfuWPvwtQYABDs9Kb5nKgGDTQTqHKwdzCesgoQ
RzE8RK1IA0+Rag8dO1An
=Fo1G
-----END PGP SIGNATURE-----

--=-xm8WrOd3h/DX/eH1Qcu6--

