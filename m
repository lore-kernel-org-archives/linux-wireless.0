Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZDBSsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:48:39 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49D506FE.5070405@lwfinger.net>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>
	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-I7YsTi9loaIAdHO+RhCx"
Date: Thu, 02 Apr 2009 20:48:04 +0200
Message-Id: <1238698084.7630.3.camel@johannes.local> (sfid-20090402_204842_882765_82560824)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I7YsTi9loaIAdHO+RhCx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 13:42 -0500, Larry Finger wrote:
> Johannes Berg wrote:
> >=20
> > Also, if increasing that helps, does it also work then? I mean, does th=
e
> > LED get turned on/off?
>=20
> No. I'm still not getting the appropriate call to the set brightness call=
back.
> Actually, I didn't expect any change as the truncation from the too-short=
 array
> length only occurs when the pseudo file is dumped.

Hmm. In my tree TRIG_NAME_MAX is only used when you try to /write/
something to the trigger sysfs file, so that garbling and the patch
don't make much sense to me. There must be some other weirdness going
on.

johannes

--=-I7YsTi9loaIAdHO+RhCx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1QhiAAoJEKVg1VMiehFYENYP+weX/CnhQVpqXwQEZWvhdNFe
vfFFDCe5jlnkE4LBMMmCpKen656i9i5mivTOgdGR4UsTM8IsmRlPAJ38Sezf2UcV
BprNTUhclSkVZ/WoKKdX1B5EruZVN8IVQ5dxfxQgyN+5idBDYYghD8mrluHEKcPc
t3dWO77HCjPa4QoooKGSg15iZJE6dSMUplkZ1qVTerJOKbvCJOUznzhadaPrbFUv
UBJHJv0/iO0kchBaKUZTyCQ37GEwr8ZWPuYYLqZS9dbZmEtKgWT+CupS7jZud4km
5bKhIuWZXu4Zq56hCZXUqCTRPCucynSu1LFJ/ez/BtJtauRJhmH6KuSPrNa4o/+9
TetKuUNQp+WbjhZ57WsXtNHaQuHVJNDxHujrumb+QqEeJSN4tHvAJEEHjq7sx5QV
BnigHJQYVRAxDzn4RdH7GoE/03alFIfef4G9JWj3Jw6v8aUcyKq/V8DeL6pElx29
qDMzKKc7aH0zVgvNujc5p0XGJUU/b2pcYGYRD0mTZhRamontfXjgo8T8kZpOswU9
lc7XYEJYD5A/zgtCM6wSblDpErnQZVhUzogGbZLGbZV25ZG/vFhGAFB7XDxCsk8H
TKsKzcWPd/XVSxk7tYbPV2EDXSdr/g6BNMUUpIIu+H3fwkSFgWZR8LWuV2zs4AgK
dPKWuaIDtdvvN6bZs9Xm
=TiSD
-----END PGP SIGNATURE-----

--=-I7YsTi9loaIAdHO+RhCx--

