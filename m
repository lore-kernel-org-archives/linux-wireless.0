Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbbCRRYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 13:24:13 -0400
Date: Wed, 18 Mar 2015 13:24:09 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Kyle McMartin <kyle@infradead.org>, linux-firmware@kernel.org,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: add firmware 10.2.4.45 as firmware-4.bin
Message-ID: <20150318172409.GC30928@merlin.infradead.org> (sfid-20150318_182417_479120_076D40E8)
References: <1426160112-4261-1-git-send-email-kvalo@qca.qualcomm.com>
 <20150313204730.GA30928@merlin.infradead.org>
 <87lhiuofx7.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87lhiuofx7.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 18, 2015 at 10:42:12AM +0200, Kalle Valo wrote:
> Kyle McMartin <kyle@infradead.org> writes:
> 
> > On Thu, Mar 12, 2015 at 01:35:12PM +0200, Kalle Valo wrote:
> >> This is the latest firmware from 10.2.4 firmware branch.
> >> 
> >> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> >
> > Pardon my ignorance... It looks like your driver needs more than just
> > firmware-4.bin... How are distros supposed to use this? Symlink it into
> > firmware.bin which it seems the driver looks for?
> 
> The current version of ath10k uses firmware-4.bin. Distros should not
> create symlinks or anything like that.
> 

Ah, groovy, ok, applied.

Thanks, Kyle
