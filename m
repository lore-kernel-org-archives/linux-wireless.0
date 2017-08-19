Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:59142 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbdHSU55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 16:57:57 -0400
Subject: Re: [PATCH 06/34] brcmfmac: Remove bandaid for SleepCSR
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-7-ian@mnementh.co.uk> <59884E41.2050100@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <d21b5fb1-218d-23bb-ba3b-476a036b5325@mnementh.co.uk> (sfid-20170819_225800_913495_56294031)
Date: Sat, 19 Aug 2017 21:57:55 +0100
MIME-Version: 1.0
In-Reply-To: <59884E41.2050100@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:25, Arend van Spriel wrote:
> On 26-07-17 22:25, Ian Molton wrote:
>> Register access code is not the place for band-aid fixes like this.
>> If this is a genuine problem, it should be fixed further up in the driver
>> stack.
> 
> So lets make it a SDIO debug message for all register accesses getting
> rid of the error message.

Not quite sure I follow here - but as the code is completely gone in
later patches in the series, does it matter?

Perhaps address this if it in future, if it crops up as a problem, since
it wont be fatal even if it does...

-Ian
