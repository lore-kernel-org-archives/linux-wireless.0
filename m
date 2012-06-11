Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2FKO6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 10:58:11 -0400
Message-ID: <1339426690.4520.28.camel@jlt3.sipsolutions.net> (sfid-20120611_165843_901602_FB3D8765)
Subject: Re: [PATCH v2] minstrel_ht: enable frame aggregation for fixed rate
From: Johannes Berg <johannes@sipsolutions.net>
To: sylvain_gmail <sylvain.roger.rieunier@gmail.com>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
Date: Mon, 11 Jun 2012 16:58:10 +0200
In-Reply-To: <4FD605DD.9020800@gmail.com> (sfid-20120611_165113_242964_A25B4D05)
References: <1339141443-10135-1-git-send-email-sylvain.roger.rieunier@gmail.com>
	 <1339229456.4539.9.camel@jlt3.sipsolutions.net>
	 <4FD605DD.9020800@gmail.com> (sfid-20120611_165113_242964_A25B4D05)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 16:51 +0200, sylvain_gmail wrote:
> Dear Johannes and Felix ,
> 
> Here is the description of my patch that I can offer :
> 
> "After trying to fix rate control with minstrel_ht. I realized that,
> that fix rate was not allowed to make frames aggregation.
> This was due to enable  IEEE80211_TX_CTL_RATE_CTRL_PROBE flag of the
> ieee80211_tx_info structure. 
> Because when IEEE80211_TX_CTL_RATE_CTRL_PROBE flag is set frame
> aggregation is disabled.
>  So instead of used sample_idx, who set
> IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. I suggest using max_tp_rate and
> max_tp_rate2 which do not disabled frame aggregation." 
> 
> what is your opinion?

Makes more sense than before, but isn't really a viable changelog entry
yet :)

johannes

