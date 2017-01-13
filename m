Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35494 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752023AbdAMP5Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 10:57:24 -0500
Subject: Re: [PATCH] rtlwifi: rtl8192ee: New firmware from Realtek
To: Kyle McMartin <kyle@infradead.org>
References: <20161217185054.15017-1-Larry.Finger@lwfinger.net>
 <20170113150306.GE13400@bombadil.infradead.org>
Cc: linux-wireless@vger.kernel.org, Troy Tan <troy_tan@realsil.com.cn>,
        netdev@vger.kernel.org, linux-firmware@kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <38b9425e-0353-f13f-994b-1beaae41c1d6@lwfinger.net> (sfid-20170113_165731_011315_179763B2)
Date: Fri, 13 Jan 2017 09:57:21 -0600
MIME-Version: 1.0
In-Reply-To: <20170113150306.GE13400@bombadil.infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2017 09:03 AM, Kyle McMartin wrote:
> On Sat, Dec 17, 2016 at 12:50:54PM -0600, Larry Finger wrote:
>> -Info: Taken from Realtek version rtl_92ce_92se_92de_8723ae_88ee_8723be_92ee_linux_mac80211_0017.1224.2013
>> +Info: Initial version taken from Realtek version
>> +      rtl_92ce_92se_92de_8723ae_88ee_8723be_92ee_linux_mac80211_0017.1224.2013
>> +      Updated Jan. 14, 2015 with file added by Realtek to
>> +      http://github.com/lwfinger/rtlwifi_new.git.
>>  File: rtlwifi/rtl8192eefw.bin
>>
>
> Uh, did something weird happen here? This patch was applied in 2015. ;-)
>
> cheers, Kyle

Realtek fixed some bugs in the firmware. This is a new version.

Larry
