Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbcFOHtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2016 03:49:01 -0400
Date: Wed, 15 Jun 2016 09:48:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20160615074855.GA2663@redhat.com> (sfid-20160615_094906_625981_6E99B33B)
References: <20160614135015.GB4962@redhat.com>
 <87r3bzkgf1.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r3bzkgf1.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2016 at 05:12:50PM +0300, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > Hence looks like forcing firmware upload somehow changed device, now it
> > is capable to initialize. On my second system device is on pristine state
> > and original problem is still reproducible. Do you have good solution
> > for this problem ?
> 
> Did you see this:
> 
> mwifiex: fix racing condition when downloading firmware
> 
> https://patchwork.kernel.org/patch/9123771/
> 
> Though I have no idea if it helps in your case, just saw it on my queue
> of patches to apply.

Patch did not help. No wonder since it fixes SDIO and I have problem
with PCIE device :-)

Stanislaw
