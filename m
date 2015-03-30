Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57693 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbbC3I3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:29:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rt2800usb: check Autorun mode on FW load only once
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150319143249.GB2516@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Message-Id: <20150330082941.C461E1401B0@smtp.codeaurora.org> (sfid-20150330_102945_323924_F904474F)
Date: Mon, 30 Mar 2015 08:29:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Seems H/W report correctly firmware Autorun value only at initialization
> stage. When we close interface and open it again, Autorun value is 0 and
> we try to load firmware what kills the device. To fix clear
> REQUIRE_FIRMWARE firmware flag, to do not load firmware again, once we
> discover Autorun mode.
> 
> Reported-and-tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
