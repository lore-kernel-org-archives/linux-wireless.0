Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28626 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbXEOGxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2007 02:53:19 -0400
Subject: RE: [PATCH] mac80211: fail back to use associate from reassociate
From: Zhu Yi <yi.zhu@intel.com>
To: Sandesh Goel <sgoel@marvell.com>
Cc: Jouni Malinen <jkm@devicescape.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <9C9B2DC3D78A6142AC8D10C89669528603F63B68@msiexch01.marvell.com>
References: <20070509054152.GA30839@mail.intel.com>
	 <20070509152855.GB941@devicescape.com>
	 <1178767250.3045.36.camel@debian.sh.intel.com>
	 <9C9B2DC3D78A6142AC8D10C89669528603F63B68@msiexch01.marvell.com>
Content-Type: text/plain
Date: Tue, 15 May 2007 14:52:45 +0800
Message-Id: <1179211965.3045.170.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-05-14 at 22:41 -0700, Sandesh Goel wrote:
> Therefore, the AP should not return the said error code
> (WLAN_STATUS_REASSOC_NO_ASSOC) unless it has checked (using some inter
> AP protocol) that no other AP in the ESS has an existing association
> with the requesting STA. If the AP is returning the error without
> doing this check, I would think that it is an AP bug. 

The AP was the only one in the ESS, so it should be OK.

> It would be interesting to know which AP behaves in this way and
> whether
> is really does the check correctly or not. Note that the AP itself
> having rebooted shouldn't cause this error code to be returned, which
> is what I found strange. 

Do you mean the AP should remember all its associated STAs before it
rebooted?

Thanks,
-yi
