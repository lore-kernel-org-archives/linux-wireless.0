Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38690 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdHGTpH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 15:45:07 -0400
Received: by mail-wm0-f42.google.com with SMTP id m85so14741257wma.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 12:45:07 -0700 (PDT)
Subject: Re: Problem with the wifi
To: Paolo Bettini <paolobettini@gmx.com>
References: <00515b4a-5949-3746-db71-6b2b8a82dd1a@gmx.com>
Cc: brcm80211-dev-list@broadcom.com,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f801b919-d4a8-6840-23ff-9773861bce6d@broadcom.com> (sfid-20170807_214511_486160_C7ED4ADC)
Date: Mon, 7 Aug 2017 21:45:05 +0200
MIME-Version: 1.0
In-Reply-To: <00515b4a-5949-3746-db71-6b2b8a82dd1a@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 07-08-17 21:38, Paolo Bettini wrote:
> Hi , i am Paolo and i installed Debian stretch on my ezbook2 . One
> problem is the wifi , the card a SDIO device , seems to be 02d0:a9a6
> linux id or Broadcom AP6212 for windows....i installed deb package
> firmware-brcm80211 and nvram sdio txt in /lib/firmware/brcm, reloaded
> bcrmfmac module but nothing the card seems invisible or dead i don't
> know if is a problem of firmware or my system cannot detect the sdio
> card ...do you know something about this problematic ?

As always a kernel log could help or output from dmesg command. Also can
you run following commands:

$ ls /sys/bus/sdio/devices
$ cat /sys/bus/sdio/devices/*/modalias

Regards,
Arend
