Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbZEZGzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 02:55:24 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1243319583.30938.2.camel@localhost.localdomain>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <1243312991.21383.3.camel@localhost.localdomain>
	 <1243317777.3623.19.camel@debian>
	 <1243319583.30938.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 26 May 2009 14:47:34 +0800
Message-Id: <1243320454.3623.35.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 14:33 +0800, Marcel Holtmann wrote:
> > FIRMWARE_NAME_MAX is defined 30 at this time.
> 
> I think we need to fix this. Especially since all the other name
> length limits in the driver model are gone.

I agree. Should we fix this by simply increasing FIRMWARE_NAME_MAX to
some acceptable length (what should it be? btw) or there are other
better ideas?

Anyway, I think whatever how we change FW_LOADER, this patch should
still go. Because the "lmac" string doesn't make any sense in this file
name due to calibration is only done in LMAC.

Thanks,
-yi

