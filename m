Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYKFBHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 20:07:16 -0500
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
References: <> <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 09:07:51 +0800
Message-Id: <1225933671.2604.97.camel@debian.sh.intel.com> (sfid-20081106_020720_497016_A018A86F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-11-06 at 06:17 +0800, Marcel Holtmann wrote:
> so this is still for 2.6.28, but for 2.6.29 and wireless-testing the  
> API changed and we need a separate or different patch.
> 
> John, Dave what is your take on pushing this to Linus this late in
> the  
> merge window? I personally think we should do that. And if not, then  
> change the Intel wireless Kconfig to select  
> CONFIG_WIRELESS_OLD_REGULATORY by default at least.

Agreed.

Thanks,
-yi

