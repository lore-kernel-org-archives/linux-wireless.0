Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:33055 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759036AbXGaWhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 18:37:03 -0400
Message-ID: <46AFB98C.5020203@warmcat.com>
Date: Tue, 31 Jul 2007 23:37:00 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <46AF4889.4070902@warmcat.com> <200707311650.34795.IvDoorn@gmail.com> <200707311706.52073.IvDoorn@gmail.com> <46AF51C5.6070507@warmcat.com>
In-Reply-To: <46AF51C5.6070507@warmcat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

>> Ok, that was easier then I thought, rt2x00 2.0.5 _will_ contain the fix for this.
>> I just noticed that when the first and only interface is a monitor interface
>> the device was not being configured at all. This has now been fixed in rt2x00.git,
>> so it will be part of the 2.0.5 release later today. :)
> 
> Great, I will check for it on the serialmonkey site later and give it a go.

Ah I saw it went to git.kernel.org

Yes current rt2x00 git in there works fine for simple monitor mode
now... thanks a lot for your hard work!

-Andy
