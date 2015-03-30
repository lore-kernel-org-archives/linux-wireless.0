Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45566 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbbC3I05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:26:57 -0400
Message-ID: <1427704015.26117.6.camel@sipsolutions.net> (sfid-20150330_102702_389701_13098537)
Subject: Re: [PATCH] cfg/mac80211: add regulatory classes IE during TDLS
 setup
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Mon, 30 Mar 2015 10:26:55 +0200
In-Reply-To: <1426661168-11610-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426661168-11610-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-18 at 08:46 +0200, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Seems Broadcom TDLS peers (Nexus 5, Xperia Z3) refuse to allow TDLS
> connection when channel-switching is supported but the regulatory
> classes IE is missing from the setup request.
> Add a chandef to reg-class translation function to cfg80211 and use it
> to add the required IE during setup. For now add only the current
> regulatory class as supported - it is enough to resolve the
> compatibility issue.

Applied.

johannes

