Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49982 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbcFBOX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:23:57 -0400
Date: Thu, 2 Jun 2016 19:52:32 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: remove duplicate and unused rx rate flags
Message-ID: <20160602142232.GA4729@atheros-ThinkPad-T61> (sfid-20160602_162401_642202_97E12465)
References: <1464852235-13110-1-git-send-email-mohammed@qca.qualcomm.com>
 <87a8j3zout.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a8j3zout.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 02, 2016 at 01:45:15PM +0000, Valo, Kalle wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:
> 
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >
> > All these flags are not used and their use is completely
> > covered by 'ath10k_hw_rate_ofdm', 'ath10k_hw_rate_cck',
> > and RX_PPDU_START_RATE_FLAG
> >
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > Patchwork-Id: 9129361
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> I guess you took this patch from the pending branch? :) The Patchwork-Id
> line is something which my script adds for patches in the pending
> branch, and removes them before applying them to ath-next, but this line
> should not be visible when submitting patches.
>
[shafi] yes i am sorry :-( will send v3.

regards,
shafi
