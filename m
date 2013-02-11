Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:58004 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472Ab3BKTHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 14:07:44 -0500
Date: Mon, 11 Feb 2013 14:07:41 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
Message-ID: <20130211190741.GC3123@shaftnet.org> (sfid-20130211_200927_934685_F539B9D8)
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
 <1360372559.13487.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
In-Reply-To: <1360372559.13487.14.camel@joe-AO722>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 08, 2013 at 05:15:59PM -0800, Joe Perches wrote:
> Could you please run your patches through
> scripts/checkpatch.pl --strict

As an aside, the output of scripts/Lindent actually results in=20
checkpatch ERRORs -- 'u16 *ctrl_reg' gets converted to 'u16 * ctrl_reg',=20
for example.

(Using GNU indent 2.2.11)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRGUF9PuLgii2759ARAnjZAJ9mLx7YKxNs4Nj2bWnnxndI0T3+zACfRlZw
+QDTIc3ZnhWPBIG8IO6KsYI=
=W60B
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
