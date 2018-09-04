Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40432 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbeIDVeo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 17:34:44 -0400
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Add rtl8188ctv support
To: Aleksei Mamlin <mamlinav@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180830140541.31964-1-mamlinav@gmail.com>
 <20180904081619.7353B606AC@smtp.codeaurora.org>
 <53022e37-e9dc-1cf8-ec3c-4df668f3c045@gmail.com>
 <20180904192338.e9be91d4be447e33acefed5a@gmail.com>
Message-ID: <3be649f2-3f55-c11c-f31e-02ba68ed4103@gmail.com> (sfid-20180904_190906_535104_097D7982)
Date: Tue, 4 Sep 2018 13:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <20180904192338.e9be91d4be447e33acefed5a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/04/2018 12:23 PM, Aleksei Mamlin wrote:
> On Tue, 4 Sep 2018 11:36:50 -0400
> Jes Sorensen <jes.sorensen@gmail.com> wrote:
> 
>> On 09/04/2018 04:16 AM, Kalle Valo wrote:
>>> Aleksei Mamlin <mamlinav@gmail.com> wrote:
>>>
>>>> The Realtek rtl8188ctv (0x0bda:0x018a) is a highly integrated single-chip
>>>> WLAN USB2.0 network interface controller.
>>>>
>>>> Currently rtl8188ctv is supported by rtlwifi driver.
>>>> It is similar to the rtl8188cus(0x0bda:0x818a) and uses the same config.
>>>>
>>>> Signed-off-by: Aleksei Mamlin <mamlinav@gmail.com>
>>>
>>> Patch applied to wireless-drivers-next.git, thanks.
>>>
>>> 514502c3a70b rtl8xxxu: Add rtl8188ctv support
>>
>> Looks good to me too - assume it's been tested?
>>
> 
> Yes, tested on my ARM tablet. It successfully connected to my home router
> using wpa_supplicant. There is dmesg output:

Awesome, glad to hear it's working!

Jes
