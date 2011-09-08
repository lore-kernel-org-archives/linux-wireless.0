Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:55031 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758010Ab1IHGbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 02:31:10 -0400
Received: by mail-yx0-f172.google.com with SMTP id 20so361968yxj.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 23:31:09 -0700 (PDT)
Message-ID: <4E686125.5050208@ti.com> (sfid-20110908_083114_642312_00913C2B)
Date: Thu, 08 Sep 2011 09:31:01 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>  <1315224151-16552-4-git-send-email-VictorG@ti.com>  <1315224512.4075.10.camel@jlt3.sipsolutions.net>  <4E6736D9.3070804@ti.com> <1315387619.4002.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1315387619.4002.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2011 12:26, Johannes Berg wrote:
>> The intermediate scan event is not HW dependent, so there is no need to
>> advertise it..
>
> Not with mac80211 drivers, but with cfg80211 drivers?
>
> johannes
>

You're right, cfg80211 drivers will not support it. As I couldn't find a 
way to know whether it mac or cfg based driver, I can add also 
IEEE80211_HW_SUPPORTS_IM_RESULT" flag (as with cancel_scan) and then 
will advertise the nl80211 command if it set, is it OK?

Thanks,
Victor.
