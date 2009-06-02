Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42588 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbZFBHwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 03:52:31 -0400
Date: Tue, 2 Jun 2009 09:54:43 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Message-ID: <20090602075439.GA4376@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com> <1243307448-17441-2-git-send-email-yi.zhu@intel.com> <20090601182940.GC3386@tuxdriver.com>
MIME-Version: 1.0
In-Reply-To: <20090601182940.GC3386@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Mon, Jun 01, 2009 at 11:29:40AM -0700, John W. Linville wrote:
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
I havent heard anything from Greg regarding my firmware name length patch set.
I'll ping him and check if the patches are queued for rc1 inclusion.
Meanwhile I think you can leave this one aside for now, thanks.

Cheers,
Samuel.


> -- 
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.

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

