Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45543 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbbC3ITa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:19:30 -0400
Message-ID: <1427703568.26117.4.camel@sipsolutions.net> (sfid-20150330_101934_365926_3EA491FC)
Subject: Re: [PATCH] mac80211: stop scan before connection
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Date: Mon, 30 Mar 2015 10:19:28 +0200
In-Reply-To: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 19:58 +0200, Emmanuel Grumbach wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> Stop scan before authentication or association to make sure
> that nothing interferes with connection flow.
> 
> Currently mac80211 defers RX auth and assoc packets (among other ones)
> until after the scan is complete, so auth during scan is likely to fail
> if scan took too much time.

Applied.

johannes

