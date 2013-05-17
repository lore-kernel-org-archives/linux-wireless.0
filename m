Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52976 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3EQSaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 14:30:08 -0400
Date: Fri, 17 May 2013 14:22:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-05-16
Message-ID: <20130517182244.GB2012@tuxdriver.com> (sfid-20130517_203027_436391_3449C7FA)
References: <1368737965.8253.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1368737965.8253.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 16, 2013 at 10:59:25PM +0200, Johannes Berg wrote:
> John,
> 
> And another one for iwlwifi, much fewer commits though.
> 
> I have fixes for a firmware crash during resume, multicast RX,
> aggregation and a workaround for a firmware scanning bug.
> 
> Please pull. Thanks,
> johannes
> 
> 
> 
> The following changes since commit 61f1598278876527314f5fc1d00cf0a4d525c1f7:
> 
>   Merge branch 'wireless' (2013-05-10 09:44:05 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to e3d4bc8cc0230e8dc8033484666f03f87392a8c4:
> 
>   iwlwifi: mvm: fix aggregation drain flow (2013-05-16 22:39:07 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
