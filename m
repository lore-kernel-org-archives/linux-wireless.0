Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:47536 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3AKP6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 10:58:10 -0500
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id r0BFw8CZ012937
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2013 10:58:08 -0500
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id r0BFw8LY012936
	for linux-wireless@vger.kernel.org; Fri, 11 Jan 2013 10:58:08 -0500
Date: Fri, 11 Jan 2013 10:58:08 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: Re: RFCv2: ST-E cw1200 driver
Message-ID: <20130111155807.GA5153@shaftnet.org> (sfid-20130111_165814_857210_A792E6CA)
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
In-Reply-To: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 22, 2012 at 06:18:15PM -0500, Solomon Peachy wrote:
> Okay, here's the second pass.  Changes from v1:

Now that I've been getting some third-party test results, I'm planning=20
on posting a v3 patch series this weekend.

Any further comments before I do so?  Should I stick to the staging=20
area, or should I move it over to drivers/net/wireless?

(The only known problem is that IBSS is still broken, but now it merely=20
 doesn't work properly instead of triggering OOPSen -- still trying to=20
 track that down but I've been sidetracked by other OMGURGENT!!11 tasks)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQ8DaPPuLgii2759ARAggTAKCOOFbkcnG39SCUsQVimRlnlUvXagCeIDED
8rL0WUm3HWJ2XpyuWFoTwNw=
=5Ajy
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
