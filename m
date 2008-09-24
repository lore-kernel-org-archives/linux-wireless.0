Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYIXUPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 16:15:31 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com> (sfid-20080911_100535_000722_EE099914)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 (sfid-20080911_100535_000722_EE099914)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nLkJNH1YfX5z544T/w48"
Date: Wed, 24 Sep 2008 22:14:47 +0200
Message-Id: <1222287287.4257.49.camel@johannes.berg> (sfid-20080924_221535_429438_C9A4086A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nLkJNH1YfX5z544T/w48
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 10:04 +0200, Marcel Holtmann wrote:

> So the best I got was the attached screenshot of an oops. It is =20
> clearly the iwlwifi driver crashing here and killing the machine, but =20
> I have no idea why.

Incidentally, if this really is the same bug I have, you might want to
remove the iwlagn module completely, even loading it once is a bad
thing, it has started to corrupt things here entirely by making DMA go
to random locations.

johannes

--=-nLkJNH1YfX5z544T/w48
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2p+zAAoJEKVg1VMiehFYgqEP/2L6+IUqm8DQpryAsEJJ/Zs8
olzi8kXHBI4d4LUTFc4EMmyPE5a3+GLPYbna9vzP2phFtlNlygHyng8ZCtVmswGg
nNVCKaGvPnvZpOWv4bZNEljmo6GBz9nXKNmCs0Vt6nBGkqDEMUmJjJqbGTb/Ucvs
3gvKekbroV/rp+O2II/p0JeFaz7os3JWrAh+b4T/9D1DC9ZzI+XdSTufBxVA1QgV
gh6dWsSfeBZ/1RfMmsjPOIxJ0dl0FYNhjniUYoKytdfnb/ukMBIYEqxlZqtMaPLV
Jlx8GTguomUInQVyPa7tb/ZPh9J+NHVn8PI+BODSxSXeHa7gmJk9I3RD2L2EdLtG
gX0qGk/5gHcF3ZDdOFdkvscJrffKX3BdEYx8QRnTRfr0ULh2qOqy/DyZg8ij4KIL
/MK9e1G/AB83n8wAgxqonzPnoBp2GcjXPMWrgJkAhp6wWfe6aIBavnvmagSw7drn
ba387DoIMz53DfN3fZYO+Dta51r/Jxc69hXYzmdeLuoUHQnxgGWXIB5qSMjMiKrM
aB+5fM5kY7M2crtPNjpuXffcu/ln+0j/ILmH/D9Sw8uNzgAjqYTvzRRBG0NfCyWb
mNVZCFF0wIG53D0h6iKeJjFlvIEpsp98+Bw+yXnzOl8NvILOXJkKqbtgk57mXVbN
3H47Ryvp70/OI7krcKnL
=bgFj
-----END PGP SIGNATURE-----

--=-nLkJNH1YfX5z544T/w48--

