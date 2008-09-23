Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58822
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753773AbYIWBlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 21:41:37 -0400
Date: Mon, 22 Sep 2008 18:41:25 -0700 (PDT)
Message-Id: <20080922.184125.147225416.davem@davemloft.net> (sfid-20080923_034142_081472_3834D6E2)
To: tomas.winkler@intel.com
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	emmanuel.grumbach@intel.com
Subject: Re: [PATCH 1/1] iwlwifi 2.6.27: send all the calibration results
 instead of the last one only
From: David Miller <davem@davemloft.net>
In-Reply-To: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com>
References: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>
Date: Tue, 23 Sep 2008 03:14:28 +0300

> Note this patch effects only 5000 HW (nor 3946 or 4965) so doesn't
> resolve or create any regression. Anyhow it was thoroughly tested.

You haven't learned the first time.

This kind of stuff is not appropriate outside of the merge window, I'm
not pulling this change into my tree if John tries to send it to me.
