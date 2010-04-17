Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab0DQJE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 05:04:57 -0400
Subject: Re: [PATCH v2 resend 1/3] mac80211: explicitly disable/enable QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
In-Reply-To: <1271338982-3157-1-git-send-email-sgruszka@redhat.com>
References: <1271338982-3157-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Apr 2010 11:04:50 +0200
Message-ID: <1271495090.5157.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-15 at 15:43 +0200, Stanislaw Gruszka wrote:

> @@ -609,6 +613,7 @@ enum ieee80211_conf_changed {
>  	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
>  	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
>  	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
> +	IEEE80211_CONF_CHANGE_QOS		= BIT(9),

Please send a doc change patch for this.

johannes

