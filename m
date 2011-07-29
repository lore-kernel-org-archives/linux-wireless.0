Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42934 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab1G2VTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 17:19:04 -0400
Received: by iyb12 with SMTP id 12so4384179iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 14:19:04 -0700 (PDT)
Message-ID: <4E3323C5.2010009@lwfinger.net> (sfid-20110729_231918_364816_C20F0305)
Date: Fri, 29 Jul 2011 16:19:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jongmyeong Kim <jongmyeong.kim@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192SE
References: <CADmdGK5PhiPtHaHFp34jV=7H8NB0fJo-km8=qEsRb35=YJ-5ew@mail.gmail.com>
In-Reply-To: <CADmdGK5PhiPtHaHFp34jV=7H8NB0fJo-km8=qEsRb35=YJ-5ew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/29/2011 03:41 PM, Jongmyeong Kim wrote:
> Hi Larry,
>
> I have thinkpad T410 and it has rtl8192se as wifi card.
> Today, I downloaded newest rtl8192se linux driver from realtek website
> (92ce_se_de_linux_mac80211_0003.0620.2011.tar.gz) and installed it.
> It worked fantastically but when I tried to reboot the laptop, the laptop says
> 'unauthorized network card is plugged in' and refuses to boot.
>
> I think your driver changed PCI ID of the wireless card and I want to bring back
> to the original value. Fortunately, I have another T410 with same configuration
> so I can get some information from that laptop. I'm planning to restore eeprom
> of rtl8192se by using 'ethtool' but it requires magic number of rtl8192se.
> Can you provide the magic number?
>
> I'm looking at the driver's code, can you point out which file changes PCI ID
> of the wireless card? I'm a programmer so I can read and understand the C code
> and I hope there can be a clue in the source code to fix this problem.

Nothing in the rtl8192se driver changes the PCI ID. That information is hard 
coded into the device. I do not know why the Thinkpad's BIOS did not flag the 
card as illegal on the initial startup. My HP certainly does.

I think that "whitelisting" the wifi cards is a horrible practice. I have used 
HP notebook computers for about 10 years, but the current one will be the last 
due to their BIOS practices. I own 14 mini-PCIe wifi devices, and only 2 are 
whitelisted. Similarly, I will never buy a Lenovo notebook. I use these 
"foreign" PCIe cards on an ExpressCard extender card, but that came from Realtek 
as part of my work with them. I do not know of a source for these cards.

Larry
