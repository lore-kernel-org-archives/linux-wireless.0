Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve1eur01on0085.outbound.protection.outlook.com ([104.47.1.85]:58265
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752460AbeEGUE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 16:04:27 -0400
Subject: Re: [PATCH] mesh: don't process mesh channel switch unless csa ie
 provided
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1524857196-29399-1-git-send-email-peter.oh@bowerswilkins.com>
 <1525722286.22388.5.camel@sipsolutions.net>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <81cf6620-d7f6-50f7-23c5-e1ba693f2907@bowerswilkins.com> (sfid-20180507_220432_266777_461E2353)
Date: Mon, 7 May 2018 13:04:13 -0700
MIME-Version: 1.0
In-Reply-To: <1525722286.22388.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/07/2018 12:44 PM, Johannes Berg wrote:
> On Fri, 2018-04-27 at 12:26 -0700, peter.oh@bowerswilkins.com wrote:
>> From: Peter Oh <peter.oh@bowerswilkins.com>
>>
>> There is no meaning to call ieee80211_mesh_process_chnswitch
>> without CSA IE provided, since the function will always return error.
> I'm not convinced, an extended channel switch element might be present
> instead?
I expected the comment. Yes, extended channel switch element could be 
present instead of channel switch element which I missed to take care 
of. So you can ignore the patch for now and I'll get back with right 
patch for it.

Thanks,
Peter
