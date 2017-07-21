Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49826 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752198AbdGUHgk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 03:36:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Gugino <michael.gugino.2@gmail.com>,
        linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] rtl8188eu: add TL-WN722N v2 support
References: <CACHT076KPRRyt5KuEOKkjGSh+wrQAFOEzcPx2-ZHfbp=6u9aTQ@mail.gmail.com>
        <20170717162357.GD9786@kroah.com>
Date: Fri, 21 Jul 2017 10:36:36 +0300
In-Reply-To: <20170717162357.GD9786@kroah.com> (Greg KH's message of "Mon, 17
        Jul 2017 18:23:57 +0200")
Message-ID: <87vamm1bsr.fsf@purkki.adurom.net> (sfid-20170721_093659_575559_B0AA4E8F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <gregkh@linuxfoundation.org> writes:

> On Mon, Jul 17, 2017 at 11:59:35AM -0400, Michael Gugino wrote:
>> From: Michael Gugino <michael.gugino.2@gmail.com>
>> 
>> This patch adds support for USB Device TP-Link TL-WN722N v2.
>> VendorID: 0x2357, ProductID: 0x010c
>> 
>> Signed-off-by: Michael Gugino <michael.gugino.2@gmail.com>
>> ---
>> drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
>> 1 file changed, 1 insertion(+)
>
> You just sent two different patches, with the same subject, and both
> were corrupted :(
>
> Please fix your email client (test it by sending it to yourself first),
> and try again.
>
> Also, use scripts/get_maintainer.pl to get the correct mailing list...

And please use "staging:" prefix for staging patches. This way it's
easier to filter them in mailbox and in patchwork.

-- 
Kalle Valo
