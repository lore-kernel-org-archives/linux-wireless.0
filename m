Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24825 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0DSP5R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 11:57:17 -0400
Subject: Re: [PATCH] mac80211: document IEEE80211_CONF_CHANGE_QoS
From: Pavel Roskin <proski@gnu.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	wey-yi.w.guy@intel.com, Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20100419092451.GA2696@dhcp-lab-161.englab.brq.redhat.com>
References: <1271338982-3157-1-git-send-email-sgruszka@redhat.com>
	 <1271495090.5157.4.camel@jlt3.sipsolutions.net>
	 <20100419092451.GA2696@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Mon, 19 Apr 2010 11:57:15 -0400
Message-Id: <1271692635.9026.17.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-19 at 11:24 +0200, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index dcf3c5f..97b2222 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -610,6 +610,7 @@ enum ieee80211_conf_flags {
>   * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
>   * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
>   * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
> + * @IEEE80211_CONF_CHANGE_QoS: Quality of service was enabled or disabled

Let's make it uppercase, please.  The actual code is already uppercase.

-- 
Regards,
Pavel Roskin
