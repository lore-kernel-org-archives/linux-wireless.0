Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48268 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbbHMNKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 09:10:52 -0400
Message-ID: <1439471447.2114.29.camel@sipsolutions.net> (sfid-20150813_151119_817906_9F6938CE)
Subject: Re: [PATCH] mac80211_hwsim: unregister genetlink family properly
From: Johannes Berg <johannes@sipsolutions.net>
To: Su Kang Yin <cantona@cantona.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Aug 2015 15:10:47 +0200
In-Reply-To: <1438937650-361-1-git-send-email-cantona@cantona.net> (sfid-20150807_105718_504752_78954283)
References: <1438937650-361-1-git-send-email-cantona@cantona.net>
	 (sfid-20150807_105718_504752_78954283)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-08-07 at 16:54 +0800, Su Kang Yin wrote:
> During hwsim_init_netlink(), we should call genl_unregister_family()
> if failed on netlink_register_notifier() since the genetlink is
> already registered.
> 
Applied.

johannes
