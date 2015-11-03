Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55454 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbbKCJla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:41:30 -0500
Message-ID: <1446543687.29010.8.camel@sipsolutions.net> (sfid-20151103_104821_493949_A9FEF810)
Subject: Re: [PATCH 04/10] mac80211: call drv_stop only if driver is started
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Tue, 03 Nov 2015 10:41:27 +0100
In-Reply-To: <1445763582-11421-4-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1445763582-11421-4-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-25 at 10:59 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> If drv_start() fails during hw_restart, all the running
> interfaces are being closed/stopped, which results in
> drv_stop() being called, although the driver was never
> started successfully.
> 
Applied.

johannes
