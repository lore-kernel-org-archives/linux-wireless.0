Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43936 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYHEGgv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 02:36:51 -0400
Subject: Re: [PATCH 00/10] iwlwifi driver 08/04 updates
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 14:36:37 +0800
Message-Id: <1217918197.3107.64.camel@debian.sh.intel.com> (sfid-20080805_083656_697318_D69B2DF7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 16:00 +0800, Zhu Yi wrote:
> Hi John,
> 
> Here is another series of iwlwifi driver update. Note, the patch 10/10 fixes
> a merge problem for wireless-testing GIT with upstream.
> 
> Thanks,
> -yi
> 
> [PATCH 01/10] iwlwifi: HW bug fixes
> [PATCH 02/10] iwlwifi: memory allocation optimization
> [PATCH 03/10] iwlwifi: kill struct iwl4965_lq_mngr
> [PATCH 04/10] iwlwifi: implement iwl5000_calc_rssi
> [PATCH 05/10] iwlwifi: fix unhandled interrupt when HW rfkill is on
> [PATCH 06/10] iwlwifi: cleanup iwl_tx_skb
> [PATCH 07/10] iwlwifi: add level for debugging host command
> [PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler
> [PATCH 09/10] iwlwifi: grap nic access before accessing periphery registers
> [PATCH 10/10] iwl3945: fix merge mistake for packet injection

Hi John,

I see you merged only partial of this series. What's happen to the
patches 03, 06 and 07?

Thanks,
-yi

