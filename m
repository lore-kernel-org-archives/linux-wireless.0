Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2953 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab1CNJWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 05:22:13 -0400
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: HiEn <vhpham80@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom USB Dongle Wifi BCM4323
References: <33960.57403.qm@web34205.mail.mud.yahoo.com>
 <op.vr99odoz3ri7v4@arend-laptop>
 <AANLkTinFJt92Ai_DGWDE7VrTV4gb0h7Dz6rW_Hb7nvnt@mail.gmail.com>
Date: Mon, 14 Mar 2011 10:21:51 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsad07vh3ri7v4@arend-laptop>
In-Reply-To: <AANLkTinFJt92Ai_DGWDE7VrTV4gb0h7Dz6rW_Hb7nvnt@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Mar 2011 15:24:15 +0100, Rafał Miłecki <zajec5@gmail.com> wrote:

>
> Does anyone have some hardware knowledge about that card? Is this
> standard SSB/AI bus with USB host? Or some totally different hardware?
>

This is what you can find on the public page:

http://www.broadcom.com/products/Wireless-LAN/802.11-Wireless-LAN-Solutions/BCM4323

We want to add support of more chips to the brcm80211 driver, but for that  
we first have to get into kernel mainline.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

