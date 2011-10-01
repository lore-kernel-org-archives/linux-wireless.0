Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33188 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab1JAXX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 19:23:28 -0400
Message-ID: <4E87A110.6030201@emobix.co.uk> (sfid-20111002_012333_473731_504390E3)
Date: Sun, 02 Oct 2011 00:24:00 +0100
From: Ian Jeffray <ian@emobix.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E8757A8.1010302@emobix.co.uk> <4E87609E.5030002@lwfinger.net> <201110012054.42461.chunkeey@googlemail.com> <4E8768EC.9040900@lwfinger.net>
In-Reply-To: <4E8768EC.9040900@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2011 20:24, Larry Finger wrote:

> BTW, netperf shows that r8712u can transmit at ~80 and receive at ~60
> Mbps when connected to a 270 Mbps AP. As Realtek lists this as capable
> of 150 Mbps, x86_64 is getting the max transmit rate that we might expect.

On x86 32bit, I get a sustained 94Mbps transmit to a 300Mbps AP, which
seems pretty good - why I'm keen to get this to work for my ARM target.


> @Ian: Ali Bahar submitted a number of patches to GregKH updating the
> driver to the latest Realtek version. As the git repo is not available
> due to kernel.org, and I have not found an alternate location that Greg
> has established, I am attaching them here.

Many thanks for that.

I've applied all Ali's patches you attached, and tried on my Blackfin
host, both with and without musb DMA enabled - no improvement, sadly.

I had also tried the 2.6.6.0.20110401 driver from Realtek without
any change in behaviour.

May try adding some liberal debug trace next, to compare to operation
on x86.


Regards,

Ian.

