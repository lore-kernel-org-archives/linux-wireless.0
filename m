Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50983 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbZFBICZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:02:25 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Marcel Holtmann <marcel@holtmann.org>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090602075439.GA4376@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <20090601182940.GC3386@tuxdriver.com>  <20090602075439.GA4376@sortiz.org>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 10:02:03 +0200
Message-Id: <1243929723.3192.44.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> > > Firmware names can not be longer than 30 characters, and
> > > iwmc3200wifi-lmac-calib-sdio.bin is too long.
> > > Renaming it to iwmc3200wifi-calib-sdio.bin.
> > > 
> > > Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> > > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > 
> > Is this still wanted?
> I havent heard anything from Greg regarding my firmware name length patch set.
> I'll ping him and check if the patches are queued for rc1 inclusion.
> Meanwhile I think you can leave this one aside for now, thanks.

actually we have to get the firmware straight before 2.6.31-rc1 hits the
streets. So at some point we have to make up our mind ;)

Either way is fine btw. and fixing the firmware name length limitation
is also the right thing to do. Cutting the name because of a bogus
legacy limitation was just the wrong fix here ;)

Regards

Marcel


