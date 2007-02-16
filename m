Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40840 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946208AbXBPShH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 13:37:07 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] d80211: Simplify channel & mode configuration
Date: Fri, 16 Feb 2007 13:36:39 -0500
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <200702092325.39994.flamingice@sourmilk.net> <200702151552.02331.flamingice@sourmilk.net> <1171645270.4153.2.camel@localhost.localdomain>
In-Reply-To: <1171645270.4153.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1309428.Z68NbPyCIB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702161336.44355.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1309428.Z68NbPyCIB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 16 February 2007 12:01, Dan Williams wrote:
> > Yeah, this is why rate control never seems to work right on my system -
> > NetworkManager keeps scanning and resetting the rate control. I'm not
> > sure exactly how to fix it, so I just left it..
>
> Hmm; NM shouldn't be resetting the rate explicitly.  If the driver
> resets the rate on a scan, isn't that a problem in the driver?
>
The act of scanning causes the rate control to reset. It's a problem in=20
d80211.

=2DMichael Wu

--nextPart1309428.Z68NbPyCIB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1fm8T3Oqt9AH4aERAiOQAJ0Y1Ek2rq6uw8p420B2+PSQvcNaJwCgoGd+
dtwYSOYXysbqpYD87tQnrJQ=
=yJEd
-----END PGP SIGNATURE-----

--nextPart1309428.Z68NbPyCIB--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
