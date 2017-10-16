Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdJPNDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 09:03:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Pkshih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
        <20171011131310.GF32250@kroah.com>
        <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
        <20171012103450.GA24647@kroah.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
        <20171016074516.4irgvbid6p5zwqjg@mwanda>
Date: Mon, 16 Oct 2017 16:03:02 +0300
In-Reply-To: <20171016074516.4irgvbid6p5zwqjg@mwanda> (Dan Carpenter's message
        of "Mon, 16 Oct 2017 10:45:16 +0300")
Message-ID: <87k1zvmeih.fsf@kamboji.qca.qualcomm.com> (sfid-20171016_150312_057319_9EFE724A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Mon, Oct 16, 2017 at 02:41:38AM +0000, Pkshih wrote:
>> 2) The rtlwifi in staging
>>    In staging, the module phydm v13 contains bugs, so I want to upgrade
>>    to v21 (Realtek internal version number). This upgrade contains a
>>    big patch that the difference between v13 and v21, and there are 
>>    40+ patches to support this upgrade. I have three options, and
>>    I want to know which one is prefer.
>
> We can't discuss patches we haven't seend.  Please just send them right
> away without any delay to both lists, and we can decide from there.
>
> 40 patches is a medium size set, patch that we are used to dealing with
> every day.

I review every patch I commit and 40 patches is just pure pain to dig
through. So when submitting patches to me please keep the size more
reasonable, like 10-12 patches per set. I think Dave also has a similar
rule for net patches.

I wrote a FAQ entry about this:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#too_many_patches

-- 
Kalle Valo
