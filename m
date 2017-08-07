Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:35348 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751775AbdHGRva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 13:51:30 -0400
Subject: Re: [PATCH 07/34] brcmfmac: Remove brcmf_sdiod_request_data()
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-8-ian@mnementh.co.uk> <59884E46.5090000@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <62cd90bd-718d-e7a7-d73e-e868b5499ed5@mnementh.co.uk> (sfid-20170807_195133_757484_D2E070CE)
Date: Mon, 7 Aug 2017 18:51:28 +0100
MIME-Version: 1.0
In-Reply-To: <59884E46.5090000@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:25, Arend van Spriel wrote:
>> Handling of -ENOMEDIUM is altered, but as that's pretty much broken
>> anyway
>> we can ignore that.
> 
> Please explain why you think it is broken.

Not got the code to hand right now, but from memory, theres a trapdoor
case where the state can wind up set to something that prevents it ever
being changed again. I'll dig it up when I get back from holiday (this
next few days).

-Ian
