Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48144 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbYLESne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 13:43:34 -0500
Subject: Re: [PATCH 3/6] iwlwifi: fix time interval misuse in
 iwl_poll_{direct_}bit
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
References: <> <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
	 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
	 <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
	 <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 19:43:31 +0100
Message-Id: <1228502611.28839.35.camel@violet.holtmann.net> (sfid-20081205_194336_742952_B95569FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> The patch fixes the misuse of microsecond with millisecond in the
> polling mechanism of the iwlwifi driver. The impact of this problem
> is the unacceptable latency for the whole system (especially during
> bringing down the wlan interface).

I will test the whole set of patches again, but as already mentioned
this is making the situation worse than better.

Regards

Marcel


