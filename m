Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYF3QV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 12:21:29 -0400
Subject: Re: [PATCH] p54: Add quality output to iwlist and iwconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <486904D4.4010705@lwfinger.net>
References: <4868fe45.swzEykllJP3Ow73U%Larry.Finger@lwfinger.net>
	 (sfid-20080630_173834_531803_0FC8E191) <1214840530.5507.52.camel@johannes.berg>
	 <486904D4.4010705@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7O+dTKuMvhI0HHHG6TBm"
Date: Mon, 30 Jun 2008 18:20:41 +0200
Message-Id: <1214842841.5507.56.camel@johannes.berg> (sfid-20080630_182133_005533_3E3237A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7O+dTKuMvhI0HHHG6TBm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-30 at 11:07 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> > On Mon, 2008-06-30 at 10:39 -0500, Larry.Finger@lwfinger.net wrote:
> >> The p54 driver family reports a quality of 0 in iwconfig and iwlist
> >> output. This patch calculates a quality number as a percentage of the
> >> rssi to the maximum signal of 127 reported as the maximum signal.
> >=20
> > Unrelated, do you have a p54 card? Does it work? I wasn't sure whether
> > the tx-info sbk->cb change broke it or not after I fixed up some things
> > there.
>=20
> It is DW1450, which is a p54usb. It works with the latest wireless=20
> testing, at least in b/g/mode. I don't have an 802.11a AP to try the 5=20
> GHz mode.

Great, thanks, I guess I did find all the problems then.

johannes

--=-7O+dTKuMvhI0HHHG6TBm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaQfWAAoJEKVg1VMiehFYBFQQAIm62tjDOl6H992I8o2UyVX9
hDAs8S4e+RAG5oJOXqQ0sNwktSDHvfBTs0t+888e+5rVfpTpt9uFHjI2Pep/KRV7
NcaaBuQn+Dn0Rmzm1KeDjBeO41++u15BlDNrgIm1dF/z8kDgMyZQvPSszSScxq4y
MqQlubFRAsdnuZV/bF/vjHbSgYR/zmx4+kS8KlxvpxJaf7Atq7pbNv4jMUuT/8x+
gchHIJFQuVpimHRMqu/tPxMhmquOGTplsx5kgcnVDcQp0skjI1sn1hhZHJyJZvor
vaBwRZieHTGkaG+opR8EF51udiZLTHiK/yzsMRDk+IpQSj2RY/jt2BMYvAj3cVUW
lCkNxG2VJRMAhnVusINh5g2CBkZzL7yZZ3Tjk8fmaRzSynULAbHr3JHvkwXdFnr8
JQqKLJhl0YEoOmKXi2w1E0cJJbCSTBD0VQr/kAeBh81D0CnY56InZnyxyfHVUH6E
k2GO7kr5eHotifaiGk8pmn3ZcmrHaEV//o3SHnhg6Tgr48GgRgSqBwybvDfeKVfc
0MXboLdtaJuQsqk0JCyD/dFHwdfUqltzTQuCMKjh7lyFO+1D1bqX7kuZATP+h+I4
9B/reRbzQ983JgQ7GkeThm3DhTLB/jslk55TZgry7uIcEK4FTZuIhu7CvQNdO1aF
0SmsJp74S+ujXbQEWBUS
=XHm2
-----END PGP SIGNATURE-----

--=-7O+dTKuMvhI0HHHG6TBm--

