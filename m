Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:64073 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1EDRUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 13:20:43 -0400
Message-ID: <4DC18AE5.4010708@lwfinger.net> (sfid-20110504_192122_923445_8F7C3A64)
Date: Wed, 04 May 2011 12:20:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: John W Linville <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn,
	Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net> <20110503150105.GC18648@gere.osrc.amd.com> <4DC05F9C.2070802@lwfinger.net> <20110504170131.GA12126@gere.osrc.amd.com>
In-Reply-To: <20110504170131.GA12126@gere.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2011 12:01 PM, Borislav Petkov wrote:
> On Tue, May 03, 2011 at 03:03:40PM -0500, Larry Finger wrote:
>> On 05/03/2011 10:01 AM, Borislav Petkov wrote:
>>> I think I have such a device in my Thinkpad:
>>>
>>> 03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
>>>
>>> I could give them a run soon. Do you have them in a tree somewhere I
>>> could pull?
>>
>> Your device is claimed by the new driver.
>>
>> You can get the code from
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/rtl8192se.git
>>
>> This tree is based on Linville's wireless-testing tree with these 12
>> patches applied.
>
> Ok, pulled, merged with mainline, built and currently using it to read
> mail over imap! I wish everything else in Linux worked that way :).
>
> Good job, thanks!

You are very welcome. I'm glad to hear that it works for you. That driver missed 
the 2.6.39 merge window due to an ASPM problem that crashed my computer without 
any possibility of seeing what caused the blowup. I was somewhat afraid that 
others would get similar results even though Realsil did not see the problem.

Larry
