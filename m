Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2GQJ30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 05:29:26 -0400
Message-ID: <1342517275.5011.7.camel@jlt3.sipsolutions.net> (sfid-20120717_112930_372380_403A5DFD)
Subject: Re: [PATCH] mac80211: Fix tx-mgmt cookie value being left
 uninitialized.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1342456612-11706-1-git-send-email-cavallar@lri.fr>
References: <1342456612-11706-1-git-send-email-cavallar@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jul 2012 11:27:55 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-16 at 18:36 +0200, Nicolas Cavallari wrote:
> commit "mac80211: unify SW/offload remain-on-channel"
> moved the cookie assignment from ieee80211_mgmt_tx()
> to ieee80211_start_roc_work().  But the latter is only
> called where offchannel is needed.  If offchannel isn't
> needed/used, a uninitialized cookie value would be returned
> to userspace.
> 
> This patch sets the cookie value when offchannel isn't used.

Applied, thanks!

johannes

