Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbeEaJHA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:07:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 31 May 2018 14:36:59 +0530
From: vnaralas@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Add cumulative channel survey dump support.
In-Reply-To: <1527069282.3759.16.camel@sipsolutions.net>
References: <1526980556-26707-1-git-send-email-vnaralas@codeaurora.org>
 <1527069282.3759.16.camel@sipsolutions.net>
Message-ID: <ebf1c95acb34649b3d2a5435142dc06a@codeaurora.org> (sfid-20180531_110732_070800_5B4F9B10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-23 15:24, Johannes Berg wrote:
> On Tue, 2018-05-22 at 14:45 +0530, Venkateswara Naralasetty wrote:
>> This patch provides support to send accumulated survey data to
>> user if low level drivers provides non-accumulated survey data.
> 
> I think the commit log should say what you need this for?
> 
> It's simultaneously a new flag, and a lot of code, but it's not clear
> what the point is?
> 
> johannes

I will sent next version of patch with updated commit log.

Providing you the earlier discussion of this patch to give quick 
overview about this patch.
https://patchwork.kernel.org/patch/9701459/


Thanks,
Venkatesh.
