Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49204 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043Ab1EXBPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 21:15:10 -0400
Received: by yia27 with SMTP id 27so2379741yia.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 18:15:09 -0700 (PDT)
Message-ID: <4DDB069A.9040804@lwfinger.net> (sfid-20110524_031518_798856_642DA512)
Date: Mon, 23 May 2011 20:15:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Greg KH <greg@kroah.com>, John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192c-common: rtl8192ce: Fix for HT40 regression
References: <4dce9c85.8lZEqlxFlQS542Cf%Larry.Finger@lwfinger.net> <BANLkTikWQki-_Ec3cjd8U8BNzbeBoh_jAw@mail.gmail.com>
In-Reply-To: <BANLkTikWQki-_Ec3cjd8U8BNzbeBoh_jAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2011 07:11 PM, Luis R. Rodriguez wrote:
> On Sat, May 14, 2011 at 8:15 AM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> The changes that were made to rtl8192ce when rtl8192cu was added broke
>> HT40. The errors included a typo in rtlwifi, a missing routine in
>> rtl8192ce and a missing callback of that routine in rtl8192c-common.
>>
>> This patch fixes the regression reported in Bug #35082.
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> I know this is very late, but was just discovered. If it does not make
>> 2.6.39, then it needs to be Cc'd to stable for .39.
>>
>> Thanks,
>>
>> Larry
>
> But in order to be applicable to 2.6.39 it required some slight
> modifications, namely only the first two hunks are applicable and the
> second hunk required a change. You can get my own version of the
> backport here, when it comes time to merge into 2.6.39.
>
> http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-wireless-2.6.git;a=commitdiff;h=3fdb69033149ca19791eb16c23be976f00f8daaa

Luis,

Thanks,

Larry
