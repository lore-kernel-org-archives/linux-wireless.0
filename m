Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:56662 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYDJI0L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 04:26:11 -0400
Date: Thu, 10 Apr 2008 11:26:09 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com
Subject: iwlwifi integer overflow warnings
Message-ID: <Pine.SOC.4.64.0804101121160.13294@math.ut.ee> (sfid-20080410_092619_747927_C5C7E259)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(In case anyone is interested)

This is todays 2.6.25-rc8+git on ppc (not powerpc) arch (32-bit),
gcc version 4.3.1 20080401 (prerelease) (Debian 4.3.0-3)

drivers/net/wireless/iwlwifi/iwl3945-base.c: In function 'iwl3945_enqueue_hcmd':
drivers/net/wireless/iwlwifi/iwl3945-base.c:719: warning: integer overflow in expression
drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_add_radiotap':
drivers/net/wireless/iwlwifi/iwl-3945.c:326: warning: integer overflow in expression
drivers/net/wireless/iwlwifi/iwl4965-base.c: In function 'iwl4965_enqueue_hcmd':
drivers/net/wireless/iwlwifi/iwl4965-base.c:723: warning: integer overflow in expression
drivers/net/wireless/iwlwifi/iwl-4965.c: In function 'iwl4965_add_radiotap':
drivers/net/wireless/iwlwifi/iwl-4965.c:3617: warning: integer overflow in expression

-- 
Meelis Roos (mroos@linux.ee)
