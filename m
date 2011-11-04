Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33578 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1KDTnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 15:43:25 -0400
Message-ID: <4EB44058.1040705@candelatech.com> (sfid-20111104_204330_099299_796FF05E)
Date: Fri, 04 Nov 2011 12:43:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: crash in wireless-next
References: <4EB42C0C.40101@candelatech.com>  (sfid-20111104_191656_642276_99C645ED)  <1320435146.3969.125.camel@jlt3.sipsolutions.net>  (sfid-20111104_203233_422852_33ADA66F) <1320435238.3969.126.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320435238.3969.126.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2011 12:33 PM, Johannes Berg wrote:
> On Fri, 2011-11-04 at 20:32 +0100, Johannes Berg wrote:
>> On Fri, 2011-11-04 at 11:16 -0700, Ben Greear wrote:
>>> Anyone seen a crash like this?  I was restarting my user-space
>>> tools, and had just unloaded the drivers that had,
>>> around 135 virtual stations created.  Just my disable-ht
>>> patch series applied on top of yesterday's wireless-testing.
>>>
>>> I'll dig into it more when I get a chance, but let me know
>>> if someone is already working on this...
>>
>> The only crash in wext I ever saw was recently with compat but I don't
>> think that looked similar.
>
> I guess you don't have CONFIG_COMPAT, but in that case I think so much
> gets inlined into wext_handle_ioctl() that I have no idea what could
> possibly crash. Disassembly of the place that crashed (preferably with
> -S if you have it) would be useful.

It might have been some issue with just copying over modules.  I installed
a full kernel and the crash went away..at least for a bit.  System crashed
while I was driving home, but serial console is at work..so will check it
later to see if it was the same issue.

I'll build w/debug and dis-assemble it if the problem persists.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
