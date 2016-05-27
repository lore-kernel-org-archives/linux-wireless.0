Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38584 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbcE0JHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 05:07:01 -0400
Date: Fri, 27 May 2016 14:36:49 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH v1] ath10k: Fix 10.4 extended peer stats update
Message-ID: <20160527090649.GA14846@atheros-ThinkPad-T61> (sfid-20160527_110708_041759_BC77C757)
References: <1462947870-17196-1-git-send-email-mohammed@qca.qualcomm.com>
 <6103547.auMgQrn60O@bentobox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6103547.auMgQrn60O@bentobox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 27, 2016 at 10:12:45AM +0200, Sven Eckelmann wrote:
> On Wednesday 11 May 2016 11:54:30 Mohammed Shafi Shajakhan wrote:
> >  #else
> > -static inline void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > -						 struct list_head *peer)
> > +static inline
> > +void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > +				   struct ath10k_fw_stats *stats);
> >  {
> >  }
> 
> Please remove the ";" for the "static inline" version. I can also
> submit a patch in case patches in ath.git/pending cannot be dropped
> anymore.

[shafi] thanks a lot fixed it ! sorry for the typo, sent a v2 for
the same, kindly review the same.

> 
> Kind regards,
> 	Sven


