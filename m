Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50631 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1A3MIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:08:51 -0500
Received: by qyj19 with SMTP id 19so2415670qyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:08:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimPoG2wEY-XOpfW99qpK6ohe5k3wR6XjtSYCH4L@mail.gmail.com>
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
	<AANLkTinhxNK9a6E2iGdFnvQuk-j7W=Pax7WirH08E5eQ@mail.gmail.com>
	<AANLkTikqR=aX+icFSKxkMNCZdbEgPmKR--gAPePgW6vM@mail.gmail.com>
	<20110128161612.GC2452@redhat.com>
	<AANLkTimPoG2wEY-XOpfW99qpK6ohe5k3wR6XjtSYCH4L@mail.gmail.com>
Date: Sun, 30 Jan 2011 13:08:50 +0100
Message-ID: <AANLkTin4S8ZceiRKJ2i01HuiWRxb7gDPa_1SkGonforo@mail.gmail.com>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Brian Prodoehl <bprodoehl@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I write everything down, in case someone in future would hit similar issue.

W dniu 29 stycznia 2011 10:37 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> W dniu 28 stycznia 2011 17:16 użytkownik Stanislaw Gruszka
> <sgruszka@redhat.com> napisał:
>> On Thu, Jan 27, 2011 at 06:19:56PM +0100, Rafał Miłecki wrote:
>>> What I've bought is following adapter:
>>> http://allegro.pl/adapter-wifi-mini-pci-e-na-pci-e-3-anteny-kp13-i1429732145.html
>>
>> I'm using adapters form http://www.hwtools.net/ , they work pretty well for me,
>> but they are also quite expensive.
>
> Yeah, they have adapters few times more expensive than my one :(
>
>
> Yesterday my friend was nice (and brave :P) enough to let me open his
> notebook and test my card in it. Card was detected just fine in his
> Windows 7.
>
> Today I managed to test my adapter (with my Broadcom card inside) in
> some other PC with PCI Express x1. It was detected again! Motherboard
> in this PC is: Asus/Pegatron IPMTB-TK.
>
>
> So:
> 1) My Broadcom card is fine
> 2) My adapted is fine
>
> There must be problem with my motherboard/BIOS/PCI Express x1 slot.
>
> I'm much happier now when I know I don't need to return that adapters
> (I bought 2) :)

I've used openSUSE LiveCD on Asus/Pegatron IPMTB-TK and I still was
able to see my WiFi card (using adapter).

Then thanks for MSDNAA I've tried Windows XP on my problematic
P5V02-MX motherboard. Windows XP also could not detect my WiFI card!

So there is nothing from with Linux+adapter, the problem in directly
related to my P5V02-MX motherboard.

-- 
Rafał
