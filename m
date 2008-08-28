Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52563 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYH1K3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:29:21 -0400
Subject: Re: [PATCH 03/11] iwlwifi: fix hidden ssid discovery in passive
	channels
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Cahill Ben <ben.m.cahill@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:29:18 +0200
Message-Id: <1219926558.6064.11.camel@californication> (sfid-20080828_122924_901828_25E53492)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> This patch gives the HW the possibility to send direct probes in passive
> channels (as long as traffic was detected in that channel) if such ssid
> was requested, so hidden ssid can be found now in those channels as well.

this also doesn't sound like a regression to me. Nice to have for sure,
but not acceptable according to the merge window rules.

Question here is was the driver supporting this before and we broke it
in the 2.6.27 phase or not.

Regards

Marcel


