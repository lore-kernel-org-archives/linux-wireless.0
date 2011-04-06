Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55256 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1DFS3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 14:29:31 -0400
Received: by qyk7 with SMTP id 7so2724412qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2011 11:29:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.vsad07vh3ri7v4@arend-laptop>
References: <33960.57403.qm@web34205.mail.mud.yahoo.com>
	<op.vr99odoz3ri7v4@arend-laptop>
	<AANLkTinFJt92Ai_DGWDE7VrTV4gb0h7Dz6rW_Hb7nvnt@mail.gmail.com>
	<op.vsad07vh3ri7v4@arend-laptop>
Date: Wed, 6 Apr 2011 20:29:29 +0200
Message-ID: <BANLkTik3Qs0BHpQCYqp0vsS0H-sCcyJ=NA@mail.gmail.com>
Subject: Re: Broadcom USB Dongle Wifi BCM4323
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: HiEn <vhpham80@yahoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 marca 2011 10:21 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On Sun, 13 Mar 2011 15:24:15 +0100, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>>
>> Does anyone have some hardware knowledge about that card? Is this
>> standard SSB/AI bus with USB host? Or some totally different hardware?
>>
>
> This is what you can find on the public page:
>
> http://www.broadcom.com/products/Wireless-LAN/802.11-Wireless-LAN-Solutions/BCM4323
>
> We want to add support of more chips to the brcm80211 driver, but for that
> we first have to get into kernel mainline.

I don't think official Boardom's website provides much info about
internal hardware layout.

Could you get some more info for us? Is this standard AI board with
ChipCommon, USB and 802.11 cores? Why PHY version does it use?

-- 
Rafał
