Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37814 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932333AbdCFOUB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 09:20:01 -0500
Subject: Re: cfg80211: add set/get link loss profile
To: Johannes Berg <johannes@sipsolutions.net>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
 <1480344742.8107.63.camel@sipsolutions.net>
 <58a1b983-6688-8b3e-81cb-83c62b46abbf@codeaurora.org>
 <1483353931.4596.3.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Message-ID: <ac1dc46d-25e3-f7a1-0d68-cc2f80515b5a@codeaurora.org> (sfid-20170306_152045_981742_A93975F2)
Date: Mon, 6 Mar 2017 15:54:14 +0200
MIME-Version: 1.0
In-Reply-To: <1483353931.4596.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/2/2017 12:45 PM, Johannes Berg wrote:
> On Mon, 2016-12-19 at 12:58 +0200, Lazar, Alexei Avshalom wrote:
> 
>>> What you're doing here is *extremely* vague. No definitions of what
>>> this means, no description of how it's intended to be implemented,
>>> no note even on whether or not this is for full-MAC chips or not,
>>> etc.
>>>
>>
>> The patch is intended for full-MAC chips and I will update the commit
>> message to include more details.
>>
>>> At least for mac80211, we can define signals to userspace regarding
>>> "link quality" and make decisions in wpa_s then?
>>>
>>
>> The policy is offloaded today to the FW and the decision being made
>> by the FW.
>> We are only modifying the behavior and not making the decision.
> 
> Fair enough, but I stand by saying that it's extremely vague - how
> could userspace possibly know what "level" to pick, if you don't give
> it any information about what the levels really mean?
> 
> johannes
> 

I have updated the commit message for clarifying what the levels really mean.

-- 
Alexei Lazar
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc. 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum a Linux Foundation Collaborative Project
