Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02a.posteo.de ([89.146.194.168]:57492 "EHLO mx02a.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab3LCTOW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 14:14:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Tue, 03 Dec 2013 20:14:08 +0100
From: p2p@posteo.de
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: RTL8188S
In-Reply-To: <1783016.HDzIMuL15q@blech>
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de>
 <2035998.63y5xTAJxx@blech> <67b4a51871c98531c68306862402baf4@posteo.de>
 <1783016.HDzIMuL15q@blech>
Message-ID: <71e5f26b0cd51bcceb26565aa236fe7a@posteo.de> (sfid-20131203_201425_796606_DB7CCED6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Mr. Lamparter,

Am 26.11.2013 21:38 schrieb Christian Lamparter:
> Dear Ms./Mr. ...?
>
> On Tuesday, November 26, 2013 05:47:48 PM p2p@posteo.de wrote:
>> Am 25.11.2013 22:57 schrieb Christian Lamparter:
>> > On Monday, November 25, 2013 06:57:32 PM p2p@posteo.de wrote:
>> >> I have a WLAN dongle with Realtek RTL8188S chip.
>> >> I don't want to use r8712u driver with wext interface
>> >> because I want to establish a wifi direct p2p connection.
>> >
>> > AFICT, you should be able to connect to a p2p-go peer
>> > even if your device (in this case rtl8188s) only supports
>> > station mode...
>> >
>> How do I do this?
> "station mode"!
>
> The theory is: the p2p group owner (go) peer behaves pretty much
> like an Access Point. Hence, legacy devices  like the rtl81yySx
> can connect to it the same way like they would connect to an
> accesspoint or router.
>
> No "magic" driver or anything is needed. If you can connect to a
> run-of-the-mill protected AP, you can connect to a running 
> wifi-direct
> network.
>
>> >> Unfortunately the original Realtek driver from hp didn't
>> >> work with p2p too.
>> > Why, what happens in this case?
>> >
>>
>> I have downloaded the driver from:
>> 
>> http://www.realtek.com/downloads/downloadsView.aspx?Langid=1&PNid=48&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true#RTL8188SU
>
> this would also have worked with r8712u or r92su.
>
>> Installed and loaded the module 8712u.
>>
>> "iw list" doesn't list p2p-client or p2p-go.
>
> "station mode" "station mode" and again "station mode".
>
> "station mode" != "p2p-go" or "p2p-client". Just fire up your peer
> device and let the driver connect (either via WPA2-PSK or WPS). You
> don't need to deal with the console at all, this all can be done
> with the push of a GUI button (NetworkManager, wicd, ...).
>
> Remember: Do it like you simply want to connect to your AP.
> (no p2p magic!)
>

We need the "p2p magic" to develop a linux miracast sink.

>> I followed the thread.
>> It shows me that it makes no sense. I am a beginner and I only can
>> spent time for it if someone tells me for example: fill this module 
>> with
>> code for this specific function. I have good literature and I think 
>> I
>> can try to help but not lead something.
>
> Hey that's great, that's exactly what needs to be "done". ;-)
>

I don't know yet if I have the time to take part. But as I wrote I have 
a good book which describes in detail driver development for 2.6 kernel.

What do you think how many LOC have to been written?

Best regards
p2p

