Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64925 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761703Ab0HFS4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:56:03 -0400
Subject: Patches not make into wireless-next
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1281106291.22150.2.camel@wwguy-ubuntu>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1280590452-10655-4-git-send-email-wey-yi.w.guy@intel.com>
	 <1281100480.3853.424.camel@jlt3.sipsolutions.net>
	 <1281106291.22150.2.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 11:59:13 -0700
Message-ID: <1281121153.4294.2.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Number of patches not make into wireless-next-2.6 last week

iwlwifi: make iwl_set_hw_params static to _agn
iwlwifi: separate thermal throttling function
iwlagn: log pci revision id
iwlwifi: make iwl_hw_detect static to _agn


I need to re-work "thermal-throttling" patch to include Johanne's fix,
how about other patches, any recommendation?

Thanks
Wey

