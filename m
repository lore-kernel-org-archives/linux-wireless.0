Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37375 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYH1Kc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:32:28 -0400
Subject: Re: [PATCH 05/11] iwlwifi: workaround interrupt handling no some
	platforms
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:32:26 +0200
Message-Id: <1219926746.6064.16.camel@californication> (sfid-20080828_123231_057503_175E1590)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> This patch adds workaround for an interrupt related hardware bug on
> some platforms.

this one should go in, but since this is a workaround, I would expect
some more details why we did this. Either in the commit message or the
comment and it is a good idea to be specific. What platforms. At least
give an example.

Regards

Marcel


