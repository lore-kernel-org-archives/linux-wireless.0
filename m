Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbcBPJ3G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 04:29:06 -0500
Message-ID: <1455614941.2723.3.camel@sipsolutions.net> (sfid-20160216_102910_929650_CC683947)
Subject: Re: [PATCH] mac80211: allow not sending MIC up from driver for HW
 crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Tue, 16 Feb 2016 10:29:01 +0100
In-Reply-To: <1455614328-12528-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1455614328-12528-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-16 at 11:18 +0200, Emmanuel Grumbach wrote:
> 
> @@ -1084,13 +1086,12 @@ enum mac80211_rx_flags {
>  	RX_FLAG_MACTIME_END		= BIT(21),
>  	RX_FLAG_VHT			= BIT(22),
>  	RX_FLAG_LDPC			= BIT(23),
> -	RX_FLAG_ONLY_MONITOR		= BIT(24),
> -	RX_FLAG_SKIP_MONITOR		= BIT(25),

what?

johannes
