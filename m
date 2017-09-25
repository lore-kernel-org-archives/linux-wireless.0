Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:56791 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933656AbdIYPj7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 11:39:59 -0400
Subject: Re: rtlwifi: rtl8821ae: Fix connection lost problem
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20170920211505.26171-1-Larry.Finger@lwfinger.net>
 <20170925080623.39A116099A@smtp.codeaurora.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <557cf4d5-22c2-444a-c970-797dc88cae16@lwfinger.net> (sfid-20170925_174027_222889_C570AADE)
Date: Mon, 25 Sep 2017 10:39:55 -0500
MIME-Version: 1.0
In-Reply-To: <20170925080623.39A116099A@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/25/2017 03:06 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> In commit 40b368af4b75 ("rtlwifi: Fix alignment issues"), the read
>> of REG_DBI_READ was changed from 16 to 8 bits. For unknown reasonsi
>> this change results in reduced stability for the wireless connection.
>> This regression was located using bisection.
>>
>> Fixes: 40b368af4b75 ("rtlwifi: Fix alignment issues")
>> Reported-and-tested-by: James Cameron <quozl@laptop.org>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org> # 4.11+
>> Cc: Ping-Ke Shih <pkshih@realtek.com>
> 
> Should I queue this for 4.14?
> 
> (The first commit was v4.11-rc1.)

Yes, please do.

Larry
