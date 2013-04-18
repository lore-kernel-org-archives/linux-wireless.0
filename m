Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:40194 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969Ab3DRTDU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 15:03:20 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Paul Stewart <pstew@chromium.org>
Date: Thu, 18 Apr 2013 12:03:02 -0700
Subject: RE: [PATCH] net-sysfs: Add entry for nl80211 interface type
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E05713A@SC-VEXCH1.marvell.com> (sfid-20130418_210325_366221_400D122D)
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
 <0156C538-4175-47E9-B667-C2127CBEF3EB@holtmann.org>
In-Reply-To: <0156C538-4175-47E9-B667-C2127CBEF3EB@holtmann.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

> Hi Bing,
> 
> > Add a "wireless/nl80211_iftype" entry in the net device sysfs
> > file structure to indicate the mode of the wireless device so
> > it can be discovered easily from userspace.
> 
> I do question a little bit the usefulness for this one.
> It would only work on netdev and on wdev devices.

It's true. That's why the new sysfs entry is added in the 'wireless' placeholder.

/sys/class/net/ethX/wireless/

For non-wireless dev, this won't apply.

Thanks,
Bing

> Using nl80211 to discover this information seems a lot better approach.
> 
> Regards
> 
> Marcel

