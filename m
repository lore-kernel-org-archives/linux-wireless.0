Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02a.posteo.de ([89.146.194.168]:36021 "EHLO mx02a.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab3KZQr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 11:47:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 26 Nov 2013 17:47:48 +0100
From: p2p@posteo.de
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Linux wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8188S
In-Reply-To: <2035998.63y5xTAJxx@blech>
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de>
 <2035998.63y5xTAJxx@blech>
Message-ID: <67b4a51871c98531c68306862402baf4@posteo.de> (sfid-20131126_174804_325981_DD14C377)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Mr. Lamparter,

Am 25.11.2013 22:57 schrieb Christian Lamparter:
> On Monday, November 25, 2013 06:57:32 PM p2p@posteo.de wrote:
>> I have a WLAN dongle with Realtek RTL8188S chip.
>> I don't want to use r8712u driver with wext interface
>> because I want to establish a wifi direct p2p connection.
>
> AFICT, you should be able to connect to a p2p-go peer
> even if your device (in this case rtl8188s) only supports
> station mode...
>

How do I do this?

>> Unfortunately the original Realtek driver from hp didn't
>> work with p2p too.
> Why, what happens in this case?
>

I have downloaded the driver from:
http://www.realtek.com/downloads/downloadsView.aspx?Langid=1&PNid=48&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true#RTL8188SU

Installed and loaded the module 8712u.

"iw list" doesn't list p2p-client or p2p-go.

wpa_cli command p2p_find results in FAIL.

wpa_supplicant ouput:

CTRL_IFACE monitor attached - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 
5f 63 74 72 6c 5f 32 34 39 37 2d 32 00
1385328422.214780: RX ctrl_iface - hexdump_ascii(len=8):
      50 32 50 5f 46 49 4e 44                           P2P_FIND
1385328422.214893: wlan0: Control interface command 'P2P_FIND'

-> but nothing more...

>> I thought RTL8192cu will work, but Larry F. told me it doesn't.
> OK? (care to explain?)
>
>> He said there is a new driver in development.
> Sort of. There's r92su, however this driver only supports what the
> firmware is able to do (station, ad-hoc and a limited monitor mode).
>
>> I'm searching for information. Please can someone tell me about
>> the project, its status, and if someone can take part.
> Hey that's good to hear. The future of "r92su" was discussed in [0],
> [1], ... The good news is:
>

I followed the thread.
It shows me that it makes no sense. I am a beginner and I only can 
spent time for it if someone tells me for example: fill this module with 
code for this specific function. I have good literature and I think I 
can try to help but not lead something.

Best regards
p2p
