Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47898
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754374AbYDWLAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 07:00:17 -0400
Date: Wed, 23 Apr 2008 04:00:19 -0700 (PDT)
Message-Id: <20080423.040019.239111304.davem@davemloft.net> (sfid-20080423_130105_234910_04C71EEA)
To: tomas.winkler@intel.com
Cc: torvalds@linux-foundation.org, linville@tuxdriver.com,
	reinette.chatre@intel.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
From: David Miller <davem@davemloft.net>
In-Reply-To: <1208948327-23894-1-git-send-email-tomas.winkler@intel.com>
References: <1208948327-23894-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>
Date: Wed, 23 Apr 2008 13:58:47 +0300

> This patch fixes problem in Makefile that prevented
> built-in compilation of iwlcore
> 
> Commit that caused this problem: eadd3c4b
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Yi Zhu <yi.zhu@intel.com>

I already applied the corrected version of your patch,
no need to resend this.  See my reply to your first
posting.

