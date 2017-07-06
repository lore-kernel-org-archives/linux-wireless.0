Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59724 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdGFOgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:36:54 -0400
Subject: Re: Command equivalent in iw
To: Emmanuel Grumbach <egrumbach@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <a496cdaa-41f3-53e1-bb4f-2843d5bd8b12@lwfinger.net>
 <CANUX_P3E9OASgfHykWsFjN1ii__sM=-8wWKr+6+rMk6GP2utvg@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <e98f1f21-d053-c5f0-5d17-8344cc5918ce@candelatech.com> (sfid-20170706_163709_754908_4489282C)
Date: Thu, 6 Jul 2017 07:36:52 -0700
MIME-Version: 1.0
In-Reply-To: <CANUX_P3E9OASgfHykWsFjN1ii__sM=-8wWKr+6+rMk6GP2utvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/06/2017 12:38 AM, Emmanuel Grumbach wrote:
> On Thu, Jul 6, 2017 at 5:51 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> Someone using the rtlwifi code that is posted at GitHub wants to know the iw equivalent of "iwpriv wlan0 bandcfg" to limit the wireless interface to 802.11b, 802.11g, or 802.11n. I only use simple iw commands, and I could not answer the question.
>
> This seems to be a private IOCTL and I can't find the code for that
> handler in the kernel today. Even in wireless extensions..
> I am not aware of something like this with iw today.
>
> In iwlwifi we have module parameter for this since this should really
> be used seldom.

I have some patches for wpa_supplicant and the wifi stack (and ath10k) that lets this work,
but it is fairly invasive, somewhat tricky to configure the supplicant properly,
and the kernel related patches were rejected some time back, so
it will only live in my trees for the foreseeable future.

If it is important to someone, they can find my kernels and hostapd and such here
and maybe google for past email from me about such things for hints:

https://github.com/greearb

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
