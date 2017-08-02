Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752139AbdHBIQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 04:16:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: chi-hsien.lin@cypress.com, Wright Feng <wright.feng@cypress.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
        <1501577287-28904-2-git-send-email-wright.feng@cypress.com>
        <6a914bee-383e-a45c-a805-f49716fc9ccf@broadcom.com>
        <64c1343e-8797-9cbe-20c9-61b223122ecf@cypress.com>
        <7fc60191-6d6c-1f6a-615b-e0f565067983@broadcom.com>
Date: Wed, 02 Aug 2017 11:15:55 +0300
In-Reply-To: <7fc60191-6d6c-1f6a-615b-e0f565067983@broadcom.com> (Arend van
        Spriel's message of "Tue, 1 Aug 2017 23:03:47 +0200")
Message-ID: <87poces7us.fsf@kamboji.qca.qualcomm.com> (sfid-20170802_101605_430063_01A09641)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 01-08-17 17:10, Chi-Hsien Lin wrote:
>> 
>> 
>> On 08/01/2017 8:43, Arend van Spriel wrote:
>>>
>>>
>>> On 01-08-17 10:48, Wright Feng wrote:
>>>> From: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
>>>>
>>>> These changes add support for CYW4373 SDIO/USB chipset.
>>>
>>> Could you summarize 4373 features, ie. is it 11n or 11ac? How much
>>> streams does it support? That kind of stuff.
>> Sure. 4373 is a 1x1 dual-band 11ac chip with 20/40/80Mhz channel
>> support. It's a WiFi/BT combo chip with SDIO/USB bus support.
>
> Thanks. Can you add this info to the commit message and resend a V2. I
> think Kalle prefers that all patches are resubmitted in such event.

Correct.

I now documented this also in the wiki:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#resubmit_the_whole_patchset

-- 
Kalle Valo
