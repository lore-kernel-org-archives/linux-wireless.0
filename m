Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32395 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZFBIV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:21:57 -0400
Date: Tue, 2 Jun 2009 10:24:07 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Message-ID: <20090602082403.GC4376@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com> <1243307448-17441-2-git-send-email-yi.zhu@intel.com> <20090601182940.GC3386@tuxdriver.com> <20090602075439.GA4376@sortiz.org> <1243929723.3192.44.camel@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <1243929723.3192.44.camel@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 01:02:03AM -0700, Marcel Holtmann wrote:
> Hi Samuel,
> 
> > > > Firmware names can not be longer than 30 characters, and
> > > > iwmc3200wifi-lmac-calib-sdio.bin is too long.
> > > > Renaming it to iwmc3200wifi-calib-sdio.bin.
> > > > 
> > > > Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> > > > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > > 
> > > Is this still wanted?
> > I havent heard anything from Greg regarding my firmware name length patch set.
> > I'll ping him and check if the patches are queued for rc1 inclusion.
> > Meanwhile I think you can leave this one aside for now, thanks.
> 
> actually we have to get the firmware straight before 2.6.31-rc1 hits the
> streets. So at some point we have to make up our mind ;)
Yep, we lacked some synchronization with Yi.


> Either way is fine btw. and fixing the firmware name length limitation
> is also the right thing to do. 
Yes, that needed a fix, regardless of our local iwmc issues. I also agree with
Yi that our calibration firmware name is too long/verbose and needs to be
shortened. So both fixes should go in I think.


> Cutting the name because of a bogus
> legacy limitation was just the wrong fix here ;)
I agree, I was just too lazy to fix the firmware class stuff at first :/

Cheers,
Samuel.

> Regards
> 
> Marcel
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

