Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39989 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaKXTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 14:15:08 -0500
Date: Mon, 24 Nov 2014 14:00:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-11-24
Message-ID: <20141124190031.GD12375@tuxdriver.com> (sfid-20141124_201514_063942_469E4F18)
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2014 at 04:34:02PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> I have a big batch here. New features were unblocked by the merge a
> few patches in mac80211-next.git and I was away for 2 weeks.
> I plan to have another pull request for wireless-next before the merge
> window opens.
> Details below - please pull.
> 
> Thanks,
> 
> The following changes since commit 9e6f3f472c8f95021ad048acc7cd3e40a827f8ce:
> 
>   mwifiex: Add USB8766 support (2014-11-20 16:14:39 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> tags/iwlwifi-next-for-john-2014-11-24
> 
> for you to fetch changes up to dcad8e4299bf81f8795b44677036dfa490c9fb15:
> 
>   iwlwifi: update the secure mem space and for the CPUs (2014-11-24
> 08:30:44 +0200)
> 
> ----------------------------------------------------------------
> Major works are CSA and TDLS. On top of that I have a new
> firmware API for scan and a few rate control improvements.
> Johannes find a few tricks to improve our CPU utilization
> and adds support for a new spin of 7265 called 7265D.
> Along with this a few random things that don't stand out.

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
