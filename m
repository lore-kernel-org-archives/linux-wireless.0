Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34228 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbdHAVDv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 17:03:51 -0400
Received: by mail-wm0-f47.google.com with SMTP id t138so36286312wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Aug 2017 14:03:50 -0700 (PDT)
Subject: Re: [PATCH 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
To: chi-hsien.lin@cypress.com, Wright Feng <wright.feng@cypress.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
 <1501577287-28904-2-git-send-email-wright.feng@cypress.com>
 <6a914bee-383e-a45c-a805-f49716fc9ccf@broadcom.com>
 <64c1343e-8797-9cbe-20c9-61b223122ecf@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7fc60191-6d6c-1f6a-615b-e0f565067983@broadcom.com> (sfid-20170801_230357_023156_AEEDB1B9)
Date: Tue, 1 Aug 2017 23:03:47 +0200
MIME-Version: 1.0
In-Reply-To: <64c1343e-8797-9cbe-20c9-61b223122ecf@cypress.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-08-17 17:10, Chi-Hsien Lin wrote:
> 
> 
> On 08/01/2017 8:43, Arend van Spriel wrote:
>>
>>
>> On 01-08-17 10:48, Wright Feng wrote:
>>> From: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
>>>
>>> These changes add support for CYW4373 SDIO/USB chipset.
>>
>> Could you summarize 4373 features, ie. is it 11n or 11ac? How much
>> streams does it support? That kind of stuff.
> Sure. 4373 is a 1x1 dual-band 11ac chip with 20/40/80Mhz channel
> support. It's a WiFi/BT combo chip with SDIO/USB bus support.

Thanks. Can you add this info to the commit message and resend a V2. I
think Kalle prefers that all patches are resubmitted in such event.

Regards,
Arend
