Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37381 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYH1Kda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:33:30 -0400
Subject: Re: [PATCH 06/11] iwlwifi: fix apm_stop
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:33:27 +0200
Message-Id: <1219926807.6064.17.camel@californication> (sfid-20080828_123332_548291_DF2DF791)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> The patch fixes CSR_GP_CNTRL_REG_FLAG_INIT_DONE was set instead of
> cleared which disabled moving device to D0U state.

when was this mistake introduced. Is it a regression compared to what we
have in 2.6.26?

Regards

Marcel


