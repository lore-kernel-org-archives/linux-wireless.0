Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.a.out.hosting.netstream.com ([62.65.159.6]:43712 "EHLO
        mx01.a.out.hosting.netstream.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932650AbdC3H6f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 03:58:35 -0400
From: Etan Kissling <kissling@oberon.ch>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: Tao Peng <pengtao@me.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>
Subject: Re: Adding a vendor Information Element to beacon / probe response
 frames
Date: Thu, 30 Mar 2017 07:48:37 +0000
Message-ID: <25775946-B2A1-4081-892B-135FE549D864@oberon.ch> (sfid-20170330_095839_000591_346E7054)
References: <86F2B872-9405-4264-8C9A-3765DFE4866F@me.com>,<9c6951e7-22b8-d890-f3cf-ba846e523b3b@broadcom.com>
In-Reply-To: <9c6951e7-22b8-d890-f3cf-ba846e523b3b@broadcom.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If it's on the Raspberry Pi, you'll need to use 4.10 as the patch has not been backported. You can also use the stock kernel and simply apply the patch to that one file.

Thanks

Etan

> On 30 Mar 2017, at 09:44, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> 
> + linux-wireless, brcm80211-dev-list
> 
>> On 30-3-2017 0:07, Tao Peng wrote:
>> Hi Arend, Etan, 
>> 
>> I found this email thread on the Hostap mailing list archive, and I am having the exact same problem. It seems that you’ve identified the problem as in the broadcom wifi chip firmware / driver. 
>> 
>> It’s been over half a year since then, I wonder whether you’ve found the solution to the problem or more details about it.  Whatever you’ve found out afterwards, would you please kindly shed some lights here?
> 
> Well, commit f25ba69c638b ("brcmfmac: update beacon IE after bss up and
> clear when AP stopped"), went in almost half year ago so what kernel
> version are you running. This patch can be found in patchwork [1].
> 
> Regards,
> Arend
> 
> [1] https://patchwork.kernel.org/patch/9435643/
