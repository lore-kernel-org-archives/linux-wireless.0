Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37213 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaETNVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 09:21:52 -0400
Message-ID: <1400592103.4474.5.camel@jlt4.sipsolutions.net> (sfid-20140520_152155_280183_265067AA)
Subject: Re: [PATCH 1/7] cfg80211: don't set reg timeout for user-handled
 hint
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Tue, 20 May 2014 15:21:43 +0200
In-Reply-To: <1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1399798250-20987-2-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-05-11 at 11:50 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Otherwise every "indoor" setting by usermode will cause a regdomain reset.

Applied this one :)

johannes

