Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34232 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdHHJKJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 05:10:09 -0400
Received: by mail-wm0-f47.google.com with SMTP id t138so4892253wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 02:10:09 -0700 (PDT)
Subject: Re: Problem with the wifi
To: Paolo Bettini <paolobettini@gmx.com>
References: <00515b4a-5949-3746-db71-6b2b8a82dd1a@gmx.com>
 <f801b919-d4a8-6840-23ff-9773861bce6d@broadcom.com>
 <d14706d5-cc89-223f-3b4f-933af5004168@gmx.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a0a2f322-8797-ba6c-c820-a3bd2371ed96@broadcom.com> (sfid-20170808_111018_803086_D5EE01E8)
Date: Tue, 8 Aug 2017 11:10:07 +0200
MIME-Version: 1.0
In-Reply-To: <d14706d5-cc89-223f-3b4f-933af5004168@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless
+ Larry

please keep linux-wireless in this thread.

On 08-08-17 08:21, Paolo Bettini wrote:
> Arend van Spriel ha scritto:
>> + linux-wireless On 07-08-17 21:38, Paolo Bettini wrote:
>>> Hi , i am Paolo and i installed Debian stretch on my ezbook2 . One
>>> problem is the wifi , the card a SDIO device , seems to be 02d0:a9a6
>>> linux id or Broadcom AP6212 for windows....i installed deb package
>>> firmware-brcm80211 and nvram sdio txt in /lib/firmware/brcm, reloaded
>>> bcrmfmac module but nothing the card seems invisible or dead i don't
>>> know if is a problem of firmware or my system cannot detect the sdio
>>> card ...do you know something about this problematic ?
>> As always a kernel log could help or output from dmesg command. Also
>> can you run following commands: $ ls /sys/bus/sdio/devices $ cat
>> /sys/bus/sdio/devices/*/modalias Regards, Arend
> paolo@paolo:~$ ls /sys/bus/sdio/devices
> mmc1:0001:1
> paolo@paolo:~$
> 
> 
> paolo@paolo:~$ cat /sys/bus/sdio/devices/*/modalias sdio:c07v024CdB723
> paolo@paolo:~$ sorry for previous mail ....ls was from another pc....:-[
> it seems the system see only the card where the system is installed

Hi Paolo,

Interesting. Now if Google search is correct the vendor id for this
device indicates this is a Realtek (v024C) WLAN (c07) device. So what
makes you say its linux id is 02d0:a9a6?

In upstream linux I do not see any SDIO device drivers in realtek
folder. Maybe Larry can provide clue/hint if a driver for this device is
publicly available somewhere.

Regards,
Arend
