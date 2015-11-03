Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55660 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbbKCKWF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 05:22:05 -0500
Message-ID: <1446546123.29010.13.camel@sipsolutions.net> (sfid-20151103_112210_319043_AF22A801)
Subject: Re: [PATCH] cfg80211: Enable update of properties for unassociated
 station.
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Ayala Beker <ayala.beker@intel.com>
Date: Tue, 03 Nov 2015 11:22:03 +0100
In-Reply-To: <1445588406-13416-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445588406-13416-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-23 at 11:20 +0300, Emmanuel Grumbach wrote:
> From: Ayala Beker <ayala.beker@intel.com>
> 
> Currently, cfg80211 rejects updates of AID and listen interval 
> parameters
> for existing entries. This information is known only at association 
> stage,
> and as a result it's impossible to update entries that were added
> unassociated.
> Fix this by allowing updates of these properies for stations that the
> driver (or mac80211) assigned unassociated state.
> 
Applied. Does the feature work completely with this patch?

johannes
