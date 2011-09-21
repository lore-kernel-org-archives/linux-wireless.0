Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:07:43 -0400
Subject: Re: [RFC 5/5] mac80211: send data directly to TDLS peers
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-6-git-send-email-arik@wizery.com> (sfid-20110915_123146_593683_1FBA16D4)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-6-git-send-email-arik@wizery.com>
	 (sfid-20110915_123146_593683_1FBA16D4)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 14:07:39 +0200
Message-ID: <1316606859.3940.32.camel@jlt3.sipsolutions.net> (sfid-20110921_140752_985314_792B98DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
> When a station is determined to be a TDLS peer, send the data directly,
> bypassing the AP.
> 
> In addition, allow data to be received directly from TDLS peers.

We talked a bit about this but I forgot -- did you want to add the
buffering here?

johannes

