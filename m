Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35094 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755588AbdIGTzZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Sep 2017 15:55:25 -0400
Received: by mail-wm0-f54.google.com with SMTP id f199so4814618wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Sep 2017 12:55:24 -0700 (PDT)
Subject: Re: using vulnerability ids in patches
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <7415a11b-398c-69df-b39f-7b985f07112b@broadcom.com>
 <87bmmmn0ur.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <73fcc6e2-23d2-32f5-1c1a-1cf18893b477@broadcom.com> (sfid-20170907_215537_059380_0A067450)
Date: Thu, 7 Sep 2017 21:55:21 +0200
MIME-Version: 1.0
In-Reply-To: <87bmmmn0ur.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07-09-17 14:34, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> Due to recent events we were asked about some vulnerability fixes for
>> brcmfmac. We already fixed a couple of things without referring to a
>> so-called CVE-ID, which is what people are asking for. Do we have a
>> upstream policy on that? I could not really find anything in the
>> Documentation folder (but I may have overlooked it). Might be worth
>> mentioning in the commit message like with the coverity ids.
> 
> Johannes already answered, but I'll just add that this is all I know
> about security patches:
> 
>    If you have a patch that fixes an exploitable security bug, send that
>    patch to security@kernel.org. For severe bugs, a short embargo may be
>    considered to allow distributors to get the patch out to users; in
>    such cases, obviously, the patch should not be sent to any public
>    lists.
> 
>    https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> 
> I don't know if you should follow that in this case or not, just wanted
> to point out this.

I see. I thought security@kernel.org was just to report exploitable 
security bugs. Thanks for the pointer.

Regards,
Arend
