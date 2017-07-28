Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdG1PUo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:20:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [v4,01/10] rtlwifi: Fill in_4way field by driver
References: <20170702181239.17911-2-Larry.Finger@lwfinger.net>
        <20170728151744.962376074A@smtp.codeaurora.org>
Date: Fri, 28 Jul 2017 18:20:39 +0300
In-Reply-To: <20170728151744.962376074A@smtp.codeaurora.org> (Kalle Valo's
        message of "Fri, 28 Jul 2017 15:17:44 +0000 (UTC)")
Message-ID: <87eft0wptk.fsf@purkki.adurom.net> (sfid-20170728_172048_725478_D15BF944)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> From: Ping-Ke Shih <pkshih@realtek.com>
>> 
>> Because it isn't always correct to use EAPOL to check 4-way,
>> we add a timer to handle exception.
>> 
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Cc: Birming Chiu <birming@realtek.com>
>> Cc: Shaofu <shaofu@realtek.com>
>> Cc: Steven Ting <steventing@realtek.com>
>
> 8 patches applied to wireless-drivers-next.git, thanks.
>
> 11f35c950466 rtlwifi: Fill in_4way field by driver
> 6aad6075ccd5 rtlwifi: Add BT_MP_INFO to c2h handler.
> 881d53ab1f43 rtlwifi: Add board type for 8723be and 8192ee
> ca0e657bda7e rtlwifi: add amplifier type for 8812ae
> 66970e38e544 rtlwifi: Update 8723be new phy parameters and its parser.
> 6ec9dfbc057c rtlwifi: Rename rtl_desc92_rate to rtl_desc_rate
> e7c528615e34 rtlwifi: Uses addr1 instead DA to determine broadcast and multicast addr.
> 58438d9ae172 rtlwifi: move IS_HARDWARE_TYPE_xxx checker to wifi.h

As you can see I applied the first 8 patches anyway because the backlog
of rtlwifi patches is quite long, I had over 40 pending patches in
patchwork. But please submit followup patches for the commented issues.

Of course the use of global variables is not urgent as it has been there
for years but that should be fixed eventually.

-- 
Kalle Valo
