Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZFBIHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:07:21 -0400
Date: Tue, 2 Jun 2009 10:09:33 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Message-ID: <20090602080924.GB4376@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com> <1243307448-17441-2-git-send-email-yi.zhu@intel.com> <20090601182940.GC3386@tuxdriver.com> <1243929140.5799.18.camel@joice>
MIME-Version: 1.0
In-Reply-To: <1243929140.5799.18.camel@joice>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 12:52:20AM -0700, Zhu, Yi wrote:
> On Mon, 2009-06-01 at 19:29 +0100, John W. Linville wrote:
> > On Tue, May 26, 2009 at 11:10:47AM +0800, Zhu Yi wrote:
> > > From: Samuel Ortiz <samuel.ortiz@intel.com>
> > > 
> > > Firmware names can not be longer than 30 characters, and
> > > iwmc3200wifi-lmac-calib-sdio.bin is too long.
> > > Renaming it to iwmc3200wifi-calib-sdio.bin.
> > > 
> > > Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> > > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > 
> > Is this still wanted?
> 
> Yes, it is still wanted, but probably with a better description:
Sorry John, an obvious lack of communication on our part here :/
I agree with Yi about the fact that our calibration firmware name is
redundant, so in that regard it does make sense to push this patch now.
Sorry again for the confusion...

Cheers,
Samuel.
 
> From: Samuel Ortiz <samuel.ortiz@intel.com>
> 
> iwmc3200wifi: trim down calibration firmware name
> 
> The patch trims down iwmc3200wifi calibration firmware name from
> iwmc3200wifi-lmac-calib-sdio.bin to iwmc3200wifi-calib-sdio.bin. We can
> shorten the firmware name because all calibration is done by LMAC.
> 
> Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> 
> 
> Thanks,
> -yi
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

