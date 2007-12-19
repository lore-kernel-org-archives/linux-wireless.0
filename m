Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbXLSGDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:03:16 -0500
Subject: Re: [PATCH] iwlwifi: fix possible priv->mutex deadlock during
	suspend
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1198043992-23821-1-git-send-email-yi.zhu@intel.com>
References: <1198043992-23821-1-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 14:01:29 +0800
Message-Id: <1198044089.2857.317.camel@debian.sh.intel.com> (sfid-20071219_060318_747118_64B39F4A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-19 at 13:59 +0800, Zhu Yi wrote:
> This patch moves _cancel_deferred_work out of mutex protection and
> removes
> unnecessary mutex in pci_suspend and pci_resume.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

The one is for 2.6.24.

Thanks,
-yi

