Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:47367 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966900Ab3DQWyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 18:54:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1366236369-543-1-git-send-email-bzhao@marvell.com>
Date: Wed, 17 Apr 2013 15:54:29 -0700
Cc: <linux-netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Paul Stewart <pstew@chromium.org>
Message-Id: <0156C538-4175-47E9-B667-C2127CBEF3EB@holtmann.org> (sfid-20130418_005442_476959_ED98DB90)
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> Add a "wireless/nl80211_iftype" entry in the net device sysfs
> file structure to indicate the mode of the wireless device so
> it can be discovered easily from userspace.

I do question a little bit the usefulness for this one. It would only work on netdev and on wdev devices. Using nl80211 to discover this information seems a lot better approach.

Regards

Marcel

