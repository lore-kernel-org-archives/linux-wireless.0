Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51884 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1IUOjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 10:39:51 -0400
Received: by gyg10 with SMTP id 10so1178054gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 07:39:51 -0700 (PDT)
Message-ID: <4E79F733.1040907@lwfinger.net> (sfid-20110921_163957_694298_5F2BA5A2)
Date: Wed, 21 Sep 2011 09:39:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch
 #2
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com> <20110920130338.GA9885@kroah.com> <1316524874.3953.41.camel@jlt3.sipsolutions.net> <CACna6rxxoRoLi9C3RBsot8kvZx4k5AZVHzHoE17q-iT1U7i5qg@mail.gmail.com> <20110921134056.GB2828@tuxdriver.com> <CACna6rzOsbi0ghDUa1ruNq4uefEWmwdU7KUDRrh6r0927Jm9oQ@mail.gmail.com> <CACna6rwiWp+eEv+K+zm0VBFC6h4GHnMYrx2g8nk-vaBNpFbMyQ@mail.gmail.com>
In-Reply-To: <CACna6rwiWp+eEv+K+zm0VBFC6h4GHnMYrx2g8nk-vaBNpFbMyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 08:55 AM, Rafał Miłecki wrote:
> W dniu 21 września 2011 15:52 użytkownik Rafał Miłecki
> <zajec5@gmail.com>  napisał:
>> W dniu 21 września 2011 15:40 użytkownik John W. Linville
>> <linville@tuxdriver.com>  napisał:
>>>
>>> Their new firmware doesn't run on the older hardware, no?
>>
>> AFAIK it does (unless you mean hardware covered by b43legacy).
>>
>> If you take a look at 666.2 firmware, it's still available for core 5
>> (and 9, 13, etc.)
>
> The reason I've added support for new firmware without dropping
> support for older, was users experience. I didn't want to leave anyone
> with b43 not working after kernel update (without firmware update).

That is the correct thing to do. As I see it, this firmware change is a lot less 
intrusive than the changes that led to the b43/b43legacy split, where keeping 
the old version working took a lot of bookkeeping.

Perhaps in 2 or 3 years, we might want to deprecate the older firmware and force 
users to go to the newest style, but there is no rush.

Larry


