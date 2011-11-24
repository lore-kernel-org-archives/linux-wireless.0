Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1KXSsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:48:01 -0500
Subject: Re: [PATCH v2] iw: Support ht-capability overrides mask.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321653817-17871-1-git-send-email-greearb@candelatech.com> (sfid-20111118_230407_576638_574CBDCF)
References: <1321653817-17871-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111118_230407_576638_574CBDCF)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:47:57 +0100
Message-ID: <1322160477.5366.48.camel@jlt3.sipsolutions.net> (sfid-20111124_194805_615966_4604AD36)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 14:03 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Let user know which capabilities are supported.

> +/* 802.11n HT capability AMPDU settings (for ampdu_params_info) */
> +#define IEEE80211_HT_AMPDU_PARM_FACTOR          0x03
> +#define IEEE80211_HT_AMPDU_PARM_DENSITY         0x1C

This patch doesn't compile after I replace nl80211.h. nl80211.h is
supposed to be a true copy of the kernel's file, not some randomly
hacked up version. I can't apply this.

johannes

