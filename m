Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27186 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYLFHZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 02:25:25 -0500
Subject: Re: [PATCH 3/6] iwlwifi: fix time interval misuse in
	iwl_poll_{direct_}bit
From: reinette chatre <reinette.chatre@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>, "Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1228502611.28839.35.camel@violet.holtmann.net>
References: <> <1228492721-27381-1-git-send-email-reinette.chatre@intel.com>
	 <1228492721-27381-2-git-send-email-reinette.chatre@intel.com>
	 <1228492721-27381-3-git-send-email-reinette.chatre@intel.com>
	 <1228492721-27381-4-git-send-email-reinette.chatre@intel.com>
	 <1228502611.28839.35.camel@violet.holtmann.net>
Content-Type: text/plain
Date: Fri, 05 Dec 2008 23:26:23 -0800
Message-Id: <1228548383.26014.43.camel@rc-desk> (sfid-20081206_082529_715001_D12ABFC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-12-05 at 10:43 -0800, Marcel Holtmann wrote:
> Hi Reinette,
> 
> > The patch fixes the misuse of microsecond with millisecond in the
> > polling mechanism of the iwlwifi driver. The impact of this problem
> > is the unacceptable latency for the whole system (especially during
> > bringing down the wlan interface).
> 
> I will test the whole set of patches again, but as already mentioned
> this is making the situation worse than better.
> 

Please let us know the test results. These patches are necessary and the
system latency issue has improved significantly for other users (please
see feedback in
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790 ). There
may thus be other problems in your system that still needs to be
addressed.

Reinette

