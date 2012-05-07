Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41618 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2EGOaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 10:30:05 -0400
Received: by yenm10 with SMTP id m10so3682897yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 07:30:05 -0700 (PDT)
Message-ID: <4FA7DC6A.8030600@lwfinger.net> (sfid-20120507_163012_284850_FB2F58D5)
Date: Mon, 07 May 2012 09:30:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING: at net/mac80211/iface.c:162
References: <4FA709B3.4030404@lwfinger.net>  (sfid-20120507_013135_141792_546F01AB) <1336372450.4325.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336372450.4325.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 01:34 AM, Johannes Berg wrote:
> On Sun, 2012-05-06 at 18:30 -0500, Larry Finger wrote:
>> Hi,
>>
>> I am getting the following warning from the latest wireless-testing system:
>>
>>    ------------[ cut here ]------------
>>    WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues+0x119/0x130
>> [mac80211]()
>
>
>>        if (WARN_ON_ONCE(sdata->vif.hw_queue[i]>= n_queues))
>>
>> The warning is triggered for i, n_queues, and sdata->vif.hw_queue[i] all equal to 1.
>
> Is this a driver with just a single queue by any chance? I never tested
> that and probably forgot to set those up correctly.

Yes, the device has only one hardware queue. Is this something the driver needs 
to do?

Larry

