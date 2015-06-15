Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35549 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbbFOPu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 11:50:28 -0400
Received: by oiax193 with SMTP id x193so4078631oia.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 08:50:27 -0700 (PDT)
Message-ID: <557EF43F.4030309@lwfinger.net> (sfid-20150615_175032_043595_D65793E4)
Date: Mon, 15 Jun 2015 10:50:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>, Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [V2] rtlwifi: rtl8192c: Add init codes for "fw_version" and"fw_subversion".
References: <20150615093851.5F08714086F@smtp.codeaurora.org> <87lhfl9mj4.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lhfl9mj4.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2015 07:35 AM, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
>
>>> The variable "fw_version" is used in the _ResetDigitalProcedure1().
>>> but It is not initialized. so I add init codes for "fw_version" and
>>> "fw_subversion".
>>>
>>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>>
>> Thanks, applied to wireless-drivers-next.git.
>
> This patch adds a new sparse warning. Please send a new patch to fix
> this.
>
>>> drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36: sparse: incorrect type in assignment (different base types)
>     drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    expected unsigned short [unsigned] [usertype] fw_version
>     drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c:242:36:    got restricted __le16 [usertype] version

Sorry, I missed that when I reviewed the patch.

Larry


