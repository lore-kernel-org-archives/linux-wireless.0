Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYFXLWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:22:41 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1214306147.12270.9.camel@localhost.localdomain>
References: <1214149401.8585.2.camel@localhost.localdomain>
	 <1214297745.8967.255.camel@johannes.berg>
	 <1214306147.12270.9.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9YPah+R8e9EfUqqvJvLD"
Date: Tue, 24 Jun 2008 13:21:51 +0200
Message-Id: <1214306511.8967.288.camel@johannes.berg> (sfid-20080624_132243_984967_15F8AAA4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9YPah+R8e9EfUqqvJvLD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 07:15 -0400, Dan Williams wrote:
> On Tue, 2008-06-24 at 10:55 +0200, Johannes Berg wrote:
> > On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> > > mrv8k has commands that get called before and after the scan has been
> > > done to save and restore hardware state.  Add optional callbacks to
> > > mac80211 to enable low-level drivers to know when the stack is about =
to
> > > start scanning, and when it's done.
> >=20
> > I'm not entirely against this, but does it mean the driver will not wor=
k
> > with the userspace MLME that does scanning itself in userspace too?
>=20
> Probably not?  Both TopDog (linville's marvell.git and your
> marvell.tar.bz2) both do this.  It's too early to tell whether we can
> get along without it since the driver isn't functional enough yet.

Hm. Could we leave it out of mac80211 for now then until you know?

> BTW, where'd you get marvell.tar.bz2 from?

No idea, I don't remember, I could probably dig it up in my email but
didn't find it quickly right now.

johannes

--=-9YPah+R8e9EfUqqvJvLD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNjLAAoJEKVg1VMiehFYbZYP/1zVzRuYmqMt6ZCXIjU1zyxF
JTlAibYOqFmhduZvC5XBlLI8IJWxFnN1aU16IXRfiIVIKUHtXk2j8HJ8kLd2L9LE
A+diizjn2FuTdhgDPfqJwGky89K5c0FIr/xKzhKdjA92zteW6XhtLgF8oYYk+SKk
mug0X7aeWhBmCRwZgHrA1L/+pW2R5k+t/DvGGxKhXtejQV25LfSwPg5XczodqW5P
SQwb+WP1HlCEbkfwSdlqxPT5ArBwsT2PViqQu46lRIgY5Iwl9O21/mxb/fdHSFTm
OB8v5Gf6DK2NNYPS+xepiKZVq1simujGj+9P1kFxeN05TiwpFPufPqYIEu92wgVp
hdM5rs3x3JO+FQDIGu7LSPvB9yxtimIvKo0ED2SaTdHfsgZwzTXuJXsH1W7X7W8Q
bBLAsWU0NYM//Z9SYZ5clVxdqJoL4Dsf8uybsbD40+txhlwxtqHHBGjLA8deCfu6
tM3m4OdeHNjfsxtXXNA34U6zDrDyWes8CD7PzC3hBhhMSf9KCfECv1S21CfFkxEd
LIKw1A2ay/JstPwY9A/ikqWoewDpVkSf3XEPJRM2Vr3CLKEth/QHy/nWFPO4DcUx
b6V366VcgEWX7h5j0me5HnY+M0O6Jw2gFE5OS1qsI2jEtE59vvssGfDP/03mY9Jr
SyvVAL3gYtEiw7Lvu03k
=uExX
-----END PGP SIGNATURE-----

--=-9YPah+R8e9EfUqqvJvLD--

