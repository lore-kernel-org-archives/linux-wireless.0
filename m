Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35170 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbdBXJJ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 04:09:27 -0500
Received: by mail-wm0-f43.google.com with SMTP id v186so9497464wmd.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 01:08:02 -0800 (PST)
Subject: Re: Request for brcmfmac4366c-pcie.bin
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
References: <CACna6ryBmEX1OVijdapGiTXs9dYssy+gzMnY2Sr_rd+OpMO1-g@mail.gmail.com>
 <CACna6rywt_U+SSLRGAgnqZiwO8TmY8z406m8o5gCOsGiyUc+oQ@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Nathan Grennan <kernel-bugzilla@cygnusx-1.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <27514f14-2803-b978-f8fe-66b043a279f7@broadcom.com> (sfid-20170224_101005_231560_FEE22619)
Date: Fri, 24 Feb 2017 10:07:58 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rywt_U+SSLRGAgnqZiwO8TmY8z406m8o5gCOsGiyUc+oQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23-2-2017 21:53, Rafał Miłecki wrote:
> Hi guys,
> 
> On 12 September 2016 at 07:22, Rafał Miłecki <zajec5@gmail.com> wrote:
>> Few months ago Hante added support for 4366c0 to the brcmfmac. There
>> are already few devices with this chipset on the market. We even have
>> some related bug report at kernel:
>> https://bugzilla.kernel.org/show_bug.cgi?id=135321
>>
>> Unfortunately the firmware for this chipset is still missing. Can you
>> build it and submit to linux-firmware.git, please?
> 
> Last answer I got from Arend was "Router group still working on a
> solution. Will ask about status again :-(" in December.
> Are there any news on 4366c1 firmware?

There have been some firmware changes being made, but these need to be
validated. As the validation is in DFS area it may take some time and we
have to free up resources to actually do the validation.

Regards,
Arend
