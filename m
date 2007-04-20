Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:47552 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993013AbXDTNKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 09:10:47 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] rtl818x-mac80211: fix coding style
Date: Fri, 20 Apr 2007 09:07:08 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org
References: <20070420004258.23848470@localhost> <200704191923.31674.flamingice@sourmilk.net> <20070420090218.5a51d363@localhost>
In-Reply-To: <20070420090218.5a51d363@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1487771.4G4lCE1XyX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704200907.13916.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1487771.4G4lCE1XyX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 20 April 2007 03:02, Stefano Brivio wrote:
> On Thu, 19 Apr 2007 19:23:26 -0400
>
> Michael Wu <flamingice@sourmilk.net> wrote:
> > On Thursday 19 April 2007 18:42, Stefano Brivio wrote:
> > > Fix coding style.
> >
> > Looks mostly good except for..
> >
> > > -	// ehh?
> > > +	// XXX: ehh?
> >
> > Use FIXME if you want to put in a prefix.
>
> "XXX:" means we don't know if it's a FIXME, a TODO or just correct code.
> It's quite used. Unless this is a clear FIXME, I'd keep it.
>
Sure. But I don't use it in my drivers. Take it out if you don't like FIXME.

> > > -} __attribute__ ((packed));
> > > +} __attribute__((packed));
> >
> > I prefer the space here.
>
> Please see CodingStyle.
Fair enough.

Thanks,
-Michael Wu

--nextPart1487771.4G4lCE1XyX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGKLsBT3Oqt9AH4aERAvsmAJ4tj8Jh5zafiIrDGHNfZptzGBX96wCfRByD
D5nrDfvNHzD4b/9Y/vNjmMQ=
=YzDH
-----END PGP SIGNATURE-----

--nextPart1487771.4G4lCE1XyX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
