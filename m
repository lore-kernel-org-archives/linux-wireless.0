Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34063 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbXFATEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 15:04:33 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
Date: Fri, 1 Jun 2007 12:04:18 -0700
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706011129.12432.mb@bu3sch.de> <4660503C.9080309@linux.intel.com>
In-Reply-To: <4660503C.9080309@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2484113.AxSnzkvUBu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706011204.23666.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2484113.AxSnzkvUBu
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 01 June 2007 09:58, James Ketrenos wrote:
> In this way we are putting in a work around that doesn't result in an API
> change, and that can eventually (hopefully) be fixed the "right way"
> (whatever that may end up being)
>
A workaround could be implemented, but I currently don't see any cases wher=
e=20
stopping/waking the queue outside of open/stop/tx is necessary or correct.=
=20
(in bcm43xx, stopping the tx rings is more correct and effective for what i=
s=20
being done there - stopping TX so the radio can be recalibrated)

=2DMichael Wu

--nextPart2484113.AxSnzkvUBu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGYG23T3Oqt9AH4aERApMAAKCdPLbUpEDw0XynBKUdwKFW8RLFtQCgtOyN
Nb2Xz5Acs9zrVNZ+ehBZGIE=
=uUlX
-----END PGP SIGNATURE-----

--nextPart2484113.AxSnzkvUBu--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
