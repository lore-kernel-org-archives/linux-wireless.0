Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35951 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3HPWaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:30:15 -0400
Date: Fri, 16 Aug 2013 14:49:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-08-16
Message-ID: <20130816184917.GQ2133@tuxdriver.com> (sfid-20130817_003024_202613_D7A7CFD7)
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 16, 2013 at 01:06:01PM +0200, Johannes Berg wrote:
> John,
> 
> For iwlwifi-next I also have some new code...
> 
> This time I have some powersave work (notably uAPSD support), CQM
> offloads, support for a new firmware API and various code cleanups.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit ef4394b9477f9078d78ae3e8359eae094c9b19d8:
> 
>   iwlwifi: mvm: use designated initialization for some arrays (2013-08-06 10:35:04 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to 89716344806bd49d213ad5960661e8c2d38c4982:
> 
>   iwlwifi: mvm: Add PBW snoozing enablement (2013-08-16 12:13:28 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
