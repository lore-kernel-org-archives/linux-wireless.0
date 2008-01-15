Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYAOMPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2008 07:15:08 -0500
Subject: RE: [PATCH] iwlwifi: fix bad unlock balance
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <D936D925018D154694D8A362EEB089200364DDED@orsmsx416.amr.corp.intel.com>
References: <1200046964.3861.157.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200364DDED@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/YZP4vNSlZtGuVU4Dk4H"
Date: Tue, 15 Jan 2008 13:14:39 +0100
Message-Id: <1200399279.5887.120.camel@johannes.berg> (sfid-20080115_121520_716964_6290219D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/YZP4vNSlZtGuVU4Dk4H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-01-14 at 10:38 -0800, Chatre, Reinette wrote:
> On , Johannes Berg wrote:
>=20
> >=20
> >        iwl4965_resume(priv);
> >        mutex_unlock(&priv->mutex);                  /*** not
> > locked!! ***/
> >=20
> >        return 0;
> > }
>=20
> This was fixed in 5b9264550dc190b7330a4bde615083883c1cde11 ("iwlwifi:
> fix-up damage from rebase of namespace separation patches")

Huh ok, somehow that wasn't in my tree at the time I tested then. Sorry
about the noise.

johannes

--=-/YZP4vNSlZtGuVU4Dk4H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4yjrqVg1VMiehFYAQLLhRAAtJdXZAWyr6cKIve5wgKxSIu0qJEbkzWq
jwE5ufEGUOitgySTh4si+uc51+66cRNiUmEKlYzcs8iG3t7dy42RT1w6cA5j54hj
5f78tDChjfhxvzbZ0d9Pr3xZsXtIZV0F3t7HnYn5b4xsHt0EMS+M66kYBVJPpOil
3s7+C+V6MPKkA7XOVHQSsxs2ezmZEp3f4wIHO0KExW9FxnmHxIbpdGe43M+SLmKN
fRHj8aTeSPUS4ubDyavZ/Eh/+g+9xPb+V5dAh0cxQkvzPR8TF8f5YZ+9anVVBoJm
aGQx6sA2ATrYUFpQsksaIDdJ5HwKiTyJ76mTAEwPzc/c/45JCH+18l6tEsrW+9aB
LuZu02Sbo2Vg+/d5qCnNd4C6RNnBgTk0h4P794zp22WtGSjrfkwWlqABHavgwJYl
VinFGtosv2QKBbsuwBni2glrER5gn19hGz5QVId1YrF35IqUnbcX1sO/NfrRq5nS
baczLi7Elp4Zb3+ldIOZvlEZcNfLGvpCerpuCRs2zzl5Y4FYtYd8A6QTzltXA5U4
PF0oTjJAumwcB+JKp8IQlp+0pgYjfuIxx2KBYuvhGcW4bdeGfi0lN56wItSfU08H
8Wme+ipnnbcctTY9WmLCn1QHvj8ixzhYqrQ2u/2TA7A/j1Hmfs+zBA5po859ukPC
ZLROgKelFos=
=SiE1
-----END PGP SIGNATURE-----

--=-/YZP4vNSlZtGuVU4Dk4H--

