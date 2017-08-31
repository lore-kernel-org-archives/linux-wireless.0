Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:44224 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbdHaPhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 11:37:04 -0400
Subject: Re: [PATCH 18/30] brcmfmac: Cleanup offsetof()
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-19-ian@mnementh.co.uk>
 <c4412aaa-1c66-44d5-1f0b-cc208aad7e60@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <2176a8b7-4fca-ffe1-4cf8-e8853c9d1dfc@mnementh.co.uk> (sfid-20170831_173708_053773_E5E6EF54)
Date: Thu, 31 Aug 2017 16:37:02 +0100
MIME-Version: 1.0
In-Reply-To: <c4412aaa-1c66-44d5-1f0b-cc208aad7e60@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/08/17 20:37, Arend van Spriel wrote:
> On 22-08-17 13:25, Ian Molton wrote:
>> +#define __sd_reg(field) \
>> +        (offsetof(struct sdpcmd_regs, field))
> 
> I really dislike __foo() stuff. Please just stick with uppercase for
> macros, so SD_REG(). I am fine with dropping the base here.

I'm fine with that. Will change.

-Ian
