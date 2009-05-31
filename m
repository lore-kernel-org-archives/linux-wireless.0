Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9935 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307AbZEaCZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 22:25:12 -0400
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090526222433.GA23972@bombadil.infradead.org>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <20090526222433.GA23972@bombadil.infradead.org>
Content-Type: text/plain
Date: Sun, 31 May 2009 10:17:07 +0800
Message-Id: <1243736227.3623.180.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-27 at 06:24 +0800, Luis R. Rodriguez wrote:
> On Thu, May 21, 2009 at 10:18:58AM +0800, Zhu Yi wrote:
> > The iwmc3200wifi driver
> > currently supports IEEE 802.11a/b/g (draft N is still working in progress)
> > in managed and ad-hoc modes.
> 
> BTW how many streams will this device have?

The current (upcoming) one is an AGN with an SDIO interface. But the
cores are going to be reused in the future.

Thanks,
-yi

