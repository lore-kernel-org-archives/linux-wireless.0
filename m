Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52975 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbbGQNp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 09:45:26 -0400
Message-ID: <1437140724.1933.23.camel@sipsolutions.net> (sfid-20150717_154529_397949_D60474E3)
Subject: Re: [PATCH 05/10] mac80211: clear local->suspended before calling
 drv_resume()
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Fri, 17 Jul 2015 15:45:24 +0200
In-Reply-To: <1436359312-26533-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144255_488596_A0AA8758)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-6-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144255_488596_A0AA8758)
Content-Type: text/plain
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied 1,3-5 to mac80211-next.

johannes
