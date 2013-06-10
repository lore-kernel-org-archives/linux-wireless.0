Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43941 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3FJTpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 15:45:10 -0400
Date: Mon, 10 Jun 2013 15:35:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-06-05
Message-ID: <20130610193520.GA10065@tuxdriver.com> (sfid-20130610_214514_845737_51678784)
References: <1370416113.8920.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370416113.8920.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 09:08:33AM +0200, Johannes Berg wrote:
> Hi,
> 
> And just like the fixes for old code never end, also the fixes for new
> code :-) But I also have some new features. I also had to merge
> wireless-next to get a cfg80211 change that the D3 test feature depends
> on.
> 
> Here I mostly have various fixes for AP/GO mode, Bluetooth coexistence
> and power save modes. The only new thing is the introduction of "D3
> test" mode, accessible through debugfs for D3 firmware debugging.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> The following changes since commit a910e4a94f6923c8c988565525f017f687bf7205:
> 
>   cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets (2013-05-29 15:26:40 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to fded313ec045024d4f769ce6b3e41fe343c167b0:
> 
>   iwlwifi: mvm: don't request SMPS on non-STA iface (2013-06-05 09:06:13 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
