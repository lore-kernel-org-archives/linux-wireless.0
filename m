Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37886 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbbCPQGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:06:53 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/3] rt2x00usb: initialize the read value in case of failure
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426170946-13918-1-git-send-email-bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-Id: <20150316160652.789B313FBE6@smtp.codeaurora.org> (sfid-20150316_170656_558354_25F9EB63)
Date: Mon, 16 Mar 2015 16:06:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> My understanding ist that rt2x00usb_register_read() is void and so the
> reader is unaware of read errors and assumes that whatever was on the
> stack as it was about to read.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks, 3 patches applied to wireless-drivers-next.git:

e4fcfaf802bf rt2x00usb: initialize the read value in case of failure
92d5e2456d39 rt2x00usb: check USB's request error code in rt2800usb_autorun_detect()
7daa54b747dd rt2x00usb: drop rt2x00usb_disable_radio() from rt2800usb_disable_radio()

Kalle Valo
