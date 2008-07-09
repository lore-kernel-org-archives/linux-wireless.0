Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYGIPeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:34:03 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091736.55061.IvDoorn@gmail.com> (sfid-20080709_172810_043226_C93EFDA4)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091708.04870.IvDoorn@gmail.com> <200807091715.24710.mb@bu3sch.de>
	 <200807091736.55061.IvDoorn@gmail.com>
	 (sfid-20080709_172810_043226_C93EFDA4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C8qaEJPOkSI6DhgBpVav"
Date: Wed, 09 Jul 2008 17:33:15 +0200
Message-Id: <1215617595.3246.26.camel@johannes.berg> (sfid-20080709_173406_667358_22AEE893)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C8qaEJPOkSI6DhgBpVav
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 17:36 +0200, Ivo van Doorn wrote:

> True, I have to double check it, but the legacy drivers use per-queue loc=
king as well.
> And it would still be possible for the driver to send out frames with a h=
igher
> sequence number before one with a lower number.

The legacy drivers hopefully also implement proper sequence numbering
per TID. I'll send another mail on the topic.

> But I'll put out a request on the rt2400-devel list to see if anybody is =
interested
> in looking into this issue for rt2400pci and rt2500pci. In if there is no=
body, I'll
> disable adhoc and master mode for those drivers to prevent problems.

Heh, that works. Just disable it and tell folks who want it to work to
fix it :)

johannes

--=-C8qaEJPOkSI6DhgBpVav
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdNo3AAoJEKVg1VMiehFYsREP/jopGTrfk3HZi6aWge5rKl5+
9eZPSTqWY0UQ3gTFd5sxJzFw8OPazHtm4ftyBb2ChwPbHI5jFIz4FRlpuozLSjZ7
7bnC7DsBCKze2Rf7KeVMbbN3fYYQ1f60mU1bwUqVp/wYGwQL2oC0jr+0AxFwFyB5
+7E9hJL5Cm+2dil9SFsoP6Jm0EEmfWfi8TLJSSpI5k/Q0cqoYekQzxkydz7cZpPo
0vEJyu1rG+jVLCaYg6uLzHn2kXP8SGjGCt4dRmtyyzlFlsrmsed8b7D90nLVV9Jz
2KGN9PHnnnCX/fuN1+BL0wObsUFEOf9CvF0yWJFd8LoJthcynqd8hrewKiBqoIVW
VQWgD8XEZ7jvY15JonpG85/wXT9dmOhVhmmsdbI5O4m/FqPGDSW7j/xSMNuYjBnt
Al0/lrDT1RAjdfSlQoc1v0+dwQpeEmpLkTZdhZTQbHvjYOG0vOZ5cYcx4T7kSGtN
0YyrfR2jqbWYAiocy57e2OxuI7MQXXk7TWGksg/nGrN/RvWCN8h9drS68vaU6HiO
5FP6LmvO7cV02Ag5l51jVIhcIzE58KLv2HxaDIVhzYmy5JIWSAREtHxQDLh2IBGF
pZLZG4RoM368S8Xzt41wsAqWcDD5b67i5Zna8UOvfVIVtPF+sDE8+qO7ivo7pOQa
S8mYCf1t4uABABAzKjEe
=h3uR
-----END PGP SIGNATURE-----

--=-C8qaEJPOkSI6DhgBpVav--

