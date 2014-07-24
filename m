Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33045 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbaGXLMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 07:12:37 -0400
Message-ID: <1406200353.14675.18.camel@jlt4.sipsolutions.net> (sfid-20140724_131240_570044_05250D8D)
Subject: Re: [PATCHv2 2/2] mac80211: extend set_coverage_class signature
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Thu, 24 Jul 2014 13:12:33 +0200
In-Reply-To: <1406198362-4999-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123927_028644_16DA8409)
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406198362-4999-3-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140724_123927_028644_16DA8409)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:

> @@ -2950,7 +2951,7 @@ struct ieee80211_ops {
>  	int (*get_survey)(struct ieee80211_hw *hw, int idx,
>  		struct survey_info *survey);
>  	void (*rfkill_poll)(struct ieee80211_hw *hw);
> -	void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
> +	int (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);

This patch also needs to update all drivers ......

johannes

