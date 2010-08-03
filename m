Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:52651 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab0HCMnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 08:43:42 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi connection problems
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	<1279917523.10769.1.camel@wwguy-huron>
	<1280135867.3693.5.camel@jlt3.sipsolutions.net>
	<87mxtd5xlq.fsf@sycorax.lbl.gov>
	<1280212629.19098.0.camel@jlt3.sipsolutions.net>
	<87bp9l6f4k.fsf@sycorax.lbl.gov>
	<1280746705.3923.11.camel@jlt3.sipsolutions.net>
	<878w4pvx5e.fsf@sycorax.lbl.gov>
	<1280766201.24503.0.camel@jlt3.sipsolutions.net>
	<87aap4z70b.fsf@sycorax.lbl.gov>
	<1280817596.3874.0.camel@jlt3.sipsolutions.net>
Date: Tue, 03 Aug 2010 05:43:38 -0700
In-Reply-To: <1280817596.3874.0.camel@jlt3.sipsolutions.net> (message from
	Johannes Berg on Tue, 03 Aug 2010 08:39:56 +0200)
Message-ID: <87mxt3n9xh.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Yes, thank you, but it's very strange. But it's probably ok, let's
> remove the call then, it wasn't there before. Want to post a patch
> yourself?

btw, the old code had this comment

 /* We avoid iwl_commit_rxon here to commit the new filter flags
  * since mac80211 will call ieee80211_hw_config immediately.
  * (mc_list is not supported at this time). Otherwise, we need to
  * queue a background iwl_commit_rxon work.
  */

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
