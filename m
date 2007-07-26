Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18721 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXGZB5u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 21:57:50 -0400
Subject: Re: Please pull patch-bomb for iwlwifi
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070725200721.GH7093@tuxdriver.com>
References: <20070725085754.GA670@mail.intel.com>
	 <20070725200721.GH7093@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 09:55:42 +0800
Message-Id: <1185414943.3131.53.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-25 at 16:07 -0400, John W. Linville wrote:
> 
> I have applied these to the wireless-dev tree.  It is available now:
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

Thanks. I also see you move it to the drivers/net/wireless. Good!

> Does the current driver (as posted) depend on mac80211 patches which
> are not upstream at this time?

The code requires those mac80211 features are all protected by ifdef
CONFIG_IWLWIFI_HT or CONFIG_IWLWIFI_HT_AGG, which are not enabled this
time. When the mac80211 HT and AGG features are reviewed and merged, we
will make iwlwifi HT feature selectable in Kconfig.

> Do you believe that you have addressed the bulk of the review comments
> from the previous posting?

I think so. Especially thanks to Adel Gadllah and Ian Schram, they
helped to address lots of review items from Jeff and Andrew. I cannot
confirm it's 100% done but at least most of them. BTW, we also have
developers running PowerPC, so endian issues will also be addressed in
practice more than good habit of coding.

Thanks,
-yi
