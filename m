Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52552 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYH1K0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 06:26:51 -0400
Subject: Re: [PATCH 01/11] iwlwifi: W/A for the TSF correction in IBSS
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
	 <1219915510-3647-2-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 14:26:47 +0200
Message-Id: <1219926408.6064.7.camel@californication> (sfid-20080828_122704_434588_B32C2E5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> This patch is a W/A for the TSF sync issue, in which the ucode's timestamp
> is constantly a little behind incoming beacons' timestamps (in IBSS cells).
> The W/A simply stops the driver from declaring it has a reliable TSF value.

this is not a proper commit message for something that should go in
after the merge window. Besides the description of what the patch is
doing and why, you also need to justify its inclusion. So add a
paragraph that explain the impact if this patch doesn't gets merged and
why that is a regression.

If I would be in Dave's shoes, this looks like something that is not
really critical.

Regards

Marcel


