Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52365 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaEPPp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 11:45:27 -0400
Date: Fri, 16 May 2014 11:34:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Luca Coelho <luca@coelho.fi>, ath10k@lists.infradead.org,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	michal.kazior@tieto.com
Subject: Re: [PATCH] ath9k/ath10k: remove unnecessary channel_switch_beacon
 callbacks
Message-ID: <20140516153441.GD3431@tuxdriver.com> (sfid-20140516_174532_025508_7D3F4F0E)
References: <1400248534-16763-1-git-send-email-luca@coelho.fi>
 <87y4y13im2.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y4y13im2.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2014 at 05:26:13PM +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luciano Coelho <luciano.coelho@intel.com>
> >
> > The channel_switch_beacon callback is optional, so it doesn't have to
> > be defined if it's not going to do anything useful with it.  Both
> > ath9k and ath10k define the callback and just returns.  This commit
> > removes them.
> >
> > Cc: Michal Kazior <michal.kazior@tieto.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> >
> > I'm plannnig to remove the channel_switch_beacon callback (actually,
> > replace it with a more generic one that can be used for STA and other
> > iftypes too) and ath9k/ath10k are the only (non) users of it. ;)
> 
> John, I'm planning to take this as I think we will get less conflicts
> that way. But let me know if you want it instead.

No, that's good.  You will take the ath9k part too, right?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
