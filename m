Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56140 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3BUUqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 15:46:51 -0500
Message-ID: <512687B5.5050208@candelatech.com> (sfid-20130221_214656_571536_F76B0ECD)
Date: Thu, 21 Feb 2013 12:46:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] VHT capability override
References: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>  <5126797F.4030300@candelatech.com> <1361479008.8327.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361479008.8327.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2013 12:36 PM, Johannes Berg wrote:
> On Thu, 2013-02-21 at 11:46 -0800, Ben Greear wrote:
>> On 02/21/2013 11:11 AM, Johannes Berg wrote:
>>> I got a request to support this for testing. Anyone need other
>>> parameters? The multi-bit fields are a bit tricky so I didn't
>>> implement all of them yet.
>>
>> I haven't managed to acquire any VHT hardware yet (or look at features
>> in detail yet), but the option set looks good to me.
>
> How would you do the wpa_s code?

*Could* use lots of boolean options like I did last time for HT,
but perhaps something like vht_caps=0xdead would be better
(ie, all flags in one argument) to cut down on the amount of
code needed...

Maybe Jouni is the one to ask...

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

