Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43364
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755309AbYICDgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:36:41 -0400
Date: Tue, 02 Sep 2008 20:36:34 -0700 (PDT)
Message-Id: <20080902.203634.127434142.davem@davemloft.net> (sfid-20080903_053700_116690_FBA2DB98)
To: yi.zhu@intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, emmanuel.grumbach@intel.com
Subject: Re: [PATCH 4/9] iwlwifi: generic init calibrations framework
From: David Miller <davem@davemloft.net>
In-Reply-To: <1220411930-15216-5-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-3-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-4-git-send-email-yi.zhu@intel.com>
	<1220411930-15216-5-git-send-email-yi.zhu@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>
Date: Wed,  3 Sep 2008 11:18:45 +0800

> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch fixes a critical bug that only the last calibration result
> was applied. On reception of one calibration result all the calibration
> results were freed therefore only last was applied. The patch fixes this
> problem by introducing a generic init calibration framework which allows
> variable number of init calibrations and allows addition new HW.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

This is borderline, I would rather hold off on such a sizable change
for 2.6.27 as I'll have a hard time justifying it.
