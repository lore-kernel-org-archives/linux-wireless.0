Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48938 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab3BLRpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 12:45:36 -0500
Date: Tue, 12 Feb 2013 12:37:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2012-02-12
Message-ID: <20130212173750.GC2086@tuxdriver.com> (sfid-20130212_184540_893695_97FC13DF)
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 12, 2013 at 05:01:31PM +0100, Johannes Berg wrote:
> John,
> 
> We continue work on our new driver, but I also have a WoWLAN and AP mode
> improvement for the previous driver and a change to use threaded
> interrupts to prepare us for working with non-PCIe devices.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> 
> 
> The following changes since commit 8457703f1e86aaf0f134402dd1e09e1f13e65222:
> 
>   ath6kl: provide 64-bit per-station byte counters (2013-02-11 15:34:58 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 36eed56a8f7e1bd7fb5014ea0e702708e1702f30:
> 
>   iwlwifi: mvm: beautify code in rx_handlers (2013-02-12 16:52:26 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
