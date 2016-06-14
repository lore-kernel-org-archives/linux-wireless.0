Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58580 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbcFNOMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:12:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems with mwifiex_pcie firmware activation
References: <20160614135015.GB4962@redhat.com>
Date: Tue, 14 Jun 2016 17:12:50 +0300
In-Reply-To: <20160614135015.GB4962@redhat.com> (Stanislaw Gruszka's message
	of "Tue, 14 Jun 2016 15:50:16 +0200")
Message-ID: <87r3bzkgf1.fsf@purkki.adurom.net> (sfid-20160614_161259_369949_9F242A22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Hence looks like forcing firmware upload somehow changed device, now it
> is capable to initialize. On my second system device is on pristine state
> and original problem is still reproducible. Do you have good solution
> for this problem ?

Did you see this:

mwifiex: fix racing condition when downloading firmware

https://patchwork.kernel.org/patch/9123771/

Though I have no idea if it helps in your case, just saw it on my queue
of patches to apply.

-- 
Kalle Valo
