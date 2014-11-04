Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52695 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbaKDKWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 05:22:14 -0500
Message-ID: <1415096517.2064.15.camel@sipsolutions.net> (sfid-20141104_112225_852460_99485AFC)
Subject: Re: [PATCH] mac80211: replace restart_complete() with
 reconfig_complete()
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Tue, 04 Nov 2014 11:21:57 +0100
In-Reply-To: <1415094234-22006-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1415094234-22006-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 11:43 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Drivers might want to know also when mac80211 has
> completed reconfiguring after resume (e.g. in order
> to know when frames can be passed to mac80211).
> 
> Rename restart_complete() to a more-generic reconfig_complete(),
> and add a new enum to indicate the reconfiguration type.
> 
> Update the current users with the new prototype.

Applied.

johannes

