Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:53604 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab3BKSx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 13:53:26 -0500
Date: Mon, 11 Feb 2013 13:53:22 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
Message-ID: <20130211185322.GB3123@shaftnet.org> (sfid-20130211_195341_799993_EDB4AC51)
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
 <1360372559.13487.14.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
In-Reply-To: <1360372559.13487.14.camel@joe-AO722>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 08, 2013 at 05:15:59PM -0800, Joe Perches wrote:
> Could you please run your patches through
> scripts/checkpatch.pl --strict

If you think it's bad now, you should have seen the state of the code=20
when I first "inherited" it.  :)

Question -- as a matter of policy, is the goal to have a completely=20
clean checkpatch run?  I get that there should be no ERRORs, but=20
WARNINGs/CHECKs are not considered fatal for a reason, right?

As I write this, there are 550 WARNINGs and 243 CHECKs in the patch set.

There are three general classes of WARNINGs in the code --=20
alignment/indentation issues (mostly caused by the conversion to=20
pr_XXX() calls versus printk()), >80char lines (unfortunately resolving=20
these tends to make the code less readable), and a boatload of CamelCase=20
variable names (which this codebase inherited from vendor header files)

I consider the >80 line stuff to be generally noise, but I'll revisit it=20
once everything else is handled.

As for your other suggestions, I'll add them to the to-do list and knock=20
them out as time permits.  Now that the major problems are solved, I=20
guess it's time for the tedious patch iteration until it's acceptible=20
for wireless-next.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRGT4iPuLgii2759ARAvhpAKCWNqKob8roqH3sG0uzAzc3k8GIsgCeLq5p
TkrONONK3F/B7QB5GYn8418=
=p7uV
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
