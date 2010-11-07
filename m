Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49775 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0KGDot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Nov 2010 23:44:49 -0400
Received: by ywc21 with SMTP id 21so2824176ywc.19
        for <linux-wireless@vger.kernel.org>; Sat, 06 Nov 2010 20:44:49 -0700 (PDT)
Message-ID: <4CD620C7.20308@lwfinger.net>
Date: Sat, 06 Nov 2010 22:45:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: htl10@users.sourceforge.net,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	seno <senada@t-online.de>
Subject: Re: [PATCH 9/9] rtl8187: restore anaparam registers after reset with
 8187B
References: <20101106230731.3524ae6b@mandriva.com.br>	<873714.85933.qm@web29507.mail.ird.yahoo.com> <20101107012832.6b2f874a@mandriva.com.br>
In-Reply-To: <20101107012832.6b2f874a@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2010 10:28 PM, Herton Ronaldo Krzesinski wrote:
> Em Sun, 7 Nov 2010 01:29:30 +0000 (GMT)
> Hin-Tak Leung <htl10@users.sourceforge.net> escreveu:
> 
>> --- On Sun, 7/11/10, Herton Ronaldo Krzesinski
>> <herton@mandriva.com.br> wrote:
>>
>> <snipped>
>>> It's strange that with or without the patch you get too low
>>> transfer
>>> values. In this case we should have another bug with your
>>> device. I don't
>>> know now what could be happening, but first thing that I
>>> thought is that
>>> this could be related to antenna selection (and I'm curious
>>> about analog
>>> parameters on the eeprom of device too). Please try
>>> following debug patch
>>> and post results (also post what type of RTL8187 the driver
>>> detects/prints
>>> on kernel log too, may help). And if is something related
>>> to antena selection,
>>> try change the if condition on the patch and see if that
>>> helps.
>> <snipped>
>>
>> That reminds me - I have an "antenna diversity" patch dated "April 9
>> 2009" on my desktop which I think I got off linux-wireless from
>> somebody with a dual-antenna device, derived from scavenging from the
>> vendor driver, I think, that we are supposed to do something about
>> but I certainly haven't done anything about it. Did either/any of you
>> look at that and/or remember having done anything about that patch? 
> 
> Do you have any pointer to it? (I can't find in the archives in April
> 9 2009). Never saw it, if was posted in the mailing list certainly
> missed it (and probably I was not in CC).

There is a reference to it at
http://www.spinics.net/lists/linux-wireless/msg31345.html. The patches were
never done quite right, and I do not remember testing. As I have only 1 antenna
(I think), it likely would not have affected the results.

Larry

