Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:36757 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdC3Hom (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 03:44:42 -0400
Received: by mail-wr0-f176.google.com with SMTP id w11so46979883wrc.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Mar 2017 00:44:40 -0700 (PDT)
Subject: Re: Adding a vendor Information Element to beacon / probe response
 frames
To: Tao Peng <pengtao@me.com>
References: <86F2B872-9405-4264-8C9A-3765DFE4866F@me.com>
Cc: kissling@oberon.ch,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com"
        <brcm80211-dev-list.pdl@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9c6951e7-22b8-d890-f3cf-ba846e523b3b@broadcom.com> (sfid-20170330_094445_536745_19E7020A)
Date: Thu, 30 Mar 2017 09:44:38 +0200
MIME-Version: 1.0
In-Reply-To: <86F2B872-9405-4264-8C9A-3765DFE4866F@me.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless, brcm80211-dev-list

On 30-3-2017 0:07, Tao Peng wrote:
> Hi Arend, Etan, 
> 
> I found this email thread on the Hostap mailing list archive, and I am having the exact same problem. It seems that you’ve identified the problem as in the broadcom wifi chip firmware / driver. 
> 
> It’s been over half a year since then, I wonder whether you’ve found the solution to the problem or more details about it.  Whatever you’ve found out afterwards, would you please kindly shed some lights here?

Well, commit f25ba69c638b ("brcmfmac: update beacon IE after bss up and
clear when AP stopped"), went in almost half year ago so what kernel
version are you running. This patch can be found in patchwork [1].

Regards,
Arend

[1] https://patchwork.kernel.org/patch/9435643/
