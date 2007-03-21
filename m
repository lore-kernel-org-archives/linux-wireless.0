Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59620 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933161AbXCURW1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 13:22:27 -0400
Date: Wed, 21 Mar 2007 18:22:25 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] d80211: Remove curr_rates and fix related  concurrency issues
Message-ID: <20070321182225.0fbe8313@griffin.suse.cz>
In-Reply-To: <200703011200.23036.flamingice@sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
	<200703011200.23036.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 1 Mar 2007 12:00:18 -0500, Michael Wu wrote:
> This switches the code from curr_rates and num_curr_rates to directly using
> the mode and converts portions of the code to use pointers to rates instead
> of indices to refer to rates. Two new fields are introduced in struct
> ieee80211_conf which may replace the channel/frequency/channel_val/phymode
> fields in the future. The rate control is now cleared only when the
> operating channel is changed.

Looks correct to me. I'll apply it to my tree (if John isn't
faster :-)).

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
