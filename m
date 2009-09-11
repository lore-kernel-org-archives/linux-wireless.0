Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbZIKRsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:48:51 -0400
Subject: Re: [PATCH 13/13 v2.6.32 and w-t] iwlwifi: disable powersave for
 4965
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1252690699-25796-14-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
	 <1252690699-25796-14-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 10:48:54 -0700
Message-Id: <1252691334.30150.400.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-09-11 at 10:38 -0700, Chatre, Reinette wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> 
> There's a bug in 4965 powersave that appears to
> be related to the way it keeps track of its data
> during sleep, but we haven't found it yet. Due to
> that, using powersave may spontaneously cause the
> device to SYSASSERT when transitioning from sleep
> to wake. Therefore, disable powersave for 4965,
> until (if ever, unfortunately) we can identify
> and fix the problem.
> 
> Cf. http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1982
> which was closed, but now has re-appeared with
> IDLE mode, which probably means we never really
> fixed it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

This patch only applies to wireless-testing (as it is based on an
earlier patch in this series that does not target 2.6.32). I will send a
different version that applies cleanly onto 2.6.32.

Sorry for inconvenience.

Reinette


