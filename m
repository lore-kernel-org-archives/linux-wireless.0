Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46823 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbbFQIvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:51:55 -0400
Message-ID: <1434531113.1884.14.camel@sipsolutions.net> (sfid-20150617_105159_162229_48A2A316)
Subject: Re: [PATCH] mac80211: define TDLS wider BW support bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Wed, 17 Jun 2015 10:51:53 +0200
In-Reply-To: <1433958179-28051-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1433958179-28051-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 20:42 +0300, Emmanuel Grumbach wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Allow a device to specify support for the TDLS wider-bandwidth feature.
> Indicate this support during TDLS setup in the ext-capab IE and set an
> appropriate station flag when our TDLS peer supports it.
> This feature gives TDLS peers the ability to use a wider channel than
> the base width of the BSS. For instance VHT capable TDLS peers connected
> on a 20MHz channel can extend the channel to 80MHz, if regulatory
> considerations allow it.
> 
> Do not cap the bandwidth of such stations by the current BSS channel width
> in mac80211.

Applied.

johannes

