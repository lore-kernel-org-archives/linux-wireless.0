Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48277 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3C0Pao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 11:30:44 -0400
Date: Wed, 27 Mar 2013 11:28:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-03-26
Message-ID: <20130327152850.GC1868@tuxdriver.com> (sfid-20130327_163047_769095_7F478E3B)
References: <1364290290.8319.6.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1364290290.8319.6.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 26, 2013 at 10:31:30AM +0100, Johannes Berg wrote:
> Hi John,
> 
> It looks like I forgot to send this pull-request earlier ...
> 
> I have three little fixes to the driver from Emmanuel. One addresses a
> small bug Ben Hutchings found during the stable review process and two
> address some warnings in the driver when RF-Kill is asserted.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> 
> The following changes since commit 2470b36e84a2e680d7a7e3809cbceae5bfae3606:
> 
>   iwlwifi: mvm: don't warn on normal BAR sending (2013-03-04 13:39:02 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 2d5d50ee596361566f7f84300117cba7d7672bc5:
> 
>   iwlwifi: dvm: don't send HCMD in restart flow (2013-03-20 12:10:57 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
