Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYLWC5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 21:57:08 -0500
Subject: Re: [PATCH 10/10] iwl3945: use rx queue management infrastructure
	from iwlcore
From: Zhu Yi <yi.zhu@intel.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <87r640s3ph.fsf@litku.valot.fi>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-10-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-11-git-send-email-yi.zhu@intel.com>
	 <87r640s3ph.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 10:58:37 +0800
Message-Id: <1230001118.2570.35.camel@debian.sh.intel.com> (sfid-20081223_035712_934818_23F45DB0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-22 at 22:07 +0800, Kalle Valo wrote:
> Yes, ifconfig up works but now iwlist wlan0 scan crashes. I just
> tested this once due to lack of time.
> 
> I hope I get my wifi working before Christmas ;)

http://marc.info/?l=linux-wireless&m=123000088608330&w=2 should fix the
problem. Thanks a lot for your testing.

Thanks,
-yi

