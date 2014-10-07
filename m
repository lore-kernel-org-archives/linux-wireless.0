Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45460 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaJGIqN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 04:46:13 -0400
Message-ID: <1412671568.1825.1.camel@jlt4.sipsolutions.net> (sfid-20141007_104616_669186_DC88C9DB)
Subject: Re: [PATCH 2/3] mac-hwsim:  add ethtool stats support.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Oct 2014 10:46:08 +0200
In-Reply-To: <1411680140-20208-2-git-send-email-greearb@candelatech.com> (sfid-20140925_232229_629577_D0F1A28C)
References: <1411680140-20208-1-git-send-email-greearb@candelatech.com>
	 <1411680140-20208-2-git-send-email-greearb@candelatech.com>
	 (sfid-20140925_232229_629577_D0F1A28C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-25 at 14:22 -0700, greearb@candelatech.com wrote:

> +static const char mac80211_hwsim_gstrings_stats[][ETH_GSTRING_LEN] = {
> +	"tx_pkts_nic",
> +	"tx_bytes_nic",
> +	"rx_pkts_nic",
> +	"rx_bytes_nic",
> +	"d_tx_dropped",
> +	"d_tx_failed",
> +	"d_ps_mode",
> +	"d_group",
> +	"d_tx_power",

What's that d_ prefix?

johannes

