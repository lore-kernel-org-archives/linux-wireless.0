Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4616 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1CMNPt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Mar 2011 09:15:49 -0400
To: HiEn <vhpham80@yahoo.com>
Subject: Re: Broadcom USB Dongle Wifi BCM4323
References: <33960.57403.qm@web34205.mail.mud.yahoo.com>
Date: Sun, 13 Mar 2011 14:13:17 +0100
cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vr99odoz3ri7v4@arend-laptop>
In-Reply-To: <33960.57403.qm@web34205.mail.mud.yahoo.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Mar 2011 10:18:32 +0100, HiEn <vhpham80@yahoo.com> wrote:

> Hi Arend,
> I've tried but could not find the driver source code (linux) for BCM4323  
> (USB Wifi Dongle).   Could you please give me some advise?
>
> Thanks and best regards,
>

Well, you did not find it because there is no open-source support for it.  
Both b43 and brcm80211 drivers do not provide usb support (see table at  
http://wireless.kernel.org/en/users/Drivers/b43#Known_PCI_devices). It is  
suggested to use ndiswrapper, but I guess that is not your goal as you are  
looking for source code.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

