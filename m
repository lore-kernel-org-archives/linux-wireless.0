Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60813 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbYKLVqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:46:12 -0500
Date: Wed, 12 Nov 2008 16:33:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Frank Seidel <fseidel@suse.de>
Cc: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, yi.zhu@intel.com,
	reinette.chatre@intel.com, ipw2100-devel@lists.sourceforge.net
Subject: Re: Problem with Kernel Oops in ipw2200
Message-ID: <20081112213350.GJ2411@tuxdriver.com> (sfid-20081112_224617_010636_FDBFA0F8)
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49131173.3010409@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 06, 2008 at 04:46:59PM +0100, Frank Seidel wrote:
> Frank Seidel schrieb:
> > Ever suggestion is very appreciated.
> 
> My first search through the ipw2200 logs pointed
> me to Davids last commit (521c4d96e0840ecce25b956e00f416ed499ef2ba)
> and really after reverting it the problem disappeared here.
> The patch from my last post was the smallest subset of
> the revertion that still works for me here.
> Any comments?

I think it would be better to make sure that ipw2200 (and/or
ieee80211) is properly using netif_carrier_{on,off}() instead?

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
