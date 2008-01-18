Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765963AbYARUvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 15:51:52 -0500
Subject: RE: more iwlwifi merge fallout?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <D936D925018D154694D8A362EEB08920036F28DD@orsmsx416.amr.corp.intel.com>
References: <1200615744.5716.5.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB08920036F28DD@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vlAD0tlQg4AORAd1sWRi"
Date: Fri, 18 Jan 2008 21:40:47 +0100
Message-Id: <1200688847.5716.40.camel@johannes.berg> (sfid-20080118_205208_119640_F4BAF3C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vlAD0tlQg4AORAd1sWRi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This is not merge fallout, but has been this way since the driver was
> merged the first time.=20

Hm ok I thought it might have been a "static inline" in the header file
and gotten split up with the driver split.

> I do not know why it was done this way and I am
> not familiar enough with gcc optimization to know the implications of
> this (or what the better way should be). What do you suggest?

Well I think simply removing the inline will cause the compiler to do
the exact same thing as it does now and look less strange.

johannes

--=-vlAD0tlQg4AORAd1sWRi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5EOzqVg1VMiehFYAQLnKQ//TWFvsuqYkn3akyVJyZLs2/ezZaqOcjsM
vYYYnfcI584Nhy5lAMoKqXRWcxOCaSfeDqAKtMVRJqmftX6DTwPOKGxVdKKY44bV
cBADJGP+BZB2TLuKU3/dJlsDRaCI72iaaQpw8cB05V9AfR86bkCqMeO8v5XBeTQm
iQXS4iNKzb+ZC2e+X/6Fdm3pHMq7I0N8LbQeObsjqVEEzEP0TJBH2Xh/kSrSj0Qf
d9KgcIS6tJO7LlZaM2dqNJlwjfJ39ksQGL77HZlFTI6sL9KvZAZQR7lxCtLo5atW
AfCEQhDEvMFM4IjcUsUP6i1GSpYPwJerSHuI+7lxjgZqbes4sXT92nlrWfMGSkHL
mP8NpJampBoiPNFKfyc2K7dIfduE4JECEPoY/SLGtTCRvST8CxCyRaeGbQFUMfiH
nQVz97eDl4FeMaNh8jC7M45nAICbyrO/5EIegbDOtbnSSfuMf/ER3dJxxE7C/rSv
BK5oYqF7gXWdtAs11FYuzP3Bhg7nEsfmS2Pt2XkZNIwYS3UojXWP3y5nI2o5KzpS
qSzmy1rykitn/SOuiW8hSRpsHMQbwe0WVb4LuCVjJxcwplu93+w/5uzZnRitGi93
6mBPLLyy8C77tWSzBdCmPfU8jWFEoEZLifiPChnrDeXSiux8EinI7H0mbLbkcOY7
tJqDokQhD8U=
=mQjh
-----END PGP SIGNATURE-----

--=-vlAD0tlQg4AORAd1sWRi--

