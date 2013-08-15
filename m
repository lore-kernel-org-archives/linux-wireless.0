Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57572 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3HOFkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 01:40:42 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so421024pab.34
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 22:40:42 -0700 (PDT)
Message-ID: <520C69D5.2010502@gna.org> (sfid-20130815_074056_376073_4F42A422)
Date: Thu, 15 Aug 2013 17:40:37 +1200
From: Christian Gagneraud <chgans@gna.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Siyu Qiu <ppqq2356@gmail.com>
Subject: Re: Switching band of a dual-band WiFi device
References: <520C631F.6010806@gna.org> <CA+J2US3uKD9xr9FOg5=tkwjx2ETQY9qmH305supcjGcVYHmRPQ@mail.gmail.com>
In-Reply-To: <CA+J2US3uKD9xr9FOg5=tkwjx2ETQY9qmH305supcjGcVYHmRPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15/08/13 17:30, Siyu Qiu wrote:
> hi, do you mean that you take the wireless card from tplink and embed it
> into your pc ? Does it work ? Coz i want to put qca 9889 into pc but the
> info about network controller is :!!! unknown type 7f

Hi Siyu Qio,

I'm not sure to understand your question, but this is what I did
- went to the shop to buy this USB stick
- plugged it in a USB slot of my PC

And now I'm trying to understand if I can switch/enable/disable these 2 
bands, and more importantly, do I really need to?
Right now, my feeling is that "it just works out of the box", I 
shouldn't try to do this kind of things. I just try to understand this 
dual-band thing.

Chris

PS: Can you reply on the mailing list instead of sending private email 
please?


>
> On Aug 14, 2013 10:12 PM, "Christian Gagneraud" <chgans@gna.org
> <mailto:chgans@gna.org>> wrote:
>
>     Hi there,
>
>     I am using a TP-Link TL-WDN3200 on a ubuntu 13.04 (kernel
>     3.8.0-27-generic), and I have install relevant modules with
>     backports-3.11-rc3-1.
>
>     I would like to switch my WiFi stick to 5GHz, I tried iwconfig wlan0
>     freq 5G, but I get ENOTSUPP.
>     Is the freq settings suppose to handle this 2.4 vs 5GHz band or is
>     it only for selecting channel frequency within a given band?
>
>     Does linux-wireless provides a way for selecting 2.4 or 5GHz band?
>
>     "iw phy phy11 info" tells me that in band 2, all the frequencies are
>     disabled except:
>                              * 5745 MHz [149] (30.0 dBm)
>                              * 5755 MHz [151] (30.0 dBm)
>                              * 5765 MHz [153] (30.0 dBm)
>                              * 5775 MHz [155] (30.0 dBm)
>                              * 5785 MHz [157] (30.0 dBm)
>                              * 5795 MHz [159] (30.0 dBm)
>                              * 5805 MHz [161] (30.0 dBm)
>                              * 5825 MHz [165] (30.0 dBm)
>
>     As well, my understanding of WiFi might be a bit limited but, does a
>     dual-band WiFi device provides 2.4 and 5GHz services at the same
>     time or do I need to select one or the other myself? Or maybe I can
>     just enable/disable them manually (and separately)?
>
>     Hope someone can shed some light at this.
>
>     Regards,
>     Chris
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-wireless" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/__majordomo-info.html
>     <http://vger.kernel.org/majordomo-info.html>
>

