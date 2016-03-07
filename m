Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34126 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbcCGTqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 14:46:42 -0500
Received: by mail-yk0-f171.google.com with SMTP id x17so18124449ykd.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2016 11:46:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87a8matpqj.fsf@kamboji.qca.qualcomm.com>
References: <1456947439-28968-1-git-send-email-arend@broadcom.com>
	<1456947439-28968-2-git-send-email-arend@broadcom.com>
	<87a8matpqj.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 7 Mar 2016 20:46:35 +0100
Message-ID: <CAF7Mx6rxKtnt7hv1pm3M6Cy-p0mPRMKVb+-Qh3m1R94=baB6Cg@mail.gmail.com> (sfid-20160307_204834_374569_95A2E96B)
Subject: Re: [PATCH V11 2/2] brcmfmac: add support for nl80211 BSS_SELECT feature
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 7, 2016 at 1:52 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> Announce support for nl80211 feature BSS_SELECT and process
>> BSS selection behaviour provided in .connect() callback.
>>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Lei Zhang <leizh@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> Depends on:
>
> 0a87cadbb54e nl80211: add feature for BSS selection support
>
> Is in mac80211-next currently.

Yes.

$ git log --oneline mac80211-next/master -1 -- include/uapi/linux/nl80211.h
0a87cad nl80211: add feature for BSS selection support

Regards,
Arend

> --
> Kalle Valo
