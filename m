Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbYFLDeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 23:34:37 -0400
Subject: Re: [ipw3945-devel] [IWLWIFI] Few questions about its advanced
	features
From: Zhu Yi <yi.zhu@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <484FF44A.6070004@gmail.com>
References: <200806062259.02955.maximlevitsky@gmail.com>
	 <484FF44A.6070004@gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 11:34:13 +0800
Message-Id: <1213241653.7814.701.camel@debian.sh.intel.com> (sfid-20080612_053440_799066_19FF115F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-11 at 18:50 +0300, Maxim Levitsky wrote:
> My question is, are there plans to add AP mode to iwlwifi?

You can find a working AP based on an old version of mac80211 at this
point. We will port the code to latest mac80211 after 5000 is merged.
http://kernel.org/pub/linux/kernel/people/chuyee/wireless/iwl4965_ap/

Thanks,
-yi

