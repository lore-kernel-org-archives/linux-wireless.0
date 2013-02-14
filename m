Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935113Ab3BNXz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 18:55:29 -0500
Message-ID: <1360886123.9475.1.camel@jlt4.sipsolutions.net> (sfid-20130215_005547_546265_54A926F2)
Subject: Re: [PATCH] mac80211_hwsim: ask mac80211 to reserve space for
 chanctx.drv_priv
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Fri, 15 Feb 2013 00:55:23 +0100
In-Reply-To: <1360882994-13250-1-git-send-email-karl@eleaks.org> (sfid-20130215_000755_381127_1DBABC17)
References: <1360882994-13250-1-git-send-email-karl@eleaks.org>
	 (sfid-20130215_000755_381127_1DBABC17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 00:03 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Otherwise memory corruption occurs when using channel contexts (ATM when
> param 'channel' > 1).

Heh, and I've been using it forever with that in kvm, I guess it depends
on the allocator (and the resulting ksize() of the object).

Applied, thanks!

johannes

