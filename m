Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59016 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2FHRsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:48:03 -0400
Date: Fri, 8 Jun 2012 13:38:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: print info when disabling HT
Message-ID: <20120608173804.GB13889@tuxdriver.com> (sfid-20120608_194807_552329_B7425ACE)
References: <1338962733.4513.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338962733.4513.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 06, 2012 at 08:05:33AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Make mac80211 print a message when it disables
> HT due to the connection using WEP/TKIP or due
> to the AP not supporting WMM/QoS.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> Did this slip through? :-)

I've got it on the wireless-next side.

commit 1c4cb928e1b7c6ad30a9b7d3e720f26156d92925
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed May 30 15:57:00 2012 +0200

    mac80211: print info when disabling HT
    
    Make mac80211 print a message when it disables
    HT due to the connection using WEP/TKIP or due
    to the AP not supporting WMM/QoS.
    
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
