Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37395 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYH1KgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:36:19 -0400
Subject: Re: [PATCH 07/11] iwlwifi: generic init calibrations framework
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-3-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-4-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-5-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-6-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-7-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-8-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:36:17 +0200
Message-Id: <1219926977.6064.21.camel@californication> (sfid-20080828_123622_664754_988FC89C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> This patch fixes a critical bug that only the last calibration result
> was applied. On reception of one calibration result all the calibration
> was freed. The patch fixes this problem by introducing a generic init
> calibration framework which allows variable number of init calibrations
> and allows addition new HW.

a lot of code changes in -rc4 phase. Please give more details since the
patch changes a lot and even introduces a new EXPORT.

Regards

Marcel


