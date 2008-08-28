Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52559 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYH1K2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:28:01 -0400
Subject: Re: [PATCH 02/11] iwlwifi: use mac80211 band and channel settings
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:27:58 +0200
Message-Id: <1219926478.6064.9.camel@californication> (sfid-20080828_122808_137449_5AB9EAE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> This patch makes use of mac80211 defaults for channel and band settings
> instead of setting them by the driver own. The iwlwifi driver used to
> set G band channel 6 as the default channel.

that is not a regression. The driver has been doing this until now and
thus it can keep doing it until the next merge window.

If you disagree, then please explain the regression in the commit
message.

Regards

Marcel


