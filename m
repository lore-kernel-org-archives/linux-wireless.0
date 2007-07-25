Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3395 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXGYUfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:35:34 -0400
Date: Wed, 25 Jul 2007 16:07:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please pull patch-bomb for iwlwifi
Message-ID: <20070725200721.GH7093@tuxdriver.com>
References: <20070725085754.GA670@mail.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070725085754.GA670@mail.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 25, 2007 at 04:57:54PM +0800, Zhu Yi wrote:

> This patch series catches wireless-dev up to the stand-alone
> iwlwifi tree version 0.1.3.
> 
> There are totally 117 patches so I won't post them one by one on
> the list. Please find the commit series for the changes in the
> patch bomb:
> 
>     iwlwifi-efe55d8fa702a23724bf44fdd54059f8c4480941.tgz
> at
>     http://intellinuxwireless.org/iwlwifi/patches/
> 
> This is based on wireless-dev commit:
> 
>     3382ada69e6796da1675b0c5d064a472e9db2822
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

I have applied these to the wireless-dev tree.  It is available now:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

Does the current driver (as posted) depend on mac80211 patches which
are not upstream at this time?

Do you believe that you have addressed the bulk of the review comments
from the previous posting?

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
