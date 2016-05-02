Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58524 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbcEBVX5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 17:23:57 -0400
Message-ID: <1462224233.5898.22.camel@sipsolutions.net> (sfid-20160502_232400_322696_1E959051)
Subject: Re: [PATCH] mac80211:  add vht cap decode to debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 02 May 2016 23:23:53 +0200
In-Reply-To: <1462223956-23384-1-git-send-email-greearb@candelatech.com>
References: <1462223956-23384-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +			if (vhtc->cap & IEEE80211_VHT_CAP_ ## a)+		
> 		p += scnprintf(p, sizeof(buf) + buf
> - p, \
> +					       "\t\t%s\n", b);	

Why not use #a instead of b?

> +		PFLAG(MAX_MPDU_LENGTH_3895, "MAX-MPDU-3895");


Makes that a bit longer in the printout, but makes the code shorter.

johannes
