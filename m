Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51072 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYJFVPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 17:15:40 -0400
Date: Mon, 6 Oct 2008 17:15:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 2/7] iwlwifi: fix ct kill configuration for 5350
Message-ID: <20081006211501.GI3448@tuxdriver.com> (sfid-20081006_231543_350947_607A1A4C)
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com> <1223280333-4383-2-git-send-email-yi.zhu@intel.com> <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 04:05:28PM +0800, Zhu Yi wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> 
> This patch fixes ct kill configuration for 5350.

How about "we need to use the temperature units that the hardware
expects for its critical temperature setting"?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
