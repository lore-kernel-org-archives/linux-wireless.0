Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:36234 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945934AbbEOUtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 16:49:09 -0400
Received: by qkgw4 with SMTP id w4so38185385qkg.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 13:49:08 -0700 (PDT)
Message-ID: <55565B79.9050203@gmail.com> (sfid-20150515_224919_464035_D96EDFD2)
Date: Fri, 15 May 2015 17:47:53 -0300
From: Gaston Gonzalez <gascoar@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org, arnd@arndb.de,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	joe@perches.com, navyasri.tech@gmail.com, julian.calaby@gmail.com
Subject: Re: [PATCH] staging: rtl8192u: ieee80211: Silence sparse warning
References: <1429476231-6197-1-git-send-email-gascoar@gmail.com>		 <20150420082441.GU10964@mwanda> <553C18B6.807@gmail.com>		 <20150427101242.GR14154@mwanda> <554AD76E.7060605@gmail.com>		 <20150508110328.GT14154@mwanda> <55527D6E.7090207@gmail.com>		 <20150513083615.GS14154@mwanda> <5553F48E.3050008@gmail.com>		 (sfid-20150514_030522_036209_6D0AE5EB) <1431632112.2237.5.camel@sipsolutions.net>	 <55551BC7.10702@gmail.com> (sfid-20150515_000453_619487_AB572AE6) <1431674762.2426.3.camel@sipsolutions.net>
In-Reply-To: <1431674762.2426.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/05/15 04:26, Johannes Berg wrote:
> On Thu, 2015-05-14 at 19:03 -0300, Gaston Gonzalez wrote:
>
>> If Dan is a newbie to this, I would be a pre-under-newbie or something
>> below that. That being said, understood your explication, I'll look for
>> another way to deal with this warning.
> I don't even see your original patch, so I have no idea what you're
> trying to do :)
>
> johannes
>
The original patch started as sparse warning fix:

http://thread.gmane.org/gmane.linux.drivers.driver-project.devel/67254

regards,

Gaston
