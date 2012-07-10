Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab2GJQVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 12:21:14 -0400
Message-ID: <1341937273.4475.28.camel@jlt3.sipsolutions.net> (sfid-20120710_182117_390401_A6866055)
Subject: Re: [PATCH v3] minstrel_ht: enable frame aggregation for fixed rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org
Date: Tue, 10 Jul 2012 18:21:13 +0200
In-Reply-To: <1341854709-558-1-git-send-email-sylvain.roger.rieunier@gmail.com>
References: <1341854709-558-1-git-send-email-sylvain.roger.rieunier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 19:25 +0200, Sylvain Roger Rieunier wrote:
> When sample_idx is set to a value other than -1, it activates
> IEEE80211_TX_CTL_RATE_CTRL_PROBE flag. but this flag Disabled frame
> aggregation. to allow frame aggregation during fixed rate it is necessary to
> set max_tp_rate, max_tp_rate2, max_prob_rate instead of sample_idx.
> 
> Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>

Applied.

johannes

