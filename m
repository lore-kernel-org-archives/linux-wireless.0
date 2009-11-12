Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39687 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZKLGTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 01:19:35 -0500
Subject: Re: [PATCH 1/2] ipw2100: Register the wiphy device
From: Zhu Yi <yi.zhu@intel.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <1257968191-495-1-git-send-email-mjg@redhat.com>
References: <1257968191-495-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain
Date: Thu, 12 Nov 2009 14:19:27 +0800
Message-Id: <1258006767.31116.53.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-12 at 03:36 +0800, Matthew Garrett wrote:
> libipw unconditionally calls wiphy_unregister, but it's up to the driver
> to register it in the first place. ipw2100 fails to do so. Add the necessary
> glue code, and also ensure that rfkill statuses get set up appropriately.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks for the fix. BTW, have you already tried [1] for the firmware
missing case?

1. http://marc.info/?l=linux-wireless&m=125775901909164&w=2

Thanks,
-yi

