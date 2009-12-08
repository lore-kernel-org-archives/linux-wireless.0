Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f197.google.com ([209.85.212.197]:41200 "EHLO
	mail-vw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935282AbZLHEZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 23:25:40 -0500
Received: by vws35 with SMTP id 35so2300560vws.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 20:25:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260169635.13866.3.camel@johannes.local>
References: <d9360e520912062221o1f543bc9tbe3813113562a25d@mail.gmail.com>
	 <1260169635.13866.3.camel@johannes.local>
Date: Tue, 8 Dec 2009 09:55:45 +0530
Message-ID: <d9360e520912072025y6dc1d0a1yf36e39cd643a89b3@mail.gmail.com>
Subject: Re: ssid
From: Bharat Bhushan <bharat.b.bhushan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thank you sir ,i will discuss this with my colleagues here and will
send accross patch.

bharat

On Mon, Dec 7, 2009 at 12:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
> This change happened because no driver required the SSID, and many
> drivers were using it incorrectly. I'd be happy to add it back for an
> in-kernel driver where I can see that it is needed, but _very_ reluctant
> to do it for a driver I've never seen. So please add it back in a patch
> that you use for development, finish your driver, and then when it comes
> time to post your driver upstream you can also post the relevant
> mac80211 patch. Oh also please don't develop against 2.6.29, it is
> _ancient_.
>
> johannes
>
> On Mon, 2009-12-07 at 11:51 +0530, Bharat Bhushan wrote:
>> hello gentlemen,
>>
>>                          i am trying to implement an open source mac
>> base driver with kernel base version 2.6.29, for association
>> completion my hardware requires an api with ssid to be sent. but i
>> could not find any api from mac80211.h which contain ssid element
>> except hw_scan which i cannot use as ssid should be sent before
>> association ,few days back i implement the same driver with kernel
>> version 2.6.27 and i use to get ssid in ieee80211_if_conf structure in
>> config_interface api but now this is deprecated , any particular
>> reason why this change happen, is there any other way i can get ssid
>> through any interface.
>>
>>
>>
>> Any help is much appreciated.
>>
>>
>> Thanks
>>
>> bharat
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
