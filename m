Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:38989
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751656Ab3GTLzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 07:55:45 -0400
Date: Sat, 20 Jul 2013 07:55:40 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200:  Fix incorrect endianness annotation in a header
 field
Message-ID: <20130720115540.GB22702@shaftnet.org> (sfid-20130720_135602_336792_B85E20A3)
References: <1374292945-29753-1-git-send-email-pizza@shaftnet.org>
 <87fvv9yd33.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
In-Reply-To: <87fvv9yd33.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 20, 2013 at 09:12:16AM +0300, Kalle Valo wrote:
> Comment referring to releases should be after "---" line so that they
> don't end up in the commit log.

Duly noted.

> And besides, I don't think this is important enough for -rc. I doubt
> there are users who absolutely need this quickly and this patch can wait
> for the next merge window.

This is effectively a documentation fix, since the driver=20
currently sets that field to '0' (ie "use firmware default"). =20

That said, while it's trivial, it's a fix nonetheless.

As long as the patch doesn't get dropped.  I have my preference, but=20
I'll leave exactly when it gets merged to Linville's disretion.

(I have some not-yet-finished new work that's clearly -next material,
 and two patches that need to go into -backports, as soon as I figure=20
 out how to integrate that)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFR6nq8PuLgii2759ARAnydAKCYPfw2N5V6n6QnzxNSCTQG9ZBewQCg5SVY
SyA9MNIqVsUsXUYBZOdCgsY=
=t8Oh
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
