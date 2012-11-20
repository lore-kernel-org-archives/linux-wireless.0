Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:34812 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2KTAK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 19:10:57 -0500
Date: Mon, 19 Nov 2012 19:10:55 -0500 (EST)
Message-Id: <20121119.191055.647087881985988633.davem@davemloft.net> (sfid-20121120_011105_044289_A6CA0F60)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	johannes.berg@intel.com
Subject: Re: [PATCH] net: remove unnecessary wireless includes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1353099561-14339-1-git-send-email-johannes@sipsolutions.net>
References: <1353099561-14339-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 16 Nov 2012 21:59:21 +0100

> From: Johannes Berg <johannes.berg@intel.com>
> 
> The wireless and wext includes in net-sysfs.c aren't
> needed, so remove them.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thanks Johannes.
