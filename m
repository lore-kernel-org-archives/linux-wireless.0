Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56358 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZG1HeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 03:34:23 -0400
Subject: Re: [PATCH 04/14] iwlwifi: Thermal Throttling Management - part 2
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1248734807.1216.619.camel@rc-desk>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
	 <1248459194-10239-5-git-send-email-reinette.chatre@intel.com>
	 <1248733760.7015.0.camel@johannes.local>
	 <1248734807.1216.619.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ykWic2Drdlx9R2Hj54/q"
Date: Tue, 28 Jul 2009 09:33:49 +0200
Message-Id: <1248766429.8113.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ykWic2Drdlx9R2Hj54/q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 15:46 -0700, reinette chatre wrote:

> Sorry for missing this. We are trying to be better with documentation
> and need to do more work in this area. This patch is currently in
> wireless-testing. I am not sure how to proceed here. If I send a cleanup
> patch on top of current wireless-testing it will only make sense to
> address other kernel-doc mishaps. As our driver has not been tested
> (afaik) to provide meaningful documentation when kernel-doc is used I am
> hesitant to take on this right now ... but it is something we have to
> address at some point.

Yeah, I know it's not used, and I'm sure there's more -- I was just
looking at the code trying to rebase a patch and this caught my eye.
It's certainly not too important, but I wanted to point it out anyway if
only to avoid that in the future :)

johannes

--=-ykWic2Drdlx9R2Hj54/q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbqnZAAoJEODzc/N7+QmaWuIP/iIKh2rRC5EKIzPi1GAy7JGC
tueXXKOBkQ9CpHWO9msJY4iGsr85sb4UcWQP+KXGbshUvmDJ2aMMDmw+VSqnMyIS
7tl/KvtknTCroHqYVOy2S/dk3pMBcAsbcLPBmEsqNdu6y0mZtid2ciNuXwsd6xd2
tw7uSqTXwrB+nCO9UVwuF6aNAUSIUid2BCjxuwejq7K8nCOuVG/i9J76TaV4fGZy
itxbkqyEjlX9UYgMAFMHleNK7SPlNX0SwyrhIDTPUlPopiLfbwxDloeDy5IhWbo5
fmR6HPOELBEe/fGNvI9LYN7pM0PbyOlCf/FpRtzjzwF1hD/N2OhhAQlZctaOzCUQ
MFerXqUqQPO0bsnoU+8D3yT/M5qx6IDpSJYK2O/ASd6HO+Y7INv65yULhqCk9A9j
tx+frz1AW18WfbNoCVMzz/rhIt+s/GiS5wDe+aVfQ0/SgFTqARUKB4hqnzcFGYjd
mjiekrgo8Z0S2u9/AZ/yVbWpALx24dvwVa778xrHvdBVvWlTqax6bp7rJV/mTItH
jTQfujTlcsO9BcY8cthYE8WNvFP+VhI5jCvqNBPZGJ48QRi+Rm0Tv8E5CzU64oTu
rw5GvfJfBj0s/MFPMUUYvZ52fuHuLVrtPHvlEMRmyvk3mHzIRoRgJSEUltbI0KWc
nI7Hfk+5q5V58ls+zIGV
=m8Bv
-----END PGP SIGNATURE-----

--=-ykWic2Drdlx9R2Hj54/q--

