Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19176 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbZFBHwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 03:52:24 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <20090601182940.GC3386@tuxdriver.com>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <20090601182940.GC3386@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 15:52:20 +0800
Message-Id: <1243929140.5799.18.camel@joice>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-01 at 19:29 +0100, John W. Linville wrote:
> On Tue, May 26, 2009 at 11:10:47AM +0800, Zhu Yi wrote:
> > From: Samuel Ortiz <samuel.ortiz@intel.com>
> > 
> > Firmware names can not be longer than 30 characters, and
> > iwmc3200wifi-lmac-calib-sdio.bin is too long.
> > Renaming it to iwmc3200wifi-calib-sdio.bin.
> > 
> > Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> 
> Is this still wanted?

Yes, it is still wanted, but probably with a better description:


From: Samuel Ortiz <samuel.ortiz@intel.com>

iwmc3200wifi: trim down calibration firmware name

The patch trims down iwmc3200wifi calibration firmware name from
iwmc3200wifi-lmac-calib-sdio.bin to iwmc3200wifi-calib-sdio.bin. We can
shorten the firmware name because all calibration is done by LMAC.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>


Thanks,
-yi



