Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35126 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbbINRuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 13:50:16 -0400
Received: by ykdu9 with SMTP id u9so161240067ykd.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 10:50:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1442218015.2075.0.camel@sipsolutions.net>
References: <CAB6w8ekO7YW224ujkEH34D-qyvoHe3p6bWwZcBTd_tovRMraxw@mail.gmail.com>
 <1442218015.2075.0.camel@sipsolutions.net>
From: Ramprasad Vempati <ramprasad.vempati@gmail.com>
Date: Mon, 14 Sep 2015 23:19:56 +0530
Message-ID: <CAB6w8ekP96__u4m-rqV-LUJE2irBew+3OS2TpfdvuUQsz=ohqQ@mail.gmail.com> (sfid-20150914_195044_641624_7E327345)
Subject: Re: How to use hwsim?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Johannes. But can I use hwsim tests under wpa_supplicant with
actual hardware as well ?  If yes, is there some README for me to
understand it better and start using it?

-ram

On Mon, Sep 14, 2015 at 1:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-09-13 at 22:38 +0530, Ramprasad Vempati wrote:
>> Hi,
>>
>> I've got hwsim source code from:
>> http://git.sipsolutions.net/hwsim.git. I could compile it.
>>
>>  And I see binary-hwsim is created after compilation.
>>
>> But there isn't any help on how do I use this. Can someone help me
>> with these details?
>>
>
> This tool is practically irrelevant.
>
> Look at the hwsim tests in wpa_supplicant instead.
>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
