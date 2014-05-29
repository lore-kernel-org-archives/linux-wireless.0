Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48243 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbaE2RAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 13:00:12 -0400
Date: Thu, 29 May 2014 12:56:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-05-28
Message-ID: <20140529165602.GB3542@tuxdriver.com> (sfid-20140529_190017_106361_C81143DC)
References: <1401287317.8146.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401287317.8146.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2014 at 04:28:37PM +0200, Johannes Berg wrote:
> John,
> 
> Since you asked ;-)
> 
> The remainder for -next right now is mostly fixes, and a handful of
> small new things like some CSA infrastructure, the regdb script mW/dBm
> conversion change and sending wiphy notifications.
> 
> Let me know if there are any issues.
> 
> johannes
> ---
> 
> The following changes since commit 67af9811539be83dbdc0739215d29af23c870405:
> 
>   cfg80211: allow RSSI compensation (2014-05-22 09:58:49 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git HEAD
> 
> for you to fetch changes up to d3a58df87a2e4c2301ac843604202d290a48440b:
> 
>   mac80211: set new interfaces as idle upon init (2014-05-28 16:22:49 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
