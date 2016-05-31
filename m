Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1850 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbcEaGgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 02:36:52 -0400
From: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
	Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH v1] ath10k: Fix 10.4 extended peer stats update
Date: Tue, 31 May 2016 06:36:48 +0000
Message-ID: <1464676666571.16234@qti.qualcomm.com> (sfid-20160531_083706_527669_B7B38580)
References: <1462947870-17196-1-git-send-email-mohammed@qca.qualcomm.com>
 <6103547.auMgQrn60O@bentobox>,<20160527090649.GA14846@atheros-ThinkPad-T61>
In-Reply-To: <20160527090649.GA14846@atheros-ThinkPad-T61>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven / Kalle,

seems the change got merged in pending branch
https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=2a872321e07506e339fc1b3ca81aa3e88628cd6e

Request if you can send the patch to address this(incase the patch cannot be dropped)
and the v2 version cannot be picked

regards,
shafi
________________________________________
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Sent: 27 May 2016 14:36
To: Sven Eckelmann
Cc: Shajakhan, Mohammed Shafi (Mohammed Shafi); ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; Valo, Kalle
Subject: Re: [PATCH v1] ath10k: Fix 10.4 extended peer stats update

On Fri, May 27, 2016 at 10:12:45AM +0200, Sven Eckelmann wrote:
> On Wednesday 11 May 2016 11:54:30 Mohammed Shafi Shajakhan wrote:
> >  #else
> > -static inline void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > -                                            struct list_head *peer)
> > +static inline
> > +void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > +                              struct ath10k_fw_stats *stats);
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
>       Sven


