Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:60021 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2IDRME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 13:12:04 -0400
Date: Tue, 4 Sep 2012 19:12:15 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Subject: Re: AR9330 hornet board stops beaconing after a few days
 (0xdeadbeef)
Message-ID: <20120904171215.GA5953@pandem0nium> (sfid-20120904_191209_882467_982997F2)
References: <20120813165340.GA10044@pandem0nium>
 <20120819220436.GA9899@pandem0nium>
 <CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
 <CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com>
 <20120902200102.GA28313@pandem0nium>
 <CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
In-Reply-To: <CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Shafi,

On Mon, Sep 03, 2012 at 07:23:26PM +0530, Mohammed Shafi wrote:
> seems we are getting beacon stuck, though its not sufficient for triggering
> chip reset (or) atleast start noise floor calibration. Is this is in a congested
> environment ? we can dump cycle counters . I think we need to have a
> WAR of chip reset if the cycle counters (busy is too high) inspite the MAC hang
> signature . let me try too to figure out that WAR is already available (or)
> we got to enable it.

I'm living at a small village, and one or two neighbors may have access points too,
but that's it - this should be far from beeing busy. We mostly use these APs for
surfing with smart phones, this is also far from congesting them. ;)

TBH I don't really understand what you are talking about regarding WAR, etc, can
you please explain? What can we do to analyse the problem better?

Thanks,
	Simon

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBGNm8ACgkQrzg/fFk7axbuNwCg626AvtDTWoeaSrVGjB92XN+7
5tEAnAjEXI04gSS102VwlSKQqBHEPFyG
=9pIv
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
