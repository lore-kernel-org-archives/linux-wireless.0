Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYJOIsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 04:48:36 -0400
Subject: Re: [PATCH] libertas : Remove unused variable warning
	"old_channel" from drivers/net/wireless/libertas/cmd.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <ea11fea30810150110s772b740fv38cc37645da53201@mail.gmail.com> (sfid-20081015_101012_936383_4BE67F0D)
References: <ea11fea30810130352i3cea0579g9950289254c8e628@mail.gmail.com>
	 <1224002213.1799.2.camel@localhost.localdomain>
	 <ea11fea30810150110s772b740fv38cc37645da53201@mail.gmail.com>
	 (sfid-20081015_101012_936383_4BE67F0D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9uPOirnTJ/eimMfRupMG"
Date: Wed, 15 Oct 2008 10:47:55 +0200
Message-Id: <1224060475.27537.0.camel@johannes.berg> (sfid-20081015_104840_139186_AE6D019D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9uPOirnTJ/eimMfRupMG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[dropping libertas list, subscribers only]

On Wed, 2008-10-15 at 13:40 +0530, Manish Katiyar wrote:
> On Tue, Oct 14, 2008 at 10:06 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Mon, 2008-10-13 at 16:22 +0530, Manish Katiyar wrote:
> >> Below patch removes the following warning during compilation.
> >>
> >> drivers/net/wireless/libertas/cmd.c:826: warning: unused variable 'old=
_channel'
> >>
> >>
> >> Signed-off-by : Manish Katiyar <mkatiyar@gmail.com>
> >
> > Acked-by: Dan Williams <dcbw@redhat.com>
>=20
> Hi Dan,
>=20
> A newbie question. Will you merge this patch or will I have to send it
> to Andrew again acked by you ?

John has already applied it, Andrew isn't typically involved with
wireless.

johannes

--=-9uPOirnTJ/eimMfRupMG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9a40AAoJEKVg1VMiehFYY+8QAIQSMFK/sp+q9JOXp4LNZjaW
UGjF/tx6xZ/37Qh+IR5O+/kSO68SFvMlgtMhftQVdAhX1dNjjR4bABYEsyO+yy0q
299u10TmwytORepkPovd6C+qcIOCZ6485yYx+vA9uRKpxGnfWrmt7eAUjvn7RIka
LCjtdx8H2CvZrWlKtgxZXpKYm1Q8NAydBMntvhgrSDeEyAumiSTYqNelOW6mkMKn
axTz004lROXNNrRmE31z7YyIk6yhvuMnUedGPWHczEg+v56fQuI2lclb+imqx/KE
VFDzERcQxn0LzGgkOB/Xaz1uIRiXKIYEanPevIqOcyHZlnUxe/9URFYUhT+Q+4ux
er7JOt6Q1Pka8z0lXEVCWKKLWRzag7bmtn9fG2e8euKD2Qw6ZhSfn9mtVfLP389L
w62uWjkV2L6k5T8nH3QPU696c3mZ/oykLgegu4OBGNhxLiyde+P9INj2KVS1YuBH
nTF82pNs+vrm9nku64W+mpzGkjAsWTmTn0UFv2LxnQ0H0RDJrrBdaZYHISPrYGpU
zPkEKMZzAgV7rAjWeESWeHSlTqJDG5UENq4tq41TrIfS9Uh0bZKSPZgW3LC4R+61
SSIopTl51NmA1rLbMTdVWbEJge/YdDJBUEl97sNEi+CuUvDmh9B/xwIM+jwTCoqe
KUEK+uVAf0F6trNDvEAz
=71l/
-----END PGP SIGNATURE-----

--=-9uPOirnTJ/eimMfRupMG--

