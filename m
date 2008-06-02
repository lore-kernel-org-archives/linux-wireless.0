Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cssun.mathcs.emory.edu ([170.140.150.1]:35851 "EHLO
	cssun.mathcs.emory.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYFBAkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 20:40:13 -0400
Message-ID: <48434163.6060507@mathcs.emory.edu> (sfid-20080602_024021_165301_1EAF2E9F)
Date: Sun, 01 Jun 2008 20:40:03 -0400
From: Ken Mandelberg <km@mathcs.emory.edu>
MIME-Version: 1.0
To: Andreas Gnau <Rondom@Rondom.de>, linux-wireless@vger.kernel.org
Subject: Re: Is there any working 802.11N USB Nic?
References: <48419F4C.3010201@mathcs.emory.edu> <4841B245.10502@Rondom.de>
In-Reply-To: <4841B245.10502@Rondom.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andreas Gnau wrote, On 05/31/08 16:17:
> Ken Mandelberg schrieb:
>> I have an Airlink AWLL6080 (Ralink 2870). Is there any native work for
>> this chipset? I've tried ndiswrapper with an XP driver, but that only
>> connects in G mode.
>
> There are native drivers by Ralink for this chipset on their website.
> [1]. I don't know how well they work, though. Maybe the rt2x00-project
> will work on this once the current rt2x00 drivers are completely finished.
>
> NDISWrapper should also support 802.1n, so start a new thread in the
> NDISWrapper support forum [2], if you need additional help.
>
>
> [1] http://www.ralinktech.com/ralink/Home/Support/Linux.html
> [2]
> http://ndiswrapper.sourceforge.net/joomla/index.php?/component/option,com_fireboard/Itemid,34/

Andreas, thanks for the tips. I didn't know about the native Ralink 
driver for the 2870. I've gone ahead an built it and tested it.

The access point can be either in b/g/n mode or N only mode. In b/g/n 
mode it connects at G. In N only mode it doesn't connect.

iwconfig doesn't have a "modu" parameter for 11n, so I don't force a 
modulation from the Linux side. Should I be somehow?

