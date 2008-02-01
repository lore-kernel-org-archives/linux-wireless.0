Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYBAVP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 16:15:26 -0500
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Dyson <will.dyson@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Lars Ericsson <Lars_Ericsson@telia.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8e6f94720802011245i66a524c1j1d03a772f7477006@mail.gmail.com> (sfid-20080201_204542_412442_0D2BE232)
References: <479E928C.5000709@lwfinger.net>
	 <00f201c862b3$be1f00b0$0b3ca8c0@gotws1589> <20080129213746.790b68d2@morte>
	 <8e6f94720802011245i66a524c1j1d03a772f7477006@mail.gmail.com>
	 (sfid-20080201_204542_412442_0D2BE232)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UUIwpoVjDp/LWqgLXUXA"
Date: Fri, 01 Feb 2008 22:15:14 +0100
Message-Id: <1201900515.4188.77.camel@johannes.berg> (sfid-20080201_211530_362627_251BB0B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UUIwpoVjDp/LWqgLXUXA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> On my system, it is the "status->rate_idx < 0" condition.
>=20
> In rt2x00lib_rxdone() we set the rate_idx to -1 because we looped
> through all the rates without finding a match. This does not happen on
> every frame. I am still digging.

We've already identified the problem and Ivo is working on a fix.

johannes

--=-UUIwpoVjDp/LWqgLXUXA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6OL4aVg1VMiehFYAQKKxw/+Ow6blN9nXpWtYSMkfMaIrTeKQolCRw/H
WYn6VEQuJaPSctFxpThBY/G9IUj18EtyD9z4/ld2gQEEXEVAHEJuMkbfTLiwbwF1
TeMWz/ipUICfKreGgpsuVGPlSy8jHv8F27lnhuJ1PGYXa9Rw/9lWqJ65hzp5ef0x
z+YSHj/ZBBGJDHrEIWaHQ53xQrf/YB6twS8BNafDQ7ZjmZEy6/yAUbTRQG3mDDQe
MmDPiGuyIujn2m12nr67fMgT+0LWea2cDU0jpIwa/mL09dQhiC1XsALoDG36OQi5
MSLn+rm+Wxf3/DEuZNpUW6EWAQzbS3AUGk2cTbqJ8Bjay9GC1FNdZes7kCOqfLx3
nvUAwapdj+Vbsd+Vm3iRMJtTFzr/5//u8sNkvvzT7UT3ZURbyUjLNZOABo69RbSh
VZwj36ECW/CoDA9ltH9gFTdVTxUiy/J/F4wo/mgChHto6Kisz/GMVRHPAoBZZvId
WvrOyfvrl62PCgsxYKDKU5yvNmc0Hfnts74ONZWTim+HBC17XKh9yk4+BwjitpZh
DtTccqoJn4I2CjbGRxf4a+R7nMVEwOVzvqQiZ+23YVRQ27Otct83/wkevrjVGLlV
oUZaQPjm0yakKouMM1FrbvS69BeI21H9hDLheIrDIsWrwi0vW8wFou6+tzeLfRbN
08UJWCq03W8=
=lfp5
-----END PGP SIGNATURE-----

--=-UUIwpoVjDp/LWqgLXUXA--

