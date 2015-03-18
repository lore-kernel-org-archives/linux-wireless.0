Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbbCRMwc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:52:32 -0400
Date: Wed, 18 Mar 2015 13:48:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
Message-ID: <20150318124857.GA2121@redhat.com> (sfid-20150318_135255_611261_BA74944B)
References: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
 <20150316160652.789B313FBE6@smtp.codeaurora.org>
 <20150316164100.GA6208@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150316164100.GA6208@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2015 at 05:41:00PM +0100, Sebastian Andrzej Siewior wrote:
> * Kalle Valo | 2015-03-16 16:06:52 [+0000]:
> 
> >Thanks, 3 patches applied to wireless-drivers-next.git:
> 
> Thanks. Do you guys have any kind of further documentation? Where did 
There is doc describing MAC registers, it was provided under NDA to
rt2x00 developers. However you can google for "MT7620_ProgrammingGuide.pdf"
and get similar doc. It does not describe radio/broadband registers, we
only have vendor driver as source for those.

> you get the firmware from?
linux-firmware contains firmware posed by Ralink developers. Vendor
driver ships new firmware versions, it is binnary file common/rt2870.bin

> Is it the vendor driver in better shape and
> firmware excracted from header files?
For some users vendor driver works better.

Stanislaw

