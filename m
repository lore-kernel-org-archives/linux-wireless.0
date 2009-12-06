Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbZLFKq2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 05:46:28 -0500
Subject: Re: WMM classification guideline for applications?
From: Johannes Berg <johannes@sipsolutions.net>
To: David Acker <dacker@roinet.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	patrik.flykt@nokia.com
In-Reply-To: <4B1933F5.2010408@roinet.com>
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>
	 <878wdi69u9.fsf@purkki.valot.fi>  <4B1933F5.2010408@roinet.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oc4Puup6Esv+wOcKL2lJ"
Date: Sun, 06 Dec 2009 11:46:27 +0100
Message-ID: <1260096387.3461.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oc4Puup6Esv+wOcKL2lJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-04 at 11:08 -0500, David Acker wrote:

> I am not an expert on how the kernel handles vlans, but it appears that=20
> the priority field's value is set by the user space VLAN creation tools=20
> through an ioctl with SET_VLAN_EGRESS_PRIORITY_CMD which calls=20
> vlan_dev_set_egress_priority to map an skb priority to a vlan priority.
> vlan_dev_hard_header then uses this information to populate the vlan=20
> priority field based on the skb priority field.
>=20
> In this case it would seem that skb priority and the vlan priority are=20
> both set and there may be a non-trivial mapping between the two.=20

But doesn't that also mean that mac80211 can happily ignore the VLAN
priority in the packet, because the vlan code will have propagated it to
the skb->priority, if the administrator wishes to use it?

johannes

--=-oc4Puup6Esv+wOcKL2lJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG4uAAAoJEODzc/N7+Qma/VIP+QEVBsYpEf9GPAzg52qdrM6j
PetBw5/fsAaXE7IKM+Sy/vjZPidt4WHdJnOiny35CfhTxzcBMxzzYPGkg1PTRSwt
DLDvYy5JOAWUkm15PRwBqaxjlwmg7LkT1Lf0l/MATcjntRvv2a/QtTI7oC21YWjs
Pu7+woap4g4jGc+Z3s501JPx4oqLFrSuSM0MnOtK5LM5ERhISYEGXBkdDDitMtnm
516DXO7mB0Lmd69CPANiwrnNeIxtMefFlccFbSy5YEBlATKGhQZSk24rjsBpAQtT
T5pX8NRADTaCuh9HQkTLCtkt6SvS0GxzrrS6XXa7M6qqS1yvCOWR7VlhxgfzJrJh
we7mSH9NkTCN+Nb5f+wbNQqaxWs1ZgZn8j1L7jNVXdqNRWc9UY+MzgTcmU67sSx+
54l+FqwktMrF1tejMBkoEYQ6e10ozJvmc94aXJ/TaoeWXLLJqT+vfUitaC3h2fsH
ebiPTGynKdhItDGKl2BIrP7Pm2k5CPKMEl0WowMoKogO2fF139631XCRbYxj89UI
l8oIjBXKYpLC8IHeFkfql+x62rkPnFiU+EqFD6AD5zFXZqOVmFRcc8Ql9pZJ3vdG
0oJYAjkh4hAi0pW08FAq3VP3QpjTmQZd4GuqHwdsYbBD0ixNm3mEp/fvg6pTrZRO
0P/3hw6b7RMRdb08aRTb
=YMSE
-----END PGP SIGNATURE-----

--=-oc4Puup6Esv+wOcKL2lJ--

