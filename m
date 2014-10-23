Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57199 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbaJWSmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 14:42:38 -0400
Message-ID: <1414089755.29820.1.camel@jlt4.sipsolutions.net> (sfid-20141023_204241_029370_F782E2FD)
Subject: Re: [PATCH] mac80211: expose TDLS-initiator value to low level
 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Thu, 23 Oct 2014 20:42:35 +0200
In-Reply-To: <1413970368-5777-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1413970368-5777-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-22 at 12:32 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Some drivers need to know which station is the TDLS link initiator.
> Expose this value via the mac80211 ieee80211_sta structure.

Applied.

johannes

