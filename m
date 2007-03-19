Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23911 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030387AbXCSQvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 12:51:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Mon, 19 Mar 2007 12:50:42 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070318101535.251183750@warmcat.com> <200703190156.07984.flamingice@sourmilk.net> <45FE6C02.5050605@warmcat.com>
In-Reply-To: <45FE6C02.5050605@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1227885.z6XHLNEoeD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703191250.47929.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1227885.z6XHLNEoeD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 19 March 2007 06:54, Andy Green wrote:
> Michael Wu wrote:
> > I've mostly made comments about style issues. There are only comments on
> > the first instance of any style problem so please check the rest of the
> > code for the same problems.
>
> Thanks for this feedback Michael.  I have changed all the style problems
> my eyes could see, assisted by visiting every =3D in the patch.
>
Just one last thing.. a bunch of the comments in the last chunk of the patc=
h=20
are still indented too much. Otherwise, the 4th version of the patch looks=
=20
good as far as style goes.

> > Have you looked into padding issues with radiotap headers? For example,
> > if there is a 1 byte field which is then followed by a 4 byte field,
> > there needs to be 3 bytes of padding after the first field, but if the
> > field after were 2 bytes long, the padding would only be 1 byte
> > (according to my understanding of the radiotap specs).
>
> I googled for radiotap specs but I didn't find anything useful.  I added
> some small code to enforce the alignment rules you mention above.
>
I got the information on padding from:
http://madwifi.org/wiki/DevDocs/RadiotapHeader

I don't remember how I managed to find that, but there it is.

Thanks,
=2DMichael Wu

--nextPart1227885.z6XHLNEoeD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF/r9nT3Oqt9AH4aERAuXEAJ91yboUQASN4Ho6ApHuIT9TF3Ed9gCgyavz
FlXoNYR4obmi8XFcMEGNbz4=
=mg96
-----END PGP SIGNATURE-----

--nextPart1227885.z6XHLNEoeD--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
