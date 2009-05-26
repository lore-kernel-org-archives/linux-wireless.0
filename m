Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbZEZGou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 02:44:50 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Zhu Yi <yi.zhu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20090526063602.GA21894@infradead.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <1243312991.21383.3.camel@localhost.localdomain>
	 <1243317777.3623.19.camel@debian>
	 <1243319583.30938.2.camel@localhost.localdomain>
	 <20090526063602.GA21894@infradead.org>
Content-Type: text/plain
Date: Tue, 26 May 2009 14:36:58 +0800
Message-Id: <1243319818.3623.27.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 14:36 +0800, Christoph Hellwig wrote:
> On Tue, May 26, 2009 at 08:33:03AM +0200, Marcel Holtmann wrote:
> > I think we need to fix this. Especially since all the other name length
> > limits in the driver model are gone.
> 
> Yeah, but at the same time the driver should get a shorter and actually
> pronouncable name.  Why not just iwl3200 to follow the model set by
> the other drivers?

There are totally 3 firmware images required by the iwmc3200wifi driver:
one used for calibration, one upper mac (UMAC) and a lower mac (LMAC).
This iwmc3200 is a multicomm device, WiFi is only one of its functions.
Finally we have to add the "-sdio" suffix to distinguish with other form
factors (e.g. USB, mini PCIe, etc).

Thanks,
-yi

