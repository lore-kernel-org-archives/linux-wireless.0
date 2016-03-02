Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44189 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbcCBMYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 07:24:23 -0500
Message-ID: <1456921458.2157.2.camel@sipsolutions.net> (sfid-20160302_132435_079829_18E8BE14)
Subject: Re: [PATCH] mac80211_hwsim: Set global RRM capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Date: Wed, 02 Mar 2016 13:24:18 +0100
In-Reply-To: <1456392253-16972-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456392253-16972-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-02-25 at 11:24 +0200, Emmanuel Grumbach wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> Allow publishing RRM capabilities for features that are not
> HW dependent.

Actually, come to think of it, why don't we do this in mac80211 rather
than the drivers?

The only capability it requires is inserting the IEs, and that's
handled in mac80211.

johannes
