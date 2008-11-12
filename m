Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55966 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYKLVbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:31:11 -0500
Date: Wed, 12 Nov 2008 16:29:00 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
Message-ID: <20081112212900.GI2411@tuxdriver.com> (sfid-20081112_223116_030245_8034D4A8)
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com> <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com> <20081106134950.GB14184@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081106134950.GB14184@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 06, 2008 at 08:49:50AM -0500, John W. Linville wrote:
> On Wed, Nov 05, 2008 at 11:17:22PM +0100, Marcel Holtmann wrote:
> 
> >> This patch is related to bug 11870 at bugzilla.kernel.org. With
> >> correct regulatory information the number of channels to scan
> >> will be correct and not zero as seen in that bug.
> >>
> >> This patch eliminates the need for wireless to be compiled with
> >> CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
> >> iwlwifi.
> >
> > so this is still for 2.6.28, but for 2.6.29 and wireless-testing the API 
> > changed and we need a separate or different patch.
> >
> > John, Dave what is your take on pushing this to Linus this late in the  
> > merge window? I personally think we should do that. And if not, then  
> > change the Intel wireless Kconfig to select  
> > CONFIG_WIRELESS_OLD_REGULATORY by default at least.
> 
> CONFIG_WIRELESS_OLD_REGULATORY is already 'default y' now.  I don't
> really see why iwlwifi should _require_ that if someone decides to
> choose a non-default configuration.

In case this was unclear, I'm dropping these patches for 2.6.28.
The original post said different patches are needed for -next anyway.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
