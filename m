Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45215 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab2IEFMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 01:12:18 -0400
Received: by ieje11 with SMTP id e11so283544iej.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 22:12:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120904171215.GA5953@pandem0nium>
References: <20120813165340.GA10044@pandem0nium>
	<20120819220436.GA9899@pandem0nium>
	<CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
	<CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com>
	<20120902200102.GA28313@pandem0nium>
	<CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com>
	<20120904171215.GA5953@pandem0nium>
Date: Wed, 5 Sep 2012 10:42:17 +0530
Message-ID: <CAD2nsn1=q_YCXjQOLyc+KeG6Bji=7b_VHN4PDA7poXk5Kkdi6Q@mail.gmail.com> (sfid-20120905_071230_628700_224E859A)
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon/Sven,

>
> I'm living at a small village, and one or two neighbors may have access points too,
> but that's it - this should be far from beeing busy. We mostly use these APs for
> surfing with smart phones, this is also far from congesting them. ;)
>
> TBH I don't really understand what you are talking about regarding WAR, etc, can
> you please explain? What can we do to analyse the problem better?


work arounds(WAR) for beacon stuck in congested environment,
there may be quite a few that may not be not yet ported for ath9k,
but as your environment is not a congested, then the issue can be
something different. Have not got much information/change list
from the query posted internally.

>
> Thanks,
>         Simon
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAlBGNm8ACgkQrzg/fFk7axbuNwCg626AvtDTWoeaSrVGjB92XN+7
> 5tEAnAjEXI04gSS102VwlSKQqBHEPFyG
> =9pIv
> -----END PGP SIGNATURE-----
>



-- 
thanks,
shafi
