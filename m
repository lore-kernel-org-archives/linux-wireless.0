Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:40946 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbBLSzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 13:55:24 -0500
Received: by mail-oi0-f41.google.com with SMTP id z81so4880245oif.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2015 10:55:24 -0800 (PST)
Message-ID: <54DCF71A.8030207@lwfinger.net> (sfid-20150212_195527_560409_C4C4FD25)
Date: Thu, 12 Feb 2015 12:55:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?Sm9oYW5uZXMgTMO2dGhiZXJn?= <johannes@kyriasis.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce kernel panics since 3.17(?)
References: <20150212121057.GA1804@leeloo.kyriasis.com> <54DCD708.3070402@lwfinger.net> <20150212172753.GA17043@leeloo.kyriasis.com>
In-Reply-To: <20150212172753.GA17043@leeloo.kyriasis.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2015 11:27 AM, Johannes Löthberg wrote:
> On 12/02, Larry Finger wrote:
>> On 02/12/2015 06:10 AM, Johannes Löthberg wrote:
>>> Since sometime around version 3.16 or 3.17 I've been getting a lot of occasional
>>> kernel panics related to my wifi driver. My laptop has a Realtek RTL8188CE
>>> wireless card and uses the rtl8192ce driver.
>>>
>>> I have pictures of what I think is two identical kernel panics, a couple of days
>>> apart:
>>>
>>> https://lh4.googleusercontent.com/yjwOnrDmioCwuC8FqIXlKMiBTOXddLyJkWTiInJoX2o=w421-h569-no
>>>
>>>
>>> https://lh3.googleusercontent.com/-xM-1wSsVu4c/VKxDnlkgBbI/AAAAAAAAIng/HxtqgHgglHY/w421-h569-no/IMG_20150106_212020.jpg
>>>
>>>
>>>
>>> It only seems to happen when I have several days of uptime on my laptop and just
>>> use sleep all the time instead of shutting it down.
>>>
>>> Also I have a picture of a kernel panic that is different from the previous
>>> ones:
>>>
>>> https://lh3.googleusercontent.com/-Hj06Csglpa0/VKrI1al6QbI/AAAAAAAAImk/VzhmN-dfSB0/w657-h486-no/IMG_20150105_182236.jpg
>>>
>>>
>>>
>>> Not sure how to debug it really, but figured that sending in a report would be
>>> worth a shot.
>>>
>>
>> What kernel were you running when you made the photos? Use the command 'uname
>> -r'. When I get that information, I can then use the dump trace to determine
>> the locations of the oops.
>>
>> Larry
>>
>>
>
> For the first photo it was 3.18.3 and for the second one it seems like it should
> be 3.18.1 from looking at my package manager's log.

OK, that makes more sense than your original report of problems starting with 
3.16 or 3.17. That bug was fixed in 3.18.4.

Larry


