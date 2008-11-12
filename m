Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYKLVoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:44:30 -0500
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20081112212900.GI2411@tuxdriver.com>
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
	 <20081106134950.GB14184@tuxdriver.com>
	 <20081112212900.GI2411@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 13:45:04 -0800
Message-Id: <1226526304.1115.890.camel@rc-desk> (sfid-20081112_224433_845434_2A148918)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-12 at 13:29 -0800, John W. Linville wrote:
> On Thu, Nov 06, 2008 at 08:49:50AM -0500, John W. Linville wrote:
> > On Wed, Nov 05, 2008 at 11:17:22PM +0100, Marcel Holtmann wrote:
> > 
> > >> This patch is related to bug 11870 at bugzilla.kernel.org. With
> > >> correct regulatory information the number of channels to scan
> > >> will be correct and not zero as seen in that bug.
> > >>
> > >> This patch eliminates the need for wireless to be compiled with
> > >> CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
> > >> iwlwifi.
> > >
> > > so this is still for 2.6.28, but for 2.6.29 and wireless-testing the API 
> > > changed and we need a separate or different patch.
> > >
> > > John, Dave what is your take on pushing this to Linus this late in the  
> > > merge window? I personally think we should do that. And if not, then  
> > > change the Intel wireless Kconfig to select  
> > > CONFIG_WIRELESS_OLD_REGULATORY by default at least.
> > 
> > CONFIG_WIRELESS_OLD_REGULATORY is already 'default y' now.  I don't
> > really see why iwlwifi should _require_ that if someone decides to
> > choose a non-default configuration.
> 
> In case this was unclear, I'm dropping these patches for 2.6.28.

ok.

> The original post said different patches are needed for -next anyway.

The patches needed for -next was recently submitted by Luis (http://marc.info/?l=linux-wireless&m=122610969314498&w=2 ).

Reinette

