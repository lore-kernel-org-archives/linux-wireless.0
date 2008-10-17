Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYJQP1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 11:27:47 -0400
Message-ID: <48F8AEF1.5030603@scherping.de> (sfid-20081017_172751_847109_E9F274F0)
Date: Fri, 17 Oct 2008 17:27:45 +0200
From: Richard Scherping <richard@scherping.de>
MIME-Version: 1.0
To: Frederik Himpe <fhimpe@telenet.be>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: iwlagn: associating with AP causes kernel hiccup
References: <gd5gs4$abi$1@ger.gmane.org> <1224104363.19219.30.camel@rc-desk>	<gd9v3f$3ft$1@ger.gmane.org> <gd9vpo$5ql$1@ger.gmane.org>
In-Reply-To: <gd9vpo$5ql$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>> When I associate with an AP, Linux 2.6.27 seems to "hang" for a few
>>>> seconds. During that time, all sound stops playing and keyboard and
>>>> mouse input is impossible.
>>
>> I'm using Mandriva 2009.0 x86_64 with wpa_supplicant and Mandriva's
>> wireless network configuration tool (drakroam).
>>
>> Actually I just found out that running # ifconfig wlan0 down
>> is enough to trigger the sound and mouse hanging for a few seconds.
> 
> And shortly after I wrote that, while associating while getting an IP 
> with dhclient when associating with a WPA encrypted AP, I got this 
> backtrace in my logs:
> [...]

I have a similar problem here. No crash up to now, but the very same "hang" for a few seconds on "ifconfig wlan0 down". Interestingly this does only happen after a normal boot - once I did a suspend and resume (S3), there is no hang anymore.

Hardware: Thinkpad T61p with Intel 4965 agn
Software: Debian Lenny x86_64 with vanilla 2.6.27 kernel

I remember having the same "hang" with older kernels, too.

Richard
