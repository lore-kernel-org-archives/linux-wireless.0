Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2KIQ36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 11:29:58 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TWrSv-00008Z-D8
	for linux-wireless@vger.kernel.org; Fri, 09 Nov 2012 17:29:57 +0100
Message-ID: <1352478634.9238.15.camel@jlt4.sipsolutions.net> (sfid-20121109_173001_790198_22BEC96C)
Subject: Re: [PATCH] mac80211: remove unused tracepoint
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 17:30:34 +0100
In-Reply-To: <1352395291-6845-1-git-send-email-johannes@sipsolutions.net> (sfid-20121108_182108_712329_6E57FAAD)
References: <1352395291-6845-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121108_182108_712329_6E57FAAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-08 at 18:21 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Clearly the tracepoint drv_offchannel_tx was
> forgotten when that functionality was removed,
> remove it now.

Applied.

johannes

