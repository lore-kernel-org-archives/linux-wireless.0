Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2AaRaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 12:30:17 -0500
Received: by pbdu11 with SMTP id u11so339515pbd.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 09:30:16 -0800 (PST)
Message-ID: <4F282525.2050305@canonical.com> (sfid-20120131_183021_854058_7614B750)
Date: Tue, 31 Jan 2012 10:30:13 -0700
From: Tim Gardner <rtg.canonical@gmail.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Tim Gardner <rtg.canonical@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] rtlwifi: Convert to asynchronous firmware load
References: <4f272b8e.6jAMcI3HDthxlb+q%Larry.Finger@lwfinger.net> <4F280689.1080402@canonical.com> <4F2818F5.6000802@lwfinger.net>
In-Reply-To: <4F2818F5.6000802@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2012 09:38 AM, Larry Finger wrote:
> On 01/31/2012 09:19 AM, Tim Gardner wrote:
>>
>>
>> d88e0b3162bded8190866d9a17f5e36c9bb0d29e in wireless-testing (which
>> includes
>> 'rtlwifi: Convert to asynchronous firmware load') is working well on my
>> RTL8188CE [10ec:8176].
>
> Thanks for the feedback. Note: The patch was merged before V3 was
> available, thus you will also need the "rtlwifi: Remove extra debugging
> message accidentally left in" patch that I just sent to John.
>
> Larry
>

I didn't notice any spamming in the logs, but then I didn't really abuse 
it much. I mostly ran through a few boot and suspend/resume cycles to 
make sure firmware was loading.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
