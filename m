Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34319 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdGQRel (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 13:34:41 -0400
Received: by mail-io0-f169.google.com with SMTP id r36so867431ioi.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 10:34:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170717162510.GE9786@kroah.com>
References: <CACHT077fJY0EBYRk+wgnVREoEf-d+Brejq2JngcSpsi_ygV-GA@mail.gmail.com>
 <20170717162510.GE9786@kroah.com>
From: Michael Gugino <michael.gugino.2@gmail.com>
Date: Mon, 17 Jul 2017 13:34:39 -0400
Message-ID: <CACHT075WDfsoV+CfM8+KeZrKyXEp_XH40GrUshYcVbxcKqPiHA@mail.gmail.com> (sfid-20170717_193445_035110_FB4F76E3)
Subject: Re: [PATCH v2 1/1] rtl8188eu: add TL-WN722N v2 support
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the spam.  I think I have it together now, sent patch to
driverdev-devel list with what appears to be correct subject line. I
appreciate your time and feedback.

Re what changed from v1:  Nothing, my first mangled patch added
whitespace.  I have submitted new patch to driverdev without vX.

Thank you,

Michael Gugino

On Mon, Jul 17, 2017 at 12:25 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Jul 17, 2017 at 12:03:07PM -0400, Michael Gugino wrote:
>> From: Michael Gugino <michael.gugino.2@gmail.com>
>>
>> This patch adds support for USB Device TP-Link TL-WN722N v2.
>> VendorID: 0x2357, ProductID: 0x010c
>>
>> Signed-off-by: Michael Gugino <michael.gugino.2@gmail.com>
>> ---
>>  drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
>>  1 file changed, 1 insertion(+)
>
> What changed from v1?  Always be specific...
>
> v3?
