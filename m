Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52573 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYH1Ka5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:30:57 -0400
Subject: Re: [PATCH 04/11] iwlwifi: remove false rxon if rx chain changes
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:30:53 +0200
Message-Id: <1219926653.6064.13.camel@californication> (sfid-20080828_123059_157500_F0CC2923)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> Rx chain might change during power save transitions but it doesn't
> requires full rxon. The patch avoids the rxon by removing the rx_chain
> check.

and again. Is this a regression. What is the down side or impact from
not doing this. Did we used to do it different in 2.6.26?

Regards

Marcel


