Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38354 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbbBXKuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:50:50 -0500
Message-ID: <1424775044.2192.30.camel@sipsolutions.net> (sfid-20150224_115112_131029_B51AB226)
Subject: Re: [PATCH] cfg80211: calls nl80211_exit on error
From: Johannes Berg <johannes@sipsolutions.net>
To: Junjie Mao <junjie_mao@yeah.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2015 11:50:44 +0100
In-Reply-To: <1422410606-6781-1-git-send-email-junjie_mao@yeah.net>
References: <1422410606-6781-1-git-send-email-junjie_mao@yeah.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-01-28 at 10:03 +0800, Junjie Mao wrote:
> nl80211_exit should be called in cfg80211_init if cfg80211_init succeeds but
> regulatory_init or create_singlethread_workqueue fails.

Applied, thanks.

johannes

