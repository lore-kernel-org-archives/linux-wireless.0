Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43747 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZJLTBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 15:01:50 -0400
Date: Mon, 12 Oct 2009 14:59:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>
Subject: Re: [PATCH 02/17 v2.6.32] iwl3945: update iwl3945_apm_init()
Message-ID: <20091012185943.GC2794@tuxdriver.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com> <1255119634-3060-3-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255119634-3060-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 09, 2009 at 01:20:18PM -0700, Reinette Chatre wrote:
> From: Ben Cahill <ben.m.cahill@intel.com>
> 
> Update iwl3945_apm_init() to set up device registers in sequence most recently
> recommended by factory.
> 
> Add resets for APMG interrupts and radio chip, formerly done only in
> iwl3945_apm_reset(); moving them here assures that apm_init() will do
> a complete job of preparing hardware not only after platform boot,
> but also after apm_stop() has executed (due to rfkill, ifconfig down,
> driver unload, etc.).  This is in preparation to completely remove apm_reset().
> 
> Add some comments.
> 
> Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Is this actually a regression?  Can you provide a reference to the bug report?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
