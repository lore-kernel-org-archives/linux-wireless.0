Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXKBKX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 06:23:27 -0400
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <8e8340660710311721m5a8cae83h743dcfb09ea6bba2@mail.gmail.com> (sfid-20071101_002118_447499_78B52EA1)
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
	 <1193833372.23775.42.camel@localhost.localdomain>
	 <8e8340660710311721m5a8cae83h743dcfb09ea6bba2@mail.gmail.com>
	 (sfid-20071101_002118_447499_78B52EA1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4aE2nviYJ5kZknxPbc9J"
Date: Fri, 02 Nov 2007 10:20:30 +0000
Message-Id: <1193998830.25744.1.camel@johannes.berg> (sfid-20071102_102334_022209_34062619)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4aE2nviYJ5kZknxPbc9J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I do not know either what would be the best place (Johannes?) but I am
> going to implement specific mesh statistics in sysfs so you could use
> that or I could add a specific mesh_iface flag in sysfs.

I'd prefer if it was debugfs for now so we can actually test the API
first. But it's up to you, if anything having a sysfs interface might
slow down merging the code into an official kernel though because that
(in my view) requires more interface testing.

johannes

--=-4aE2nviYJ5kZknxPbc9J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyr57aVg1VMiehFYAQIWDBAAqF5ZbBIXkyBMMoU3jhB7NjrOkk1bRAyl
KMNgMy8yksHu31kUrbtcMYOF97vxX5aZm6+2XIgCcAc5VYD+MyahLdrIAB7CkaFn
prxv3um9BeF76j/pqLwxuvr6cZsZyXL42p/PQfTwuQH4WwS5ZS61Ed5kS65yWVzQ
Z9ZHeaaDHcYXXp+nGTHBUFaQ4bw93XX1DDUFNYRyjT0kqbDvphgVgGWaEkYQkePx
mRaQHv2qP4vYh89zGb89fp7FU+gWm/CJpnQ0YQUS1X/4+EIG7iSylRbKUAhB+VwD
2Pgr22CviB+h5bdKhGYQTqtQOoR/oApcBRBCmXjCWbgfz1Bv/l9rJONY5bTfkNe7
gwPKAeamGZbCsmOyqg3NQP4gjAXueZqmrc+LQTt0rQ8XJ/MozU9HQ+QccKL8+EDV
dFQCU8TCtzn12i+qv2e6JMpN335Vv8smd4q5K5MQjn4sfKgNlBxe/fsmuUiBwPYY
j+uKp37WkjVZUnzL0t6LFLT2RjLjQL4BxgTNTm0vXs9ULGU71y1xzh+/ofXSuyq5
UXW4pLgyXD1tCNiTZTA8+QuU0C0mf8UGjw9q2PRcn47CpCJzOO5wIHWgPZyioD5R
IjIG62BNjJIpG10yrL+gyZDo8EopW1IHADt+YefUquu3htY7ZVeqtHn1Ted1Ff4l
aTEU5/clYhU=
=lN/x
-----END PGP SIGNATURE-----

--=-4aE2nviYJ5kZknxPbc9J--

