Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43982 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYKGSSX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 13:18:23 -0500
Subject: Re: [PATCH 09/13] iwl3945 : Fix Sparse Warnings
From: reinette chatre <reinette.chatre@intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1226081276.11596.24.camel@brick>
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
	 <1226081276.11596.24.camel@brick>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 10:18:55 -0800
Message-Id: <1226081935.1115.688.camel@rc-desk> (sfid-20081107_191826_852814_5C7183FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-07 at 10:07 -0800, Harvey Harrison wrote:
> On Fri, 2008-11-07 at 09:58 -0800, Reinette Chatre wrote:
> > From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>
> >
> > Patch fixes sparse warnings. No need to convert u8 variable
> > to 32.
> >
> > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> 
> It's customary to put the actual sparse warnings being fixed in the
> commit message.  

sorry - will do next time.

> In this case I assume it was this:
> 
> drivers/net/wireless/iwlwifi/iwl3945-base.c:4838:18: warning: invalid assignment: |=
> drivers/net/wireless/iwlwifi/iwl3945-base.c:4838:18:    left side has type unsigned char
> drivers/net/wireless/iwlwifi/iwl3945-base.c:4838:18:    right side has type restricted __le32

yes ... this is the warning being fixed.

Thanks for the review

Reinette

