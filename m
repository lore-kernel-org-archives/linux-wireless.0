Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:46676 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbdHaPTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 11:19:30 -0400
Subject: Re: [PATCH 03/30] brcmfmac: Split brcmf_sdiod_regrw_helper() up.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-4-ian@mnementh.co.uk>
 <91172916-24b6-a52a-8ef2-ab891fcce5a0@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <205352a4-9548-e6aa-994c-633391c2e873@mnementh.co.uk> (sfid-20170831_171933_438077_F7783658)
Date: Thu, 31 Aug 2017 16:19:28 +0100
MIME-Version: 1.0
In-Reply-To: <91172916-24b6-a52a-8ef2-ab891fcce5a0@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/08/17 19:59, Arend van Spriel wrote:
>> +static int brcmf_sdiod_reg_write(struct brcmf_sdio_dev *sdiodev, u32
>> addr,
>> +                 u8 regsz, void *data)
> 
> Thought I mentioned this before, but the indentation should be aligned
> to opening bracket.

I checked this locally, and its fine. I suspect its getting mangled
somewhere along the way.

It looks fine in my original email - I see 4 tabs and a space.

-Ian
