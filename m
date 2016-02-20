Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34488 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbcBTOHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2016 09:07:02 -0500
Received: by mail-oi0-f53.google.com with SMTP id m82so29955499oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Feb 2016 06:07:02 -0800 (PST)
Subject: Re: [PATCH] rtlwifi: Change long delays to sleeps
To: ByeoungWook Kim <quddnr145@gmail.com>
References: <1455574327-2591-1-git-send-email-Larry.Finger@lwfinger.net>
 <CAOxTRzpvnQdb8Wf4M=y4eBM+X-Ey0Y4u=o9X_MMyzTkWQpS=TQ@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56C87303.6070203@lwfinger.net> (sfid-20160220_150716_170454_E4F80B3E)
Date: Sat, 20 Feb 2016 08:06:59 -0600
MIME-Version: 1.0
In-Reply-To: <CAOxTRzpvnQdb8Wf4M=y4eBM+X-Ey0Y4u=o9X_MMyzTkWQpS=TQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2016 11:48 PM, ByeoungWook Kim wrote:
> 2016-02-16 7:12 GMT+09:00 Larry Finger <Larry.Finger@lwfinger.net>:
>> Routine rtl_addr_delay() uses delay statements in code that can
>> sleep. To improve system responsiveness, the various delay statements
>> are changed.
>>
>> In addition, routines rtl_rfreg_delay() and rtl_bb_delay() are
>> rewritten to use the code in rtl_addr_delay() for most of their
>> input values.
>>
>> Suggested-by: Byeoungwook Kim <quddnr145@gmail.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>
> Why you are using 'Suggested-by:' of me?
> I think to that your commit was included a part of my
> commit(https://patchwork.kernel.org/patch/8197071/).

Your commit was placed in the deferred list of patches. It did lead me to look 
at that section and realize that using delays there was a bug, and that it 
should be fixed as quickly as possible. That argues against waiting for your 
patches to be implemented. I did use some of your changes. How do you think I 
should have referenced your material?

Larry


