Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36113 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbbJNTc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 15:32:26 -0400
Received: by oihr205 with SMTP id r205so33910124oih.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 12:32:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444848433.2718.27.camel@perches.com>
References: <1444844949-8765-1-git-send-email-ejcaruso@google.com>
	<1444848433.2718.27.camel@perches.com>
Date: Wed, 14 Oct 2015 12:32:25 -0700
Message-ID: <CAA9CXT3GSqG5wx3m5eLX_fs3QBQSC1OhbD6eEePaiphOcXwV9A@mail.gmail.com> (sfid-20151014_213229_441599_5691BB29)
Subject: Re: [PATCH v2] brcm80211: Add support for brcm4371
From: Eric Caruso <ejcaruso@google.com>
To: Joe Perches <joe@perches.com>
Cc: brudley@broadcom.com, arend@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, Lei Zhang <leizh@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2015 at 11:47 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2015-10-14 at 10:49 -0700, Eric Caruso wrote:
>> This is a new Broadcom chip and we should be able to recognize it.
> []
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
> []
>> @@ -1456,6 +1460,9 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
>>               fw_name = BRCMF_PCIE_4366_FW_NAME;
>>               nvram_name = BRCMF_PCIE_4366_NVRAM_NAME;
>>               break;
>> +     case BRCM_CC_4371_CHIP_ID:
>> +             fw_name = BRCMF_PCIE_4371_FW_NAME;
>> +             nvram_name = BRCMF_PCIE_4371_NVRAM_NAME;
>
> missing break;
>
>>       default:
>>               brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
>>               return -ENODEV;
>
>

Whoops, looks like that got lost in the rebase. Sorry.
