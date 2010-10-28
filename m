Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37878 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab0J1IYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 04:24:15 -0400
Received: by fxm16 with SMTP id 16so1664640fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 01:24:14 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Lee <lee-in-berlin@web.de>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Thu, 28 Oct 2010 10:23:26 +0200
Cc: linux-wireless@vger.kernel.org
References: <4CC0D0F6.4080507@web.de> <201010260740.47692.helmut.schaa@googlemail.com> <4CC93148.7090308@web.de>
In-Reply-To: <4CC93148.7090308@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010281023.26957.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 28 Oktober 2010 schrieb Lee:
> On 26/10/10 07:40, Helmut Schaa wrote:
> > # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
> > 
> > Do you see any frames from your specific client?
> 
> Yes. I can see this:
> # tcpdump -i mon0 "ether host 00:1F:3B:79:41:6F"
[...]
> 10:10:03.013402 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV: 14 Pad 20 KeyID 0
> 
> However, on wlan0 I don't see anything beyond the EAPOL packets.
> Temporarily turning off WPA encryption let me successfully connect to my AP.

Aha, could you please try if loading rt73usb with nohwcrypt=1 helps?

Helmut
