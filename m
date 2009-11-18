Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbZKRXrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 18:47:15 -0500
Subject: Re: [PATCH 15/16] iwlwifi: handle unicast PS buffering
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1258587250.8981.11.camel@maxim-laptop>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
	 <1258142198-3223-16-git-send-email-reinette.chatre@intel.com>
	 <1258150491.4182.6.camel@maxim-laptop>
	 <1258150857.6167.28.camel@johannes.local>
	 <1258587250.8981.11.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5EodA/rkM3gw814opm7i"
Date: Thu, 19 Nov 2009 00:46:46 +0100
Message-ID: <1258588006.30511.90.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5EodA/rkM3gw814opm7i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-19 at 01:34 +0200, Maxim Levitsky wrote:

> So, the multicast/unicast buffering is the sole problem that forbids AP
> mode, right?

No, unicast buffering is actually working after this patch :)

So multicast remains. I cannot make it send multicast after DTIM count
=3D=3D 0 beacons, it either sends multicast too late or too early. Haven't
tried 3945 of course, those don't seem to work in my machine.

johannes

--=-5EodA/rkM3gw814opm7i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBIdiAAoJEODzc/N7+Qmar+0QAKmVVd3gukDlMStVC3juR+CG
GctfEKBAC2DlFjigaCEbMxF/iB96jHkSVBiKuoaGprb/p7O5sKDGLE54tjTiGtCA
awAhNCTL/NbZmcarhVBz5n/mvKg9YlXONwtmAVUiMGNI0HS54DSOuYpOtcmHctXs
1JQq7C+EpnBhO+pE1uVBAfJgWhdeEBgTxDdVKiT/YR9NXYH4Zd2BtU5xuJ8EGxUr
9qarFQfs3q+oCUT+wDMNWJf5OTai3lFmToYBkCoYEbyX+HJc4klI953Zz/CbXQmW
F7VLEMRkC/ouDxlODgye7wKceWUT6X74aC2d95Mkj8SRWUqLhbmlVH/PkJsbxXns
RLXMJi5+Ah9bIfJIDZa5eyW5rLBeZrY2JMUUyPjYeX0JPcXJB6Je4NjgY2/5Yci8
XhH4DVCsKcAXDdA1ZjTSoh3MmwsOliuDULo9/BSe+RtXkY5DF4vg1+dTrviTtmtY
CvCbI9tLLDt5tjuBvl8xFLg1E4bN32I7tlKiCeNilER9AftiSfCP3wDTStDmRpCj
5M09j39g3Fl9SGgvLQLE0+D/vL/2gvqhmyju5pb+9dM56joCGheqH4ppaN8WMDm1
5XkAe5HnKgzEpnyw74d184it/6bIIkW1pac2rlH9rwyp/TY8gfVYEQsQ1irRkuBK
I/jebB0I02sJdkDFiBsw
=+mwg
-----END PGP SIGNATURE-----

--=-5EodA/rkM3gw814opm7i--

