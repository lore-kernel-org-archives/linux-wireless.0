Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42161 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab3CYUpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 16:45:49 -0400
Date: Mon, 25 Mar 2013 16:40:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-03-20
Message-ID: <20130325204000.GE17454@tuxdriver.com> (sfid-20130325_214615_299469_A5F74B20)
References: <1363787717.8224.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363787717.8224.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 20, 2013 at 02:55:17PM +0100, Johannes Berg wrote:
> John,
> 
> I also have a bunch of new things for iwlwifi:
> 
> Andrei changed an instance of kmalloc+memdup to kmemdup, Stanislaw
> removed the now unused 5ghz_disable module parameter. I also have a
> number of fixes from Ilan, Emmanuel and myself, Emmanuel also continued
> working on Bluetooth coexistence.
> 
> I had to merge wireless-next to get one of Ilan's patches in properly as
> it depended on a mac80211 patch.
> 
> Please pull.
> 
> johannes
> 
> 
> 
> The following changes since commit 856a850afdd778fad7ded4240d333a8c3b05b136:
> 
>   rt2800: 5592: add more USB devices IDs (2013-03-18 16:38:35 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to e635c797b3b18ffbe4ef5db27971f48b661f03bd:
> 
>   iwlwifi: mvm: Add support for different ROC types (2013-03-20 14:31:04 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
