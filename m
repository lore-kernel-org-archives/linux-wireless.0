Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3916 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374AbYFLOHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 10:07:03 -0400
Date: Thu, 12 Jun 2008 09:59:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
Message-ID: <20080612135936.GA5031@tuxdriver.com> (sfid-20080612_160707_406717_273DB365)
References: <484FEA26.1040305@gmail.com> <1213241315.7814.696.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213241315.7814.696.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 11:28:35AM +0800, Zhu Yi wrote:

> I don't understand why "disable_hw_scan=1" works for you. Can you also
> attach the dmesg for it?

How does the hardware scan differ from what mac80211 does when
scanning?  I still see a lot of mysterious iwlwifi (especially iwl3945)
problems in Fedora that seem to disappear with disable_hw_scan=1.

Honestly I'm tempted to change it to "enable_hw_scan" instead...

John
-- 
John W. Linville
linville@tuxdriver.com
