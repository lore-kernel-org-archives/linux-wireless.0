Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57670 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1EDULg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 16:11:36 -0400
Received: by pvg12 with SMTP id 12so652540pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 13:11:35 -0700 (PDT)
Message-ID: <4DC1B2F3.3070300@lwfinger.net> (sfid-20110504_221139_176709_C7720780)
Date: Wed, 04 May 2011 15:11:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARNING from mac80211
References: <4DC1AF49.7080204@lwfinger.net>	 (sfid-20110504_215621_111957_531CD5AD) <1304539363.3563.28.camel@jlt3.sipsolutions.net>
In-Reply-To: <1304539363.3563.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2011 03:02 PM, Johannes Berg wrote:
> On Wed, 2011-05-04 at 14:55 -0500, Larry Finger wrote:
>> Johannes and John,
>>
>> A regression in recent versions of mac80211 are generating the WARNING at
>> net/mac80211/wep.c:101, because the skb headroom is less than WEP_IV_LEN or the
>> tailroom is less than WEP_ICV_LEN. My testing indicates that it is a headroom
>> problem as the following hack "fixes" it:
>
> See also this thread:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/69062/focus=69150
>
> and the resulting patch:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/69190
> (not sure why it was RFC?)

Thanks. I do remember the thread now that you refreshed my memory. That patch 
does fix my problem.

Larry
