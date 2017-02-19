Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36851 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750978AbdBSTh3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 14:37:29 -0500
Received: by mail-wm0-f46.google.com with SMTP id c85so60370073wmi.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 11:37:28 -0800 (PST)
Subject: Re: brcmfmac: BCM4343A0 P2P mode problem
To: Stefan Holzmann <stefan.holzmann@gmx.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <zarafa.58a9eb4f.3258.65a3ba3c60add992@homeserver.home>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <78cfb1db-150d-b2be-9ef7-6076468678d2@broadcom.com> (sfid-20170219_203740_489102_2DDB9AE4)
Date: Sun, 19 Feb 2017 20:37:25 +0100
MIME-Version: 1.0
In-Reply-To: <zarafa.58a9eb4f.3258.65a3ba3c60add992@homeserver.home>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-2-2017 20:00, Stefan Holzmann wrote:
> Hello,
> 
> I think my problem was just a firmware version issue. When I use the firmware file "fw_bcm4343.bin" from here https://android.googlesource.com/platform/hardware/broadcom/wlan I'am able establish a P2P connection.
> Is this the latest/recommended firmware version for the chipset?
> 
> Firmware version = wl0: Jul  1 2016 18:02:40 version 7.10.1 (A0 Station/P2P feature) FWID 01-bae8afee

I would suggest looking in linux-firmware repo on kernel.org for
upstream firmware instead of using AOSP firmware. However, I am not
entirely sure whether we have the firmware in place for your chipset.

Could you insert the driver module with parameter debug=0x1416 and send
me dmesg output.

Regards,
Arend
