Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33179 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbcC2IrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 04:47:08 -0400
Received: by mail-pf0-f172.google.com with SMTP id 4so9557611pfd.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 01:47:08 -0700 (PDT)
Subject: Re: [V11,2/2] brcmfmac: add support for nl80211 BSS_SELECT feature
To: Kalle Valo <kvalo@codeaurora.org>
References: <56F65580.4060403@broadcom.com>
 <87pouhcz3a.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56FA40FD.3040609@broadcom.com> (sfid-20160329_104732_581963_289FC502)
Date: Tue, 29 Mar 2016 10:46:53 +0200
MIME-Version: 1.0
In-Reply-To: <87pouhcz3a.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless, Johannes

On 26-3-2016 11:28, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> This brcmfmac patch [1] is set to "Awaiting Upstream" as it relies on
>> nl80211 patch. However, that patch was already in linux-next before the
>> merge window so are you waiting for 4.6-rc1 or did you miss this one?
>> Just want to understand the use of this state.
>>
>> Regards,
>> Arend
>>
>> [1] https://patchwork.kernel.org/patch/8484901/
> 
> Commit 0a87cadbb54e is not in net-next yet, I guess Johannes didn't send
> a pull request yet. Once it's in net-next it needs come down to
> wireless-drivers-next before I can apply it. So I'm waiting for that.

Ah. I figured the patch made it to the 4.6 deadline, but apparently not.

> But please do remind about this, I seldomly check the "Awaiting
> Upstream" queue so sometimes it might take way too long before I apply
> the patch.

So this is another way of saying the author should keep an eye on his
patches when it ends up in this state or in general ;-) Noted.

Thanks,
Arend
