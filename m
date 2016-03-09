Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51277 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbcCIR1x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:27:53 -0500
Message-ID: <1457544468.2042.20.camel@sipsolutions.net> (sfid-20160309_182757_155267_92300C9A)
Subject: Re: [RFC v1] mac80211: Add support for per station rx stats
 histogram
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org, Anilkumar Kolli <akolli@qti.qualcomm.com>
Date: Wed, 09 Mar 2016 18:27:48 +0100
In-Reply-To: <20160309163038.GA9410@atheros-ThinkPad-T61>
References: <1457367809-13637-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1457424451.2283.2.camel@sipsolutions.net>
	 <20160308094250.GA3685@atheros-ThinkPad-T61>
	 <20160309163038.GA9410@atheros-ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-09 at 22:00 +0530, Mohammed Shafi Shajakhan wrote:
> 
> I had started studying(understand) your patch. Please
> let me know if you have already added support for the same
> in userspace as well, we like to use your changes and possibly
> add any changes that addresses rx_stats histogram as well

I had a very minimal file in iw, but that's all:

https://p.sipsolutions.net/744c0854bc02c95f.txt

johannes

