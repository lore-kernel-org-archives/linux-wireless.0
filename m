Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:47915 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbdJQORs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 10:17:48 -0400
Received: by mail-oi0-f43.google.com with SMTP id h200so3165810oib.4
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2017 07:17:48 -0700 (PDT)
Subject: Re: Help with bug "Black screen freeze on suspend to ram (rtl8188ee)"
To: Lauro Costa <lauro@polilinux.com.br>
References: <03101f6d-5160-a3cf-3507-4d79a59cccea@polilinux.com.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <1a350c13-777a-b283-aefd-3c899883edf1@lwfinger.net> (sfid-20171017_161752_501425_AE89171F)
Date: Tue, 17 Oct 2017 09:17:46 -0500
MIME-Version: 1.0
In-Reply-To: <03101f6d-5160-a3cf-3507-4d79a59cccea@polilinux.com.br>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/2017 09:03 AM, Lauro Costa wrote:
> Dear maintainer,
> 
> I have opened a bug report on bugzilla [1] regarding this issue I find when I 
> attempt to suspend to ram, unfortunately no one has replied to me yet.
> 
> I assumed this issue is related to the driver rtl8188ee since the black screen 
> doesn't happen when I rmmod the wifi driver, but I'm not sure what I have is 
> enough to assume this.
> 
> Do you know if this driver rtl8188ee is supposed to support suspend to ram?
> 
> This system log message:
> 
> |(NULL device *): firmware: direct-loading firmware rtlwifi/rtl8188efw.bin|
> 
> is something I haven't seen before, I don't understand why it says (NULL device 
> *). Could it mean there is something else wrong and the rtl driver crashes as a 
> result of that?
> 
> I'm not sure how to further investigate this issue, so any advice you could give 
> here or in the bug report would be much appreciated.

Sorry that I missed that bug report. Unfortunately, without the traceback from 
the occurrence of the bug, it will be very difficult to find the problem.

If you add a script to unload the module when the machine hibernates or 
suspends, and reloads it on startup, you should be able to avoid the lockups.

I will try to duplicate the problem here.

Larry
