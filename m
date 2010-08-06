Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52278 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935823Ab0HFT3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 15:29:42 -0400
Date: Fri, 6 Aug 2010 15:17:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: Patches not make into wireless-next
Message-ID: <20100806191708.GC2753@tuxdriver.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
 <1280590452-10655-4-git-send-email-wey-yi.w.guy@intel.com>
 <1281100480.3853.424.camel@jlt3.sipsolutions.net>
 <1281106291.22150.2.camel@wwguy-ubuntu>
 <1281121153.4294.2.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1281121153.4294.2.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 06, 2010 at 11:59:13AM -0700, Guy, Wey-Yi wrote:
> Hi John,
> 
> Number of patches not make into wireless-next-2.6 last week
> 
> iwlwifi: make iwl_set_hw_params static to _agn
> iwlwifi: separate thermal throttling function
> iwlagn: log pci revision id
> iwlwifi: make iwl_hw_detect static to _agn
> 
> 
> I need to re-work "thermal-throttling" patch to include Johanne's fix,
> how about other patches, any recommendation?
> 
> Thanks
> Wey

I'm not merging any non-fix patches at the moment.  That activity
will resume at or about the time that 2.6.36-rc1 is released.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
