Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1CKIq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 03:46:26 -0500
Subject: RE: [PATCH 00/31] wireless: Marvell mwifiex driver for SD8787
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>, Greg KH <greg@kroah.com>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307F51C401C@SC-VEXCH1.marvell.com>
References: <1291253516-17815-1-git-send-email-bzhao@marvell.com>
	 <1291380780.3499.119.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307F51C401C@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 09:45:15 +0100
Message-ID: <1299833115.3755.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> During the past 3 months, we have made 56 mwifiex patches (listed
> below) since the initial mwifiex driver submission. Most of these
> patches address the above issues; and the ioctl multiple abstraction
> layers and the static forward declarations as you commented in another
> e-mail. Some other patches are for code cleanups, mainly coding style.

I've only loosely followed these patches, but I'm sure the driver is in
*much* better shape now. If you think you're done, it'd be worthwhile to
just resubmit the entire driver in its new version.

johannes

