Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31904 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab0IFI4W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 04:56:22 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 01:56:16 -0700
Date: Mon, 6 Sep 2010 14:27:25 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Update AR7010 firmwares
Message-ID: <20100906085725.GA12370@vmraj-lnx.users.atheros.com>
References: <1283530280-6263-1-git-send-email-rmanoharan@atheros.com>
 <1283642530.15689.2.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1283642530.15689.2.camel@i7.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes David. These changes are compatible with older kernels.

Thanks,
Rajkumar

On Sun, Sep 05, 2010 at 04:52:10AM +0530, David Woodhouse wrote:
> On Fri, 2010-09-03 at 17:11 +0100, Rajkumar Manoharan wrote:
> > AR7010 firmwares are patched to change EP3 & EP4
> > from Interrupt to Bulk type.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> > ---
> >  ar7010.fw     |  Bin 70608 -> 70624 bytes
> >  ar7010_1_1.fw |  Bin 70608 -> 70624 bytes
> >  2 files changed, 0 insertions(+), 0 deletions(-) 
> 
> Is that a compatible change which will continue to work with old
> kernels?
> 
> If not, the firmware needs a new filename -- think of it like an soname
> on userspace libraries.
> 
> -- 
> dwmw2
> 
