Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:59756 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdHAPxq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 11:53:46 -0400
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
 <1501577287-28904-2-git-send-email-wright.feng@cypress.com>
 <6a914bee-383e-a45c-a805-f49716fc9ccf@broadcom.com>
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <64c1343e-8797-9cbe-20c9-61b223122ecf@cypress.com> (sfid-20170801_175404_545088_C0B78113)
Date: Tue, 1 Aug 2017 23:10:42 +0800
MIME-Version: 1.0
In-Reply-To: <6a914bee-383e-a45c-a805-f49716fc9ccf@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/01/2017 8:43, Arend van Spriel wrote:
> 
> 
> On 01-08-17 10:48, Wright Feng wrote:
>> From: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
>>
>> These changes add support for CYW4373 SDIO/USB chipset.
> 
> Could you summarize 4373 features, ie. is it 11n or 11ac? How much
> streams does it support? That kind of stuff.
Sure. 4373 is a 1x1 dual-band 11ac chip with 20/40/80Mhz channel 
support. It's a WiFi/BT combo chip with SDIO/USB bus support.

> 
> Regards,
> Arend
> .
> 
