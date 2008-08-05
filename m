Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4128 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759823AbYHENcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 09:32:19 -0400
Date: Tue, 5 Aug 2008 09:03:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/10] iwlwifi driver 08/04 updates
Message-ID: <20080805130320.GA4276@tuxdriver.com> (sfid-20080805_153223_764557_D0B8B100)
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com> <1217918197.3107.64.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217918197.3107.64.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 05, 2008 at 02:36:37PM +0800, Zhu Yi wrote:
> On Mon, 2008-08-04 at 16:00 +0800, Zhu Yi wrote:
> > Hi John,
> > 
> > Here is another series of iwlwifi driver update. Note, the patch 10/10 fixes
> > a merge problem for wireless-testing GIT with upstream.
> > 
> > Thanks,
> > -yi
> > 
> > [PATCH 01/10] iwlwifi: HW bug fixes
> > [PATCH 02/10] iwlwifi: memory allocation optimization
> > [PATCH 03/10] iwlwifi: kill struct iwl4965_lq_mngr
> > [PATCH 04/10] iwlwifi: implement iwl5000_calc_rssi
> > [PATCH 05/10] iwlwifi: fix unhandled interrupt when HW rfkill is on
> > [PATCH 06/10] iwlwifi: cleanup iwl_tx_skb
> > [PATCH 07/10] iwlwifi: add level for debugging host command
> > [PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler
> > [PATCH 09/10] iwlwifi: grap nic access before accessing periphery registers
> > [PATCH 10/10] iwl3945: fix merge mistake for packet injection
> 
> Hi John,
> 
> I see you merged only partial of this series. What's happen to the
> patches 03, 06 and 07?

I don't see those as fixes, only cleanups.  The merge window is closed
for 2.6.27.  If those are in fact fixes then please explain.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
