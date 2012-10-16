Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2JPSYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:24:47 -0400
Message-ID: <1350411921.10177.7.camel@jlt4.sipsolutions.net> (sfid-20121016_202450_552248_52723726)
Subject: Re: [PATCH] mac80211: unbind the vif from the channel context in
 suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 16 Oct 2012 20:25:21 +0200
In-Reply-To: <1350371890-11488-1-git-send-email-johannes@sipsolutions.net> (sfid-20121016_091741_257784_F88E1821)
References: <1350371890-11488-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121016_091741_257784_F88E1821)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-10-16 at 09:18 +0200, Johannes Berg wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> The channel was still bound to the channel context when it
> was removed. Fix that.

Since I haven't sent a pull request for the broken code yet, I'm going
to roll this into the mac80211 channel context commit. This means
rebasing mac80211-next.

johannes

