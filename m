Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62768 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2IEOIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 10:08:47 -0400
Received: by pbbrr13 with SMTP id rr13so986449pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 07:08:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn1=q_YCXjQOLyc+KeG6Bji=7b_VHN4PDA7poXk5Kkdi6Q@mail.gmail.com>
References: <20120813165340.GA10044@pandem0nium>
	<20120819220436.GA9899@pandem0nium>
	<CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
	<CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com>
	<20120902200102.GA28313@pandem0nium>
	<CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com>
	<20120904171215.GA5953@pandem0nium>
	<CAD2nsn1=q_YCXjQOLyc+KeG6Bji=7b_VHN4PDA7poXk5Kkdi6Q@mail.gmail.com>
Date: Wed, 5 Sep 2012 07:08:47 -0700
Message-ID: <CAJ-VmonwheNtv8xfEJnWpD-XOmSEebMFJAmQmWUfe2Pd3tMnqA@mail.gmail.com> (sfid-20120905_160851_856088_A56914F8)
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
From: Adrian Chadd <adrian.chadd@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't think it's a stuck beacon WAR issue here; 0xdeadbeef really
does read like the MAC has gone to sleep.

Where's the complete register dump hiding?



Adrian


On 4 September 2012 22:12, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> Hi Simon/Sven,
>
>>
>> I'm living at a small village, and one or two neighbors may have access points too,
>> but that's it - this should be far from beeing busy. We mostly use these APs for
>> surfing with smart phones, this is also far from congesting them. ;)
>>
>> TBH I don't really understand what you are talking about regarding WAR, etc, can
>> you please explain? What can we do to analyse the problem better?
>
>
> work arounds(WAR) for beacon stuck in congested environment,
> there may be quite a few that may not be not yet ported for ath9k,
> but as your environment is not a congested, then the issue can be
> something different. Have not got much information/change list
> from the query posted internally.
>
>>
>> Thanks,
>>         Simon
>>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.10 (GNU/Linux)
>>
>> iEYEARECAAYFAlBGNm8ACgkQrzg/fFk7axbuNwCg626AvtDTWoeaSrVGjB92XN+7
>> 5tEAnAjEXI04gSS102VwlSKQqBHEPFyG
>> =9pIv
>> -----END PGP SIGNATURE-----
>>
>
>
>
> --
> thanks,
> shafi
